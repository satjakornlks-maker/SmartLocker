import 'package:flutter/material.dart';
import 'package:untitled/screens/deposit_type_page/deposit_type_component/top_selection_card.dart';
import 'package:untitled/theme/theme.dart';
import '../../../l10n/app_localizations.dart';
import 'bottom_selection_card.dart';
import 'deposit_type_bottom.dart';

class DepositTypeMainContent extends StatelessWidget {
  final String systemMode;
  const DepositTypeMainContent({super.key, required this.systemMode});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final compact = MediaQuery.of(context).size.height <= 800;
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.usageMethod,
              style: AppText.displayMediumR(context),
            ),
            SizedBox(height: compact ? AppSpacing.xs : AppSpacing.xl),
            TopSelectionCard(systemMode: systemMode),
            if (systemMode != 'B2C') ...[
              SizedBox(height: compact ? AppSpacing.xs : AppSpacing.xxl),
              BottomSelectionCard(systemMode: systemMode),
            ],
            const Spacer(),
            const DepositTypeBottom(),
          ],
        ),
      ),
    );
  }
}
