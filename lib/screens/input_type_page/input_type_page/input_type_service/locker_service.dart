import 'dart:math';

import 'package:untitled/screens/input_type_page/input_type_page/input_type_page.dart';
import '../../../../services/api_service.dart';

class LockerService {
  final ApiService _apiService = ApiService();

  /// Fetches and parses locker units from the API.
  /// Returns `{'success': true, 'data': List<Map<String, dynamic>>}` on success,
  /// or `{'success': false, 'error': String}` on failure.
  Future<Map<String, dynamic>> fetchLockerUnits() async {
    final result = await _apiService.getLocker();
    if (result['success'] != true) {
      return {'success': false, 'error': result['error']};
    }

    final data = result['data'];
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

    return {'success': true, 'data': units};
  }

  /// Picks a random available locker from [units] based on [from] and [size].
  /// Returns the selected locker map, or `null` if none are available.
  Map<String, dynamic>? selectRandomLocker({
    required List<Map<String, dynamic>> units,
    required FromPage from,
    required String systemMode,
    String? size,
  }) {
    final int bookType = from == FromPage.visitor ? 5 : 1;

    final available = units.where((locker) {
      final baseCondition = locker['status'] == false &&
          locker['enable'] == false &&
          locker['locker_status'] == 'close';

      final bookTypeCondition = locker['locker_booktype'] == bookType;

      final sizeCondition = (systemMode == 'B2C' && size != null)
          ? locker['lockerSize'] == size
          : true;

      return baseCondition && bookTypeCondition && sizeCondition;
    }).toList();

    if (available.isEmpty) return null;

    return available[Random().nextInt(available.length)];
  }
}
