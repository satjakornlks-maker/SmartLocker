import 'package:flutter/material.dart';

class BuildLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .center,
      children: [
        _legendItem(Colors.green, 'ว่าง'),
        SizedBox(width: 20),
        _legendItem(Colors.red, 'ไม่ว่าง'),
        SizedBox(width: 20),
        _legendItem(Colors.blue, 'เลือกแล้ว'),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 20, height: 20, color: color),
        SizedBox(width: 5),
        Text(label),
      ],
    );
  }
}
