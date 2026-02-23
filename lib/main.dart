import 'package:flutter/material.dart';
import 'package:untitled/screens/common/chose_time_page.dart';
import 'package:untitled/screens/common/overtime_page.dart';
import 'package:untitled/screens/locker_page/locker_selection_page.dart';
import 'package:untitled/screens/user_type_page/user_type_page.dart';
import 'package:untitled/screens/common/otp_page/otp_page.dart';
import 'package:untitled/screens/home_page/my_home_page.dart';
import 'package:untitled/screens/input_type_page/input_type_page/input_type_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('th');

  void toggleLocale() {
    setState(() {
      _locale = _locale.languageCode == 'th'
          ? const Locale('en')
          : const Locale('th');
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      title: 'SmartLocker',
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
        Locale('th'),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Smart Locker'),
        '/unlock': (context) => const LockerSelectionPage(mode: LockerSelectionMode.unlock),
        '/user-type-page' : (context) => const UserTypePage(),
        '/otp-unlock-page' : (context) => const OTPPage(from: FromPage.unlock),
        '/test-page' : (context)  => const OvertimePage(second: '', day: '', hour: '', minute: '', lockerId: '')
      },
    );
  }
}


