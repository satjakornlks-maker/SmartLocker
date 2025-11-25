import 'package:flutter/material.dart';

class BuildFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final double fontSize;
  final double spacing;
  final int maxLine;

  const BuildFormField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType,
    required this.validator,
    this.fontSize = 32,
    this.spacing = 20,
    this.maxLine = 1,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(label, style: TextStyle(fontSize: fontSize)),
        SizedBox(height: spacing),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLine,
          decoration: InputDecoration(
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 4),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 4),
            ),
          ),
          validator: validator,
        ),
        SizedBox(height: spacing),
      ],
    );
  }
}
