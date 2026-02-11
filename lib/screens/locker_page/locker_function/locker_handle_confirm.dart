import 'package:flutter/material.dart';

import '../../auth/register_page/register_page.dart';
import '../../common/otp_page/otp_page.dart';
import '../../input_type_page/input_type_page/input_type_page.dart';
import '../locker_selection_page.dart';

class LockerNavigationService {
  /// Navigates based on locker selection mode
  static void navigateWithLocker({
    required BuildContext context,
    required LockerSelectionMode mode,
    required String? selectedLocker,
    String? selectedLockerName,
    VoidCallback? onError,
  }) {
    // Validate selection
    if (selectedLocker == null) {
      _showValidationError(context, onError);
      return;
    }

    // Navigate based on mode
    switch (mode) {
      case LockerSelectionMode.booking:
        _navigateToBooking(
          context,
          selectedLocker,
          selectedLockerName!,
        );
        break;

      case LockerSelectionMode.memberSelect:
        _navigateToRegister(context, selectedLocker);
        break;

      case LockerSelectionMode.unlock:
        _navigateToUnlock(
          context,
          selectedLocker,
          selectedLockerName,
        );
        break;
    }
  }

  // Private navigation methods
  static void _navigateToBooking(
      BuildContext context,
      String lockerId,
      String lockerName,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InputTypePage(
          from: FromPage.normal,
          selectedLocker: lockerId,
          lockerName: lockerName,
        ),
      ),
    );
  }

  static void _navigateToRegister(
      BuildContext context,
      String lockerId,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterPage(
          selectedLocker: lockerId,
        ),
      ),
    );
  }

  static void _navigateToUnlock(
      BuildContext context,
      String lockerId,
      String? lockerName,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OTPPage(
          from: FromPage.unlock,
          lockerId: lockerId,
          lockerName: lockerName,
        ),
      ),
    );
  }

  static void _showValidationError(
      BuildContext context,
      VoidCallback? onError,
      ) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('โปรดเลือกตู้ล็อคเกอร์'),
        backgroundColor: Colors.orange,
      ),
    );
    onError?.call();
  }
}