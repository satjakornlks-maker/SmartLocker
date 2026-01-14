import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final double fontSize;
  final double spacing;
  final int maxLine;

  const CustomFormField({
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: fontSize)),
        SizedBox(height: spacing),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLine,
          decoration: InputDecoration(
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 4),
            ),
            focusedBorder: const OutlineInputBorder(
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
