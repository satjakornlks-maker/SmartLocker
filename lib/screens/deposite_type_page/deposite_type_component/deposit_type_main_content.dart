import 'package:flutter/material.dart';
import 'package:untitled/screens/deposite_type_page/deposite_type_component/top_selection_card.dart';
import '../../../l10n/app_localizations.dart';
import 'bottom_selection_card.dart';
import 'deposit_type_bottom.dart';

class DepositTypeMainContent extends StatelessWidget{
  final String systemMode;
  const DepositTypeMainContent({super.key, required this.systemMode});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            // Title
            Text(
              AppLocalizations.of(context)!.usageMethod,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),
            // Two cards row
            TopSelectionCard(systemMode: systemMode),
            const SizedBox(height: 30),
            // Quick registration button
            BottomSelectionCard(systemMode: systemMode),
            const SizedBox(height: 60),
            // Secure access text
            const DepositTypeBottom(),
          ],
        ),
      ),
    );
  }

}