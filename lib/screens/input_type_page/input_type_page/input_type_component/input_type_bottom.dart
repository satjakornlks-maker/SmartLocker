import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class InputTypeBottom extends StatelessWidget {
  const InputTypeBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.cardReaderInstruct,
          style: const TextStyle(
            fontSize: 24,
            letterSpacing: 2,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
