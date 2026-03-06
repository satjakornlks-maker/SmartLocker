import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled/l10n/app_localizations.dart';

class QrGroupIllustration extends StatelessWidget {
  final AppLocalizations l10n;

  const QrGroupIllustration({super.key, required this.l10n});

  // (abbreviation, bgColor, label, imagePath — empty = no image)
  static const _supportedApps = [
    ('PP', Color(0xFF003087), 'PromptPay', 'assets/images/promtpay.png'),
    ('K+', Color(0xFF138F2D), 'K-Bank', 'assets/images/CL_K-Bank.png'),
    ('SCB', Color(0xFF4B2992), 'SCB', 'assets/images/SCB.png'),
    ('KTB', Color(0xFF00A3A5), 'Krungthai', 'assets/images/Krung_Thai_Bank_logo.svg'),
    ('T', Color(0xFFE82020), 'TrueMoney', 'assets/images/trumoney.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 2),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: const Icon(Icons.qr_code_2, size: 150, color: Colors.black87),
        ),
        const SizedBox(height: 10),
        Text(
          l10n.scanWithBankApp,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 14),
        Text(
          l10n.supportedApps,
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 14,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            for (final (abbr, color, label, img) in _supportedApps)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: img.isEmpty ? color : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: img.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(4),
                              child: img.endsWith('.svg')
                                  ? SvgPicture.asset(img, fit: BoxFit.contain)
                                  : Image.asset(img, fit: BoxFit.contain),
                            )
                          : Center(
                              child: Text(
                                abbr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
