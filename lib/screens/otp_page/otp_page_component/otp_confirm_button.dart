import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/widgets/buttons/primary_button.dart';

class OtpConfirmButton extends StatelessWidget {
  final List<String> otpDigits;
  final VoidCallback handleSubmitOTP;
  const OtpConfirmButton({
    super.key,
    required this.otpDigits,
    required this.handleSubmitOTP,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final bool isComplete = otpDigits.every((digit) => digit.isNotEmpty);
    return PrimaryButton(
      label: l.confirm,
      icon: Icons.check,
      expand: true,
      semanticLabel: '${l.confirm}. Submit the 6-digit OTP code.',
      onPressed: isComplete ? handleSubmitOTP : null,
    );
  }
}
