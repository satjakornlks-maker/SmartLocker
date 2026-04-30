import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/theme/theme.dart';

class PhoneBackspace extends StatelessWidget {
  final VoidCallback onBackspace;

  const PhoneBackspace({super.key, required this.onBackspace});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppLocalizations.of(context)!.deleteDigit,
      button: true,
      enabled: true,
      child: SizedBox(
        width: AppTouch.keypadButton,
        height: AppTouch.keypadButton,
        child: Material(
          color: AppColors.surface,
          shape: CircleBorder(
            side: BorderSide(color: AppColors.border),
          ),
          elevation: 1,
          shadowColor: AppColors.shadow,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              HapticFeedback.selectionClick();
              onBackspace();
            },
            child: const Center(
              child: Icon(
                Icons.backspace_outlined,
                size: 28,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
