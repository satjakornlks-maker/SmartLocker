import 'package:flutter/material.dart';

class OvertimeBrandedQrIllustration extends StatelessWidget {
  final Color brandColor;
  final Color bgColor;
  final Widget logoWidget;
  final String scanLabel;

  const OvertimeBrandedQrIllustration({
    super.key,
    required this.brandColor,
    required this.bgColor,
    required this.logoWidget,
    required this.scanLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: logoWidget),
        ),
        const SizedBox(height: 10),
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            border: Border.all(color: brandColor, width: 2),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Icon(Icons.qr_code_2, size: 88, color: brandColor),
        ),
        const SizedBox(height: 6),
        Text(
          scanLabel,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
      ],
    );
  }
}
