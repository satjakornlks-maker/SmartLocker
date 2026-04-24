import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/theme/theme.dart';

class KeypadButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final String? semanticLabel;

  const KeypadButton({
    super.key,
    required this.child,
    required this.onTap,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      child: Container(
        width: AppTouch.keypadButton,
        height: AppTouch.keypadButton,
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Material(
          color: AppColors.surface,
          shape: const CircleBorder(
            side: BorderSide(color: AppColors.border),
          ),
          elevation: 1,
          shadowColor: AppColors.shadow,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              HapticFeedback.selectionClick();
              onTap();
            },
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
