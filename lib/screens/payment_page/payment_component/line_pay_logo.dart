import 'package:flutter/material.dart';

class LinePayLogo extends StatelessWidget {
  const LinePayLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF06C755),
          ),
          child: const Center(
            child: Icon(Icons.chat_bubble, color: Colors.white, size: 20),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'LINE Pay',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF06C755),
          ),
        ),
      ],
    );
  }
}
