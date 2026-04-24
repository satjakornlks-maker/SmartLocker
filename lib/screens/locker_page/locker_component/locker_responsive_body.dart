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

        const double headerHeight = 70;
        const double titleHeight = 60;
        const double legendHeight = 40;
        const double buttonHeight = 64;
        const double paddingTotal = 96;

        final double availableGridHeight = screenHeight -
            headerHeight -
            titleHeight -
            legendHeight -
            buttonHeight -
            paddingTotal;

        final double availableGridWidth = screenWidth - 80;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.lg,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.huge,
                ),
                child: Column(
                  children: [
                    Text(
                      l.selectLocker,
                      style: AppText.headingLargeR(context),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const LockerLegend(),
                    const SizedBox(height: AppSpacing.lg),
                    Expanded(
                      child: Center(
                        child: gridBuilder(
                          availableGridWidth,
                          availableGridHeight,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    LockerConfirmButton(
                      mode: mode,
                      selectedLocker: selectedLocker,
                      selectedLockerName: selectedLockerName,
                      buttonText: buttonText,
                      lockerData: lockerData,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
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
