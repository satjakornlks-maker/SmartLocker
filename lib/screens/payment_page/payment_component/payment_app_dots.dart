import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentAppDots extends StatelessWidget {
  const PaymentAppDots({super.key});

  static const _banks = [
    ('PP', Color(0xFF003087), 'PromptPay', 'assets/images/promtpay.png'),
    ('K+', Color(0xFF138F2D), 'K-Bank', 'assets/images/CL_K-Bank.png'),
    ('SCB', Color(0xFF4B2992), 'SCB', 'assets/images/SCB.jpg'),
    ('KTB', Color(0xFF00A3A5), 'Krungthai', 'assets/images/Krung_Thai_Bank_logo.svg'),
    ('T', Color(0xFFE82020), 'TMW', 'assets/images/trumoney.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (abbr, color, label, img) in _banks) ...[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: img.isEmpty ? color : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.25),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: img.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(3),
                          child: img.endsWith('.svg')
                              ? SvgPicture.asset(img, fit: BoxFit.contain)
                              : Image.asset(img, fit: BoxFit.contain),
                        )
                      : Center(
                          child: Text(
                            abbr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(fontSize: 7.5, color: Colors.grey.shade500),
              ),
            ],
          ),
          const SizedBox(width: 6),
        ],
      ],
    );
  }
}
