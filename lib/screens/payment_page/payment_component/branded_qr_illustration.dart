import 'package:flutter/material.dart';

class BrandedQrIllustration extends StatelessWidget {
  final Color brandColor;
  final Color bgColor;
  final Widget logoWidget;
  final String scanLabel;

  const BrandedQrIllustration({
    super.key,
    required this.brandColor,
    required this.bgColor,
    required this.logoWidget,
    required this.scanLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(child: logoWidget),
        ),
        const SizedBox(height: 14),
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            border: Border.all(color: brandColor, width: 2),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Icon(Icons.qr_code_2, size: 130, color: brandColor),
        ),
        const SizedBox(height: 10),
        Text(
          scanLabel,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
