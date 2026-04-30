import 'package:flutter/material.dart';
import 'package:untitled/theme/theme.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? semanticLabel;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final double fontSize;
  final double spacing;
  final int maxLine;
  final bool autofocus;

  const CustomFormField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType,
    required this.validator,
    this.hint,
    this.semanticLabel,
    this.fontSize = 20,
    this.spacing = AppSpacing.md,
    this.maxLine = 1,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: AppText.family,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: spacing),
        Semantics(
          label: semanticLabel ?? label,
          textField: true,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLine,
            autofocus: autofocus,
            style: AppText.bodyLarge,
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
            ),
            validator: validator,
          ),
        ),
        SizedBox(height: spacing),
      ],
    );
  }
}
