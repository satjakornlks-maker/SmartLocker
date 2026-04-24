import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/theme/theme.dart';

class OtpTitle extends StatelessWidget {
  final int resetPass;
  const OtpTitle({super.key, required this.resetPass});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final text = resetPass == 2
        ? l.changePass
        : resetPass == 1
            ? l.resetPass
            : l.otpInstruct;
    return Text(
      text,
      textAlign: TextAlign.center,
      style: AppText.headingLargeR(context),
    );
  }
}
