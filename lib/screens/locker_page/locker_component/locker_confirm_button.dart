import 'package:flutter/material.dart';
import '../locker_function/locker_handle_confirm.dart';
import '../locker_selection_page.dart';

class LockerConfirmButton extends StatelessWidget {
  final LockerSelectionMode mode;
  final String? selectedLocker;
  final String? selectedLockerName;
  final Widget buttonText;
  final List<Map<String, dynamic>> lockerData;

  const LockerConfirmButton({
    super.key,
    required this.mode,
    required this.selectedLocker,
    required this.selectedLockerName,
    required this.buttonText,
    required this.lockerData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 350),
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () => _handleConfirm(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
        child: buttonText, // Use the widget directly
      ),
    );
  }

  void _handleConfirm(BuildContext context) {
    LockerNavigationService.navigateWithLocker(
      context: context,
      mode: mode,
      selectedLocker: selectedLocker,
      selectedLockerName: selectedLockerName,
      lockerData: lockerData,
    );
  }
}