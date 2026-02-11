class LockerService {
  final dynamic _apiService; // Replace with your actual API service type

  LockerService(this._apiService);

  /// Loads and filters locker data
  Future<LockerResult> loadLocker({
    int? bookTypeFilter,
    String? sizeFilter,
    String? systemMode,
  }) async {
    try {
      final result = await _apiService.getLocker();

      if (result['success'] != true) {
        return LockerResult.error(result['error'] ?? 'Unknown error');
      }

      final data = result['data'];
      List<Map<String, dynamic>> units = _extractUnits(data);

      if (units.isEmpty) {
        return LockerResult.error('No locker units found');
      }

      // Filter units
      List<Map<String, dynamic>> filteredUnits = _filterUnits(
        units: units,
        bookTypeFilter: bookTypeFilter,
        sizeFilter: sizeFilter,
        systemMode: systemMode,
      );

      if (filteredUnits.isEmpty) {
        return LockerResult.empty('ไม่มีตู้ล็อคเกอร์ไซส์นี้');
      }

      // Mark filtered units
      final markedUnits = units.map((unit) {
        final isFiltered = filteredUnits.any((f) => f['id'] == unit['id']);
        return {...unit, '_isFiltered': isFiltered};
      }).toList();

      return LockerResult.success(markedUnits);
    } catch (e) {
      return LockerResult.error('เกิดข้อผิดพลาดในการเชื่อมต่อ: $e');
    }
  }

  /// Extract units from API response
  List<Map<String, dynamic>> _extractUnits(dynamic data) {
    List<Map<String, dynamic>> units = [];

    if (data is List && data.isNotEmpty) {
      final first = data.first;
      if (first is Map<String, dynamic>) {
        final lockerUnit = first['lockerUnit'];
        if (lockerUnit is List) {
          units = lockerUnit.map((e) => Map<String, dynamic>.from(e)).toList();
        }
      }
    } else if (data is Map<String, dynamic>) {
      final lockerUnit = data['lockerUnit'];
      if (lockerUnit is List) {
        units = lockerUnit.map((e) => Map<String, dynamic>.from(e)).toList();
      }
    }

    return units;
  }

  /// Filter units based on criteria
  List<Map<String, dynamic>> _filterUnits({
    required List<Map<String, dynamic>> units,
    int? bookTypeFilter,
    String? sizeFilter,
    String? systemMode,
  }) {
    List<Map<String, dynamic>> filtered = List.from(units);

    filtered = filtered.where((unit){
      final lockerStatus = unit['locker_status'];
      return lockerStatus == "close";
    }).toList();

    // Filter by book type
    if (bookTypeFilter != null) {
      filtered = filtered.where((unit) {
        final lockerBookType = unit['locker_booktype'];
        return lockerBookType == bookTypeFilter;
      }).toList();
    }

    // Filter by size (only for B2C mode)
    if (systemMode == 'B2C' && sizeFilter != null && sizeFilter.isNotEmpty) {
      filtered = filtered.where((unit) {
        final lockerSize = unit['lockerSize']?.toString().toLowerCase();
        final targetSize = sizeFilter.toLowerCase();
        return lockerSize == targetSize;
      }).toList();
    }

    return filtered;
  }
}

/// Result wrapper for locker operations
class LockerResult {
  final bool isSuccess;
  final bool isEmpty;
  final List<Map<String, dynamic>>? data;
  final String? errorMessage;

  LockerResult._({
    required this.isSuccess,
    required this.isEmpty,
    this.data,
    this.errorMessage,
  });

  factory LockerResult.success(List<Map<String, dynamic>> data) {
    return LockerResult._(
      isSuccess: true,
      isEmpty: false,
      data: data,
    );
  }

  factory LockerResult.empty(String message) {
    return LockerResult._(
      isSuccess: true,
      isEmpty: true,
      errorMessage: message,
    );
  }

  factory LockerResult.error(String message) {
    return LockerResult._(
      isSuccess: false,
      isEmpty: false,
      errorMessage: message,
    );
  }
}