import 'package:flutter/material.dart';

class OvertimeAlipayLogo extends StatelessWidget {
  const OvertimeAlipayLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/alipay.png',
          width: 28,
          height: 28,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 6),
        const Text(
          'Alipay',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00AAEF),
          ),
        ),
      ],
    );
  }
}
