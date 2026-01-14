import 'package:flutter/material.dart';

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
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label!,
          style: TextStyle(fontSize: fontSize),
        ),
      ),
    );
  }
}
