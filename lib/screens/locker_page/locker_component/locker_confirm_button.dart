import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/theme/theme.dart';
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
    final enabled = selectedLocker != null;
    return Semantics(
      button: true,
      enabled: enabled,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: enabled ? () => _handleConfirm(context) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnPrimary,
              disabledBackgroundColor: AppColors.lockerDisabled,
              disabledForegroundColor: AppColors.textOnPrimary,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadius.mdRadius,
              ),
              elevation: 2,
            ),
            child: buttonText,
          ),
        ),
      ),
    );
  }

  void _handleConfirm(BuildContext context) {
    HapticFeedback.lightImpact();
    LockerNavigationService.navigateWithLocker(
      context: context,
      mode: mode,
      selectedLocker: selectedLocker,
      selectedLockerName: selectedLockerName,
      lockerData: lockerData,
    );
  }
}
