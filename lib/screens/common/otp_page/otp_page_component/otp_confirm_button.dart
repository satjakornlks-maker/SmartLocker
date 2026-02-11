import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';

class OtpConfirmButton extends StatelessWidget{
  final List<String> otpDigits;
  final VoidCallback handleSubmitOTP;
  const OtpConfirmButton({super.key, required this.otpDigits, required this.handleSubmitOTP});

  @override
  Widget build(BuildContext context) {
    final bool isComplete = otpDigits.every((digit) => digit.isNotEmpty);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isComplete ? handleSubmitOTP : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isComplete ? Colors.green : Colors.grey.shade200,
          foregroundColor: isComplete ? Colors.white : Colors.grey.shade400,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check,
              size: 20,
              color: isComplete ? Colors.white : Colors.grey.shade400,
            ),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!.confirm,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}