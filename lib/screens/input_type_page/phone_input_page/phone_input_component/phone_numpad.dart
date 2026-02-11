import 'package:flutter/material.dart';
import 'package:untitled/screens/input_type_page/phone_input_page/phone_input_component/phone_backspace.dart';
import 'package:untitled/screens/input_type_page/phone_input_page/phone_input_component/phone_num_button.dart';

class PhoneNumpad extends StatelessWidget{
  final String phoneNumber;
  final Function onNumberPress;
  final VoidCallback onBackspace;
  final bool isLoading;
  const PhoneNumpad({super.key, required this.phoneNumber, required this.onNumberPress, required this.onBackspace, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading, // Disable numpad when loading
      child: Opacity(
        opacity: isLoading ? 0.5 : 1.0, // Reduce opacity when loading
        child: Column(
          children: [
            // Row 1: 1, 2, 3
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PhoneNumButton(number: '1', onNumberPress: onNumberPress,),
                const SizedBox(width: 20),
                PhoneNumButton(number:'2',onNumberPress: onNumberPress),
                const SizedBox(width: 20),
                PhoneNumButton(number: '3',onNumberPress: onNumberPress,),
              ],
            ),
            const SizedBox(height: 20),

            // Row 2: 4, 5, 6
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PhoneNumButton(number:'4',onNumberPress:onNumberPress ,),
                const SizedBox(width: 20),
                PhoneNumButton(number: '5',onNumberPress: onNumberPress,),
                const SizedBox(width: 20),
                PhoneNumButton(number: '6',onNumberPress: onNumberPress,),
              ],
            ),
            const SizedBox(height: 20),

            // Row 3: 7, 8, 9
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PhoneNumButton(number: '7',onNumberPress: onNumberPress,),
                const SizedBox(width: 20),
                PhoneNumButton(number: '8',onNumberPress: onNumberPress,),
                const SizedBox(width: 20),
                PhoneNumButton(number: '9',onNumberPress: onNumberPress,),
              ],
            ),
            const SizedBox(height: 20),

            // Row 4: 0, backspace
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 70),
                const SizedBox(width: 20),
                PhoneNumButton(number: '0',onNumberPress: onNumberPress,),
                const SizedBox(width: 20),
                PhoneBackspace(onBackspace: onBackspace),
              ],
            ),
          ],
        ),
      ),
    );
  }



}