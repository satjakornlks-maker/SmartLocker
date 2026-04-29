import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/theme/theme.dart';

import 'keypad_button.dart';

class KeypadRow extends StatelessWidget {
  final List<String> keys;
  final VoidCallback handleDelete;
  final Function handleNumberTap;

  const KeypadRow({
    super.key,
    required this.keys,
    required this.handleDelete,
    required this.handleNumberTap,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys.map((key) {
        if (key == 'delete') {
          return KeypadButton(
            onTap: handleDelete,
            semanticLabel: l.deleteDigit,
            child: const Icon(
              Icons.backspace_outlined,
              size: 24,
              color: AppColors.textPrimary,
            ),
          );
        } else if (key == '0') {
          return Row(
            children: [
              const SizedBox(width: AppTouch.keypadButton + AppSpacing.xl),
              KeypadButton(
                semanticLabel: l.digitLabel('0'),
                onTap: () => handleNumberTap(key),
                child: const Text(
                  '0',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          );
        } else {
          return KeypadButton(
            semanticLabel: l.digitLabel(key),
            onTap: () => handleNumberTap(key),
            child: Text(
              key,
              style: const TextStyle(
                fontFamily: AppText.family,
                fontSize: 28,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          );
        }
      }).toList(),
    );
  }
}
