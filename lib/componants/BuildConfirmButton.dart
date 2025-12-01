import 'package:flutter/material.dart';

class BuildConfirmButton extends StatelessWidget{
  final VoidCallback onPressed;
  final double fontSize;
  final String? label;
  final AlignmentGeometry alignment;

  const BuildConfirmButton({super.key, required this.onPressed, required this.fontSize, required this.label,this.alignment = AlignmentDirectional.bottomEnd});

  @override
  Widget build (BuildContext context){
    return Container(
      alignment:alignment,
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