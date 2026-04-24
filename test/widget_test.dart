// Widget smoke test — verifies the app shell renders without errors.
// See test/flows/ for user journey documentation tests.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/screens/user_type_page/user_type_page.dart';

void main() {
  testWidgets('UserTypePage renders without errors', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('th')],
        home: const UserTypePage(),
      ),
    );
    await tester.pump(); // settle localization delegates

    // The entry screen should render at least one type-selection button.
    expect(find.text('Employee'), findsOneWidget);
    expect(find.text('Visitor'), findsOneWidget);
    expect(find.text('Drop Box'), findsOneWidget);
  });
}
