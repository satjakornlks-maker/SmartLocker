import 'package:flutter/material.dart';

class AlipayLogo extends StatelessWidget {
  const AlipayLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/alipay.png', width: 36, height: 36, fit: BoxFit.contain),
        const SizedBox(width: 8),
        const Text(
          'Alipay',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00AAEF),
          ),
        ),
      ],
    );
  }
}
