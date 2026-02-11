import 'package:flutter/material.dart';

class UserTypeBottom extends StatelessWidget{
  const UserTypeBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'SECURE ACCESS',
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 2,
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}