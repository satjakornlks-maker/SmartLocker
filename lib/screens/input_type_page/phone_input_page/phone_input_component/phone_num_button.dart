import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return Semantics(
      label: 'Digit $number',
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
              onNumberPress(number);
            },
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  fontFamily: AppText.family,
                  fontSize: 28,
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
