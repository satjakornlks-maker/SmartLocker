import 'package:flutter/material.dart';

class OvertimeIconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bg;

  const OvertimeIconBadge({
    super.key,
    required this.icon,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(9)),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
