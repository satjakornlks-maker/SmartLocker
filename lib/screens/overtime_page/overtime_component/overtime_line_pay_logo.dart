import 'package:flutter/material.dart';

class OvertimeLinePayLogo extends StatelessWidget {
  const OvertimeLinePayLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF06C755),
          ),
          child: const Center(
            child: Icon(Icons.chat_bubble, color: Colors.white, size: 16),
          ),
        ),
        const SizedBox(width: 6),
        const Text(
          'LINE Pay',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF06C755),
          ),
        ),
      ],
    );
  }
}
