import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/screens/locker_page/locker_component/locker_confirm_button.dart';
import 'package:untitled/theme/theme.dart';
import '../../../widgets/header/header.dart';
import '../locker_selection_page.dart';
import 'locker_legend.dart';
import 'package:untitled/main.dart';

class LockerResponsiveBody extends StatelessWidget {
  final LockerSelectionMode mode;
  final String? selectedLocker;
  final String? selectedLockerName;
  final Widget buttonText;
  final Widget Function(double width, double height) gridBuilder;
  final List<Map<String, dynamic>> lockerData;

  const LockerResponsiveBody({
    super.key,
    required this.mode,
    required this.selectedLocker,
    required this.selectedLockerName,
    required this.buttonText,
    required this.gridBuilder,
    required this.lockerData,
  });

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final appState = MyApp.of(context);
    final l = AppLocalizations.of(context)!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final compact = screenHeight <= 800;

        final double headerPaddingV = compact ? AppSpacing.xs : AppSpacing.lg;
        final double innerPaddingH = compact ? AppSpacing.xl : AppSpacing.huge;
        final double spacerAfterTitle = compact ? AppSpacing.xs : AppSpacing.md;
        final double spacerAfterLegend = compact ? AppSpacing.xs : AppSpacing.lg;
        final double spacerAfterGrid = compact ? AppSpacing.xs : AppSpacing.md;
        final double spacerAfterButton = compact ? AppSpacing.xs : AppSpacing.xxl;

        const double headerHeight = 80;
        const double titleHeight = 40;
        const double legendHeight = 32;
        const double buttonHeight = 56;

        final double availableGridHeight = screenHeight -
            headerHeight -
            headerPaddingV * 2 -
            titleHeight -
            spacerAfterTitle -
            legendHeight -
            spacerAfterLegend -
            spacerAfterGrid -
            buttonHeight -
            spacerAfterButton;

        final double availableGridWidth = screenWidth - innerPaddingH * 2;

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: headerPaddingV,
              ),
              child: Header(
                currentLocale: currentLocale,
                onLanguageSwitch: () {
                  appState?.toggleLocale();
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: innerPaddingH),
                child: Column(
                  children: [
                    Text(
                      l.selectLocker,
                      style: AppText.headingLargeR(context),
                    ),
                    SizedBox(height: spacerAfterTitle),
                    const LockerLegend(),
                    SizedBox(height: spacerAfterLegend),
                    Expanded(
                      child: Center(
                        child: gridBuilder(
                          availableGridWidth,
                          availableGridHeight,
                        ),
                      ),
                    ),
                    SizedBox(height: spacerAfterGrid),
                    LockerConfirmButton(
                      mode: mode,
                      selectedLocker: selectedLocker,
                      selectedLockerName: selectedLockerName,
                      buttonText: buttonText,
                      lockerData: lockerData,
                    ),
                    SizedBox(height: spacerAfterButton),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
