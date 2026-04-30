import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled/l10n/app_localizations.dart';

class OvertimeQrIllustration extends StatelessWidget {
  final AppLocalizations l10n;

  const OvertimeQrIllustration({super.key, required this.l10n});

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
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 2),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: const Icon(Icons.qr_code_2, size: 88, color: Colors.black87),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.scanWithBankApp,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.supportedApps,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 10,
          runSpacing: 6,
          alignment: WrapAlignment.center,
          children: [
            for (final (abbr, color, label, img) in _supportedApps)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: img.isEmpty ? color : Colors.white,
                      borderRadius: BorderRadius.circular(9),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.25),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
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
                                  fontSize: 10,
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
                    style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
