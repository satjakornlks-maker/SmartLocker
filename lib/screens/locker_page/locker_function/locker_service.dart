import '../../../services/api_service.dart';

class LockerService {
  final ApiService _apiService;

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

  /// Extract units from API response — supports lockerUnit / locker_unit / LockerUnit
  List<Map<String, dynamic>> _extractUnits(dynamic data) {
    List<Map<String, dynamic>> units = [];

    dynamic getUnits(Map<String, dynamic> map) =>
        map['lockerUnit'] ?? map['locker_unit'] ?? map['LockerUnit'];

    if (data is List && data.isNotEmpty) {
      final first = data.first;
      if (first is Map<String, dynamic>) {
        final lockerUnit = getUnits(first);
        if (lockerUnit is List) {
          units = lockerUnit.map((e) => Map<String, dynamic>.from(e)).toList();
        }
      }
    } else if (data is Map<String, dynamic>) {
      final lockerUnit = getUnits(data);
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

    filtered = filtered.where((unit) {
      // support locker_status || lockerStatus || LockerStatus
      final lockerStatus = unit['locker_status'] ?? unit['lockerStatus'] ?? unit['LockerStatus'];
      return lockerStatus == "close";
    }).toList();

    // Filter by book type
    if (bookTypeFilter != null) {
      filtered = filtered.where((unit) {
        // support locker_booktype || lockerBooktype || lockerBookType || LockerBooktype
        final lockerBookType = unit['locker_booktype'] ?? unit['lockerBooktype'] ?? unit['lockerBookType'] ?? unit['LockerBooktype'];
        return lockerBookType == bookTypeFilter;
      }).toList();
    }

    // Filter by size
    if (sizeFilter != null && sizeFilter.isNotEmpty) {
      filtered = filtered.where((unit) {
        // support lockerSize || locker_size || LockerSize
        final raw = unit['lockerSize'] ?? unit['locker_size'] ?? unit['LockerSize'];
        // null/unassigned size → treat as matching any size selection
        if (raw == null) return true;
        final lockerSize = raw.toString().toLowerCase();
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