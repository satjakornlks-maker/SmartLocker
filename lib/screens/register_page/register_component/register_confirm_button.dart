import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/widgets/buttons/primary_button.dart';

class RegisterConfirmButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Function handleUnlockMember;
  const RegisterConfirmButton({
    super.key,
    required this.handleUnlockMember,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return PrimaryButton(
      label: l.submitRequest,
      icon: Icons.check_circle_rounded,
      expand: true,
      onPressed: () {
        if (formKey.currentState!.validate()) {
          handleUnlockMember();
        }
      },
    );
  }
}
