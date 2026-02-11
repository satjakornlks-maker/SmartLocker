import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';

class OtpTitle extends StatelessWidget{
  final int resetPass;
  const OtpTitle({super.key, required this.resetPass});

  @override
  Widget build(BuildContext context) {
    return Text(
      resetPass == 2
          ? AppLocalizations.of(context)!.changePass
          : resetPass == 1
          ? AppLocalizations.of(context)!.resetPass
          : AppLocalizations.of(context)!.otpInstruct,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}