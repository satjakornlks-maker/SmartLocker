import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/widgets/buttons/primary_button.dart';

class EmailConfirmButton extends StatelessWidget {
  final bool isValidEmail;
  final bool isLoading;
  final VoidCallback onConfirm;
  const EmailConfirmButton({
    super.key,
    required this.isValidEmail,
    required this.isLoading,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: PrimaryButton(
        label: l.confirm,
        icon: Icons.check,
        isLoading: isLoading,
        expand: true,
        semanticLabel: '${l.confirm}. ${l.submitEmailAddress}',
        onPressed: (isValidEmail && !isLoading) ? onConfirm : null,
      ),
    );
  }
}
