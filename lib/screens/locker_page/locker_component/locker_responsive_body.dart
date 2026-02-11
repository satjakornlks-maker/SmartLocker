import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/screens/locker_page/locker_component/locker_confirm_button.dart';
import '../../../widgets/header/header.dart';
import '../locker_selection_page.dart';
import 'locker_legend.dart';
import 'package:untitled/main.dart';

class LockerResponsiveBody extends StatelessWidget {
  final LockerSelectionMode mode;
  final String? selectedLocker;
  final String? selectedLockerName;
  final Widget buttonText; // Changed from String to Widget
  final Widget Function(double width, double height) gridBuilder;

  const LockerResponsiveBody({
    super.key,
    required this.mode,
    required this.selectedLocker,
    required this.selectedLockerName,
    required this.buttonText,
    required this.gridBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final appState = MyApp.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        const double headerHeight = 70;
        const double titleHeight = 50;
        const double legendHeight = 30;
        const double buttonHeight = 60;
        const double paddingTotal = 80;

        final double availableGridHeight =
            screenHeight -
                headerHeight -
                titleHeight -
                legendHeight -
                buttonHeight -
                paddingTotal;

        final double availableGridWidth = screenWidth - 80;

        return Column(
          children: [
            SizedBox(height: 30,),
            Header(currentLocale: currentLocale, onLanguageSwitch: () {
              appState?.toggleLocale();
            }),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.selectLocker,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const LockerLegend(),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Center(
                        child: gridBuilder(
                          availableGridWidth,
                          availableGridHeight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    LockerConfirmButton(
                      mode: mode,
                      selectedLocker: selectedLocker,
                      selectedLockerName: selectedLockerName,
                      buttonText: buttonText, // Pass the widget
                    ),
                    const SizedBox(height: 40),
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