import 'package:flutter/material.dart';

class LockerLegend extends StatelessWidget {
  const LockerLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(Colors.green, 'ว่าง'),
        const SizedBox(width: 20),
        _legendItem(Colors.red, 'ไม่ว่าง'),
        const SizedBox(width: 20),
        _legendItem(Colors.blue, 'เลือกแล้ว'),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 20, height: 20, color: color),
        const SizedBox(width: 5),
        Text(label),
      ],
    );
  }
}
