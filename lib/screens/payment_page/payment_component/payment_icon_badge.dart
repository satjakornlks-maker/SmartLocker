import 'package:flutter/material.dart';
import 'package:untitled/theme/theme.dart';

class PaymentIconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bg;

  const PaymentIconBadge({
    super.key,
    required this.icon,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: bg, borderRadius: AppRadius.smRadius),
      child: Icon(icon, color: color, size: 22),
    );
  }
}
