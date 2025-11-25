import 'package:flutter/material.dart';

class BuildConfirmButton extends StatelessWidget{
  final VoidCallback onPressed;
  final double fontsize;
  final String? lable;
  final AlignmentGeometry alignment;

  const BuildConfirmButton({super.key, required this.onPressed, required this.fontsize, required this.lable,this.alignment = AlignmentDirectional.bottomEnd});

  @override
  Widget build (BuildContext context){
    return Container(
      alignment:alignment,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          lable!,
          style: TextStyle(fontSize: fontsize),
        ),
      ),
    );
  }
}