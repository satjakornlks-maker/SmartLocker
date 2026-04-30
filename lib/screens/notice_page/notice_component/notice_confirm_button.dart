import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/widgets/buttons/primary_button.dart';

class NoticeConfirmButton extends StatelessWidget {
  final BuildContext mainContext;
  const NoticeConfirmButton({super.key, required this.mainContext});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return PrimaryButton(
      label: l.backToHome,
      icon: Icons.home_rounded,
      expand: true,
      onPressed: () {
        Navigator.of(mainContext).popUntil((route) => route.isFirst);
      },
    );
  }
}
