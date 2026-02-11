import 'package:flutter/material.dart';
class HomepageBottom extends StatelessWidget{
  const HomepageBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "©LANNACOM 2026",
          style: TextStyle(color: Colors.grey),
        ),
        const Text(
          "SECURE ACCESS",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}