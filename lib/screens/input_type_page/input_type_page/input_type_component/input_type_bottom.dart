import 'package:flutter/material.dart';
import 'package:untitled/screens/input_type_page/input_type_page/input_type_page.dart';
import 'package:untitled/theme/theme.dart';

import '../../../../l10n/app_localizations.dart';

class InputTypeBottom extends StatelessWidget {
  final FromPage from;
  const InputTypeBottom({super.key, required this.from});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Text(
          from == FromPage.visitor ? "":
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
