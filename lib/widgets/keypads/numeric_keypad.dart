import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/theme/theme.dart';

/// Reusable numeric keypad for phone / OTP input.
///
/// Layout:
///   1 2 3
///   4 5 6
///   7 8 9
///   . 0 ⌫
///
/// [onNumberPress] receives the digit as a String.
/// [onBackspace] is called when the delete key is tapped.
/// [isLoading] disables the keypad and dims it.
class NumericKeypad extends StatelessWidget {
  final void Function(String digit) onNumberPress;
  final VoidCallback onBackspace;
  final bool isLoading;
  final double buttonSize;
  final double spacing;

  const NumericKeypad({
    super.key,
    required this.onNumberPress,
    required this.onBackspace,
    this.isLoading = false,
    this.buttonSize = 72,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    const rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', 'BKSP'],
    ];

    return AbsorbPointer(
      absorbing: isLoading,
      child: Opacity(
        opacity: isLoading ? 0.5 : 1.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var r = 0; r < rows.length; r++) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var c = 0; c < rows[r].length; c++) ...[
                    if (c > 0) SizedBox(width: spacing),
                    _buildKey(rows[r][c]),
                  ],
                ],
              ),
              if (r < rows.length - 1) SizedBox(height: spacing),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildKey(String value) {
    if (value.isEmpty) return SizedBox(width: buttonSize, height: buttonSize);
    if (value == 'BKSP') return _KeypadButton.backspace(size: buttonSize, onTap: onBackspace);
    return _KeypadButton.digit(digit: value, size: buttonSize, onTap: () => onNumberPress(value));
  }
}

class _KeypadButton extends StatelessWidget {
  final String? digit;
  final bool isBackspace;
  final double size;
  final VoidCallback onTap;

  const _KeypadButton.digit({
    required this.digit,
    required this.size,
    required this.onTap,
  }) : isBackspace = false;

  const _KeypadButton.backspace({
    required this.size,
    required this.onTap,
  })  : digit = null,
        isBackspace = true;

  @override
  Widget build(BuildContext context) {
    final label = isBackspace ? 'Delete last digit' : 'Digit $digit';
    return Semantics(
      label: label,
      button: true,
      enabled: true,
      child: SizedBox(
        width: size,
        height: size,
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
              onTap();
            },
            child: Center(
              child: isBackspace
                  ? const Icon(
                      Icons.backspace_outlined,
                      size: 28,
                      color: AppColors.textPrimary,
                    )
                  : Text(
                      digit!,
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
