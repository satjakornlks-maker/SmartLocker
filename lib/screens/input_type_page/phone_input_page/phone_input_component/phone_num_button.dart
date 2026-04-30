import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/theme/theme.dart';

class PhoneNumButton extends StatelessWidget {
  final String number;
  final Function onNumberPress;
  const PhoneNumButton({
    super.key,
    required this.number,
    required this.onNumberPress,
  });

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.of(context).size.height <= 800;
    final btnSize = compact ? 52.0 : AppTouch.keypadButton;
    return Semantics(
      label: AppLocalizations.of(context)!.digitLabel(number),
      button: true,
      enabled: true,
      child: SizedBox(
        width: btnSize,
        height: btnSize,
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
              onNumberPress(number);
            },
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontFamily: AppText.family,
                  fontSize: compact ? 22.0 : 28.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
