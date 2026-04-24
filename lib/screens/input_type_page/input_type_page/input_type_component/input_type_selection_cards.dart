import 'package:flutter/material.dart';
import 'package:untitled/screens/input_type_page/email_input_page/email_input_page.dart';
import 'package:untitled/screens/input_type_page/phone_input_page/phone_input_page.dart';
import 'package:untitled/theme/theme.dart';
import 'package:untitled/widgets/grid/HoverMenuCard.dart';
import 'package:untitled/widgets/snackbar/snackbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../input_type_page.dart';

class InputTypeSelectionCards extends StatelessWidget {
  final FromPage from;
  final String? lockerId;
  final String? lockerName;
  final List<Map<String, dynamic>> lockerData;

  const InputTypeSelectionCards({
    super.key,
    required this.from,
    required this.lockerId,
    required this.lockerName,
    required this.lockerData,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final ready = lockerId != null && lockerName != null;
    return Row(
      children: [
        Expanded(
          child: HoverMenuCard(
            titleTh: Text(l.phone),
            semanticLabel: '${l.phone}. Tap to sign in with phone number.',
            icon: Icons.phone_android,
            color: AppColors.primary,
            onPressed: ready
                ? () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhoneInputPage(
                          selectedLocker: lockerId!,
                          lockerName: lockerName!,
                          from: from,
                          lockerData: lockerData,
                        ),
                      ),
                    )
                : () => context.showWarningSnackBar(l.loading),
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: HoverMenuCard(
            titleTh: Text(l.email),
            semanticLabel: '${l.email}. Tap to sign in with email.',
            icon: Icons.email,
            color: AppColors.primary,
            onPressed: ready
                ? () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmailInputPage(
                          selectedLocker: lockerId!,
                          lockerName: lockerName!,
                          from: from,
                          lockerData: lockerData,
                        ),
                      ),
                    )
                : () => context.showWarningSnackBar(l.loading),
          ),
        ),
      ],
    );
  }
}
