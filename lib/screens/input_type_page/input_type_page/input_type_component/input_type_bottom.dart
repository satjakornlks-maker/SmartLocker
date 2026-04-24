import 'package:flutter/material.dart';
import 'package:untitled/theme/theme.dart';

import '../../../../l10n/app_localizations.dart';

class InputTypeBottom extends StatelessWidget {
  const InputTypeBottom({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l.cardReaderInstruct,
          style: const TextStyle(
            fontFamily: AppText.family,
            fontSize: 24,
            letterSpacing: 1.5,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
