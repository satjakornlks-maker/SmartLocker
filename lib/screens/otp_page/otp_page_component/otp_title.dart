import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/screens/input_type_page/input_type_page/input_type_page.dart';
import 'package:untitled/theme/theme.dart';

class OtpTitle extends StatelessWidget {
  final int resetPass;
  final FromPage from;
  const OtpTitle({super.key, required this.resetPass, required this.from});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    // resetPass states take priority so title updates correctly during
    // the reset-password flow even when from == FromPage.unlock.
    final text = resetPass == 2
        ? l.changePass
        : resetPass == 1
            ? l.resetPass
            : from == FromPage.unlock
                ? l.otpUnlockPage
                : l.otpInstruct;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppText.headingLargeR(context),
      ),
    );
  }
}
