import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/theme/theme.dart';

class PhoneDisplay extends StatelessWidget {
  final String? telOrEmail;
  final String? lockerName;
  const PhoneDisplay({super.key, this.telOrEmail, this.lockerName});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.sm,
      children: [
        Text(
          '${l.sendTo} : ${telOrEmail ?? ""}',
          style: AppText.bodySmall,
        ),
        Text(
          '${l.forLocker} : ${lockerName ?? ""}',
          style: AppText.bodyLarge.copyWith(color: AppColors.primary),
        ),
      ],
    );
  }
}
