import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/theme/theme.dart';

/// Legacy confirm button, kept for backward compatibility with existing screens.
///
/// New code should prefer [PrimaryButton] from
/// `widgets/buttons/primary_button.dart`, which has built-in loading,
/// disabled, and accessibility support.
class ConfirmButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double fontSize;
  final String? label;
  final AlignmentGeometry alignment;

  const ConfirmButton({
    super.key,
    required this.onPressed,
    required this.fontSize,
    required this.label,
    this.alignment = AlignmentDirectional.bottomEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      child: Semantics(
        label: label,
        button: true,
        child: TextButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            onPressed();
          },
          style: TextButton.styleFrom(
            minimumSize: const Size(88, AppTouch.minTarget),
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.md,
            ),
          ),
          child: Text(
            label ?? '',
            style: TextStyle(
              fontFamily: AppText.family,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
