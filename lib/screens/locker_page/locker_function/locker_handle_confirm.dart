import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/widgets/snackbar/snackbar.dart';

import '../../input_type_page/input_type_page/input_type_page.dart';
import '../../input_type_page/phone_input_page/phone_input_page.dart';
import '../../otp_page/otp_page.dart';
import '../../register_page/register_page.dart';
import '../locker_selection_page.dart';

class LockerNavigationService {
  /// Navigates based on locker selection mode
  static void navigateWithLocker({
    required BuildContext context,
    required LockerSelectionMode mode,
    required String? selectedLocker,
    String? selectedLockerName,
    List<Map<String, dynamic>> lockerData = const [],
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
        if (selectedLockerName == null) {
          _showValidationError(context, onError);
          return;
        }
        _navigateToBooking(
          context,
          selectedLocker,
          selectedLockerName,
          lockerData,
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
          lockerData,
        );
        break;
    }
  }

  // Private navigation methods
  static void _navigateToBooking(
      BuildContext context,
      String lockerId,
      String lockerName,
      List<Map<String, dynamic>> lockerData,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhoneInputPage(
          from: FromPage.normal,
          selectedLocker: lockerId,
          lockerName: lockerName,
          lockerData: lockerData,
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
      List<Map<String, dynamic>> lockerData,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OTPPage(
          from: FromPage.unlock,
          lockerId: lockerId,
          lockerName: lockerName,
          lockerData: lockerData,
        ),
      ),
    );
  }

  static void _showValidationError(
      BuildContext context,
      VoidCallback? onError,
      ) {
    final l = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).clearSnackBars();
    context.showWarningSnackBar(l.selectLocker);
    onError?.call();
  }
}