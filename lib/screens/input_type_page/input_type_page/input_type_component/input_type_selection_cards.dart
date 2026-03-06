import 'package:flutter/material.dart';
import 'package:untitled/screens/input_type_page/email_input_page/email_input_page.dart';
import 'package:untitled/screens/input_type_page/phone_input_page/phone_input_page.dart';
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
    return Row(
      children: [
        Expanded(
          child: HoverMenuCard(
            titleTh: Text(AppLocalizations.of(context)!.phone),
            icon: Icons.phone_android,
            color: Colors.blue,
            onPressed: lockerId != null && lockerName != null
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
                : () => context.showWarningSnackBar(
                    AppLocalizations.of(context)!.loading),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: HoverMenuCard(
            titleTh: Text(AppLocalizations.of(context)!.email),
            icon: Icons.email,
            color: Colors.blue,
            onPressed: lockerId != null && lockerName != null
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
                : () => context.showWarningSnackBar(
                    AppLocalizations.of(context)!.loading),
          ),
        ),
      ],
    );
  }
}
