import 'package:flutter/material.dart';
import 'package:untitled/theme/theme.dart';

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
      decoration: BoxDecoration(color: bg, borderRadius: AppRadius.smRadius),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
