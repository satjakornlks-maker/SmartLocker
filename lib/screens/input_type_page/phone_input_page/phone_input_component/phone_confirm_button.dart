import 'package:flutter/material.dart';
import 'package:untitled/theme/theme.dart';
import 'package:untitled/widgets/buttons/primary_button.dart';

import '../../../../l10n/app_localizations.dart';

class PhoneConfirmButton extends StatelessWidget {
  final bool isLoading;
  final bool isComplete;
  final VoidCallback onConfirm;
  const PhoneConfirmButton({
    super.key,
    required this.isLoading,
    required this.isComplete,
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
        semanticLabel: '${l.confirm}. ${l.submitPhoneNumber}',
        onPressed: (isComplete && !isLoading) ? onConfirm : null,
      ),
    );
  }
}
