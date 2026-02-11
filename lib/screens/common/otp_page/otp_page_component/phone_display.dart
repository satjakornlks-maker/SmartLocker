import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';

class PhoneDisplay extends StatelessWidget{
  final String? telOrEmail;
  final String? lockerName;
  const PhoneDisplay({super.key, this.telOrEmail, this.lockerName});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .center,
      children: [
        Text(
          '${AppLocalizations.of(context)!.sendTo} : ${telOrEmail ?? ""} ',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        Text(
          '${AppLocalizations.of(context)!.forLocker} : ${lockerName ?? ""}',
          style: TextStyle(fontSize: 18, color: Colors.blue),
        ),
      ],
    );
  }
}