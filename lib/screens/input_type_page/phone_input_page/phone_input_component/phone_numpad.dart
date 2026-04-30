import 'package:flutter/material.dart';
import 'package:untitled/screens/input_type_page/phone_input_page/phone_input_component/phone_backspace.dart';
import 'package:untitled/screens/input_type_page/phone_input_page/phone_input_component/phone_num_button.dart';
import 'package:untitled/theme/theme.dart';

class PhoneNumpad extends StatelessWidget {
  final String phoneNumber;
  final Function onNumberPress;
  final VoidCallback onBackspace;
  final bool isLoading;
  const PhoneNumpad({
    super.key,
    required this.phoneNumber,
    required this.onNumberPress,
    required this.onBackspace,
    required this.isLoading,
  });

  Widget _row(List<Widget> children, {required bool compact}) {
    return Padding(
      padding: EdgeInsets.only(bottom: compact ? AppSpacing.xs : AppSpacing.xl),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(width: compact ? AppSpacing.md : AppSpacing.xl),
            children[i],
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.of(context).size.height <= 800;
    final spacerWidth = compact ? 52.0 : AppTouch.keypadButton;
    return AbsorbPointer(
      absorbing: isLoading,
      child: Opacity(
        opacity: isLoading ? 0.5 : 1.0,
        child: Column(
          children: [
            _row([
              PhoneNumButton(number: '1', onNumberPress: onNumberPress),
              PhoneNumButton(number: '2', onNumberPress: onNumberPress),
              PhoneNumButton(number: '3', onNumberPress: onNumberPress),
            ], compact: compact),
            _row([
              PhoneNumButton(number: '4', onNumberPress: onNumberPress),
              PhoneNumButton(number: '5', onNumberPress: onNumberPress),
              PhoneNumButton(number: '6', onNumberPress: onNumberPress),
            ], compact: compact),
            _row([
              PhoneNumButton(number: '7', onNumberPress: onNumberPress),
              PhoneNumButton(number: '8', onNumberPress: onNumberPress),
              PhoneNumButton(number: '9', onNumberPress: onNumberPress),
            ], compact: compact),
            _row([
              SizedBox(width: spacerWidth),
              PhoneNumButton(number: '0', onNumberPress: onNumberPress),
              PhoneBackspace(onBackspace: onBackspace),
            ], compact: compact),
          ],
        ),
      ),
    );
  }
}
