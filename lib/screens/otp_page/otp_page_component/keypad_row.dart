import 'package:flutter/material.dart';

import 'keypad_button.dart';

class KeypadRow extends StatelessWidget{
  final List<String> keys;
  final VoidCallback handleDelete;
  final Function handleNumberTap;

  const KeypadRow({super.key, required this.keys, required this.handleDelete, required this.handleNumberTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys.map((key) {
        if (key == 'delete') {
          return KeypadButton(
            onTap: handleDelete,
            child: const Icon(Icons.backspace_outlined, size: 24),
          );
        } else if (key == '0') {
          return Row(
            children: [
              const SizedBox(width: 100), // Empty space for alignment
              KeypadButton(
                child: Text(
                  key,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () => handleNumberTap(key),
              ),
            ],
          );
        } else {
          return KeypadButton(
            child: Text(
              key,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            onTap: () => handleNumberTap(key),
          );
        }
      }).toList(),
    );
  }
}