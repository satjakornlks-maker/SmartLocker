import 'package:flutter/material.dart';
import 'package:untitled/theme/theme.dart';

/// Themed snackbars with WCAG AA contrast.
///
/// Colors come from `AppColors` instead of raw `Colors.red` / `Colors.orange`
/// so the text stays legible on every background.
extension SnackBarExtension on BuildContext {
  void showSnackBar(
    String message, {
    Color? backgroundColor,
    Color foregroundColor = AppColors.textOnPrimary,
    Duration duration = const Duration(seconds: 3),
    IconData? icon,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: foregroundColor, size: 20),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontFamily: AppText.family,
                  fontSize: 16,
                  color: foregroundColor,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
        duration: duration,
        action: action,
      ),
    );
  }

  void showErrorSnackBar(String message, {SnackBarAction? action}) {
    showSnackBar(
      message,
      backgroundColor: AppColors.error,
      icon: Icons.error_outline,
      action: action,
    );
  }

  void showSuccessSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: AppColors.success,
      icon: Icons.check_circle_outline,
    );
  }

  void showWarningSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: AppColors.warning,
      icon: Icons.warning_amber_outlined,
    );
  }

  void showInfoSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: AppColors.info,
      icon: Icons.info_outline,
    );
  }
}
