import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';

class RefcodeAndResend extends StatelessWidget{
  final String? refCode;
  final VoidCallback handleResendOTP;
  const RefcodeAndResend({super.key, this.refCode, required this.handleResendOTP});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.referCode,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              refCode ?? 'XXXXXX',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(width: 80),
        TextButton.icon(
          onPressed: handleResendOTP,
          icon: const Icon(Icons.refresh, color: Colors.orange, size: 20),
          label:  Text(
            AppLocalizations.of(context)!.resend,
            style: TextStyle(
              color: Colors.orange,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }
}