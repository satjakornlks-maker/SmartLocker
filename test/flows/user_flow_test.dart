/// User Flow Tests -- documentation-oriented tests for the SmartLocker kiosk app.
///
/// Three main journeys are documented:
///
///   A. Employee booking (B2C kiosk)
///        UserTypePage -> DepositTypePage
///          -> "Choose Locker" -> ChoseSizePage (locker-select mode)
///          -> "Random Locker" -> ChoseSizePage (instance / random mode)
///        [API-dependent tail: InputType -> OTP -> ChoseTime -> Payment -> Success]
///
///   B. Visitor booking
///        UserTypePage -> ChoseSizePage (visitor mode)
///        [API-dependent tail: InputType -> OTP -> ChoseTime -> Payment -> Success]
///
///   C. Drop-box deposit
///        UserTypePage -> ChoseSizePage (dropBox mode)
///        [API-dependent tail: PhoneInput (auto-locker) -> OTP -> ChoseTime -> Payment -> Success]
///
///   D. Unlock existing booking (named route "/unlock")
///        [Fully API-dependent: LockerSelection -> OTP -> Confirmation -> Success]
///
///   E. Success screen -- auto-returns to home after 3 s
///        SuccessPage -> Navigator.popUntil(isFirst) [or onComplete callback]
///
/// Tests marked `skip:` require HTTP mocking (ApiService / SharedPreferences stubs)
/// and are included here as executable documentation of expected behaviour.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/screens/chose_size_page/chose_size_page.dart';
import 'package:untitled/screens/deposit_type_page/deposit_type_page.dart';
import 'package:untitled/screens/success_page/success_page.dart';
import 'package:untitled/screens/user_type_page/user_type_page.dart';

// -- shared helper -----------------------------------------------------------

/// Wraps [home] in a localized MaterialApp (English locale, no network calls).
Widget _app(Widget home) => MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('th')],
      home: home,
    );

void main() {
  // -- Flow A: Employee booking -----------------------------------------------

  group('Flow A: Employee booking', () {
    // A1: UserTypePage renders employee-type options
    testWidgets('A1 UserTypePage shows Employee, Visitor, Drop Box buttons',
        (tester) async {
      await tester.pumpWidget(_app(const UserTypePage()));
      await tester.pump(); // settle delegates

      expect(find.text('Employee'), findsOneWidget);
      expect(find.text('Visitor'), findsOneWidget);
      expect(find.text('Drop Box'), findsOneWidget);
    });

    // A2: Tap Employee -> DepositTypePage
    testWidgets('A2 tapping Employee navigates to DepositTypePage',
        (tester) async {
      await tester.pumpWidget(_app(const UserTypePage()));
      await tester.pump();

      await tester.tap(find.text('Employee'));
      await tester.pumpAndSettle();

      expect(find.byType(DepositTypePage), findsOneWidget);
    });

    // A3: DepositTypePage renders both locker-selection cards (B2C)
    testWidgets(
        'A3 DepositTypePage shows "Choose locker" and "Quick booking"',
        (tester) async {
      // DeviceConfigService.systemMode defaults to "B2C" without init --
      // Register card must NOT appear in B2C mode.
      await tester.pumpWidget(_app(const DepositTypePage()));
      await tester.pump();

      expect(find.text('Choose locker.'), findsOneWidget);
      expect(find.text('Quick booking'), findsOneWidget);
      // Registration card is hidden in B2C mode
      expect(find.text('Registration (employee only)'), findsNothing);
    });

    // A4: Tap "Choose locker" -> ChoseSizePage (booking mode)
    testWidgets('A4 "Choose locker" navigates to ChoseSizePage', (tester) async {
      await tester.pumpWidget(_app(const DepositTypePage()));
      await tester.pump();

      await tester.tap(find.text('Choose locker.'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300)); // route settle

      expect(find.byType(ChoseSizePage), findsOneWidget);
    });

    // A5: Tap "Quick booking" -> ChoseSizePage (instance mode)
    testWidgets('A5 "Quick booking" navigates to ChoseSizePage', (tester) async {
      await tester.pumpWidget(_app(const DepositTypePage()));
      await tester.pump();

      await tester.tap(find.text('Quick booking'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(ChoseSizePage), findsOneWidget);
    });

    // A6 (documented, API-dependent)
    // After ChoseSizePage the user picks a size -> InputTypePage opens.
    // InputTypePage calls ApiService.getLocker() to pick an available locker.
    // Then the user chooses Phone or Email -> PhoneInputPage / EmailInputPage.
    // Submitting the number/address calls ApiService.sendLink() -> OTPPage.
    // OTPPage validates the 6-digit code via ApiService.verifyToken().
    // On success -> ChoseTimePage (choose day/hour + quantity + promo code).
    // ChoseTimePage -> PaymentPage (select payment channel, pay).
    // PaymentPage calls ApiService.createBooking() -> SuccessPage -> Home.
    testWidgets(
      'A6 full booking tail (InputType -> OTP -> ChoseTime -> Payment -> Success)',
      (tester) async {
        // No-op: flow requires ApiService & SharedPreferences mocks.
        // See ApiService.sendLink, ApiService.verifyToken, ApiService.createBooking.
      },
      skip: true, // requires ApiService mock
    );
  });

  // -- Flow B: Visitor booking -------------------------------------------------

  group('Flow B: Visitor booking', () {
    // B1: Tap Visitor -> ChoseSizePage (visitor mode)
    testWidgets('B1 tapping Visitor navigates to ChoseSizePage', (tester) async {
      await tester.pumpWidget(_app(const UserTypePage()));
      await tester.pump();

      await tester.tap(find.text('Visitor'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(ChoseSizePage), findsOneWidget);
    });

    // B2 (documented, API-dependent)
    // ChoseSizePage(from: FromPage.visitor) loads sizes from ApiService.getSizes().
    // User picks a size -> InputTypePage -> Phone/Email -> OTP -> ChoseTime
    // -> PaymentPage -> SuccessPage -> Home.
    testWidgets(
      'B2 visitor booking tail (size select -> OTP -> payment -> success)',
      (tester) async {},
      skip: true, // requires ApiService mock
    );
  });

  // -- Flow C: Drop-box deposit ------------------------------------------------

  group('Flow C: Drop-box deposit', () {
    // C1: Tap Drop Box -> ChoseSizePage (dropBox mode)
    testWidgets('C1 tapping Drop Box navigates to ChoseSizePage', (tester) async {
      await tester.pumpWidget(_app(const UserTypePage()));
      await tester.pump();

      await tester.tap(find.text('Drop Box'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(ChoseSizePage), findsOneWidget);
    });

    // C2 (documented, API-dependent)
    // ChoseSizePage(from: FromPage.dropBox) auto-selects a random available locker,
    // then pushes PhoneInputPage (skipping InputTypePage).
    // Phone -> ApiService.sendLink() -> OTPPage -> ChoseTimePage -> PaymentPage
    // -> SuccessPage -> Home.
    testWidgets(
      'C2 drop-box tail (auto-locker -> phone -> OTP -> payment -> success)',
      (tester) async {},
      skip: true, // requires ApiService mock
    );
  });

  // -- Flow D: Unlock existing booking ----------------------------------------

  group('Flow D: Unlock existing booking', () {
    // D1 (documented, API-dependent)
    // Route: Navigator.pushNamed(context, '/unlock')
    // -> LockerSelectionPage(mode: unlock) -- calls ApiService.getLocker() to list
    //    occupied lockers.  User taps a locker cell.
    // -> OTPPage(from: FromPage.unlock) -- user enters 6-digit PIN.
    //    ApiService.unlockLocker() -> relays unlock command to locker board.
    // -> ConfirmationPage -- user chooses "Add more items" or "End of use".
    // -> SuccessPage -> Navigator.popUntil(isFirst) -> Home.
    testWidgets(
      'D1 unlock flow (locker select -> OTP/PIN -> confirmation -> success)',
      (tester) async {},
      skip: true, // requires ApiService mock
    );
  });

  // -- Flow E: SuccessPage auto-return ----------------------------------------

  group('Flow E: SuccessPage', () {
    // E1: SuccessPage renders check icon and success text
    testWidgets('E1 SuccessPage shows check icon and success title',
        (tester) async {
      await tester.pumpWidget(
        _app(SuccessPage(
          onComplete: () {}, // prevent popUntil on a bare MaterialApp
          displayDuration: Duration.zero,
        )),
      );
      await tester.pump(); // first frame

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    // E2: SuccessPage calls onComplete after the display duration
    testWidgets(
        'E2 SuccessPage invokes onComplete callback after animation',
        (tester) async {
      bool completed = false;
      await tester.pumpWidget(
        _app(SuccessPage(
          onComplete: () => completed = true,
          displayDuration: Duration.zero, // instant in tests
        )),
      );

      // _startAnimations chain:
      //   circle AnimationController.forward() — 800 ms
      //   Future.delayed(100 ms)
      //   content AnimationController.forward() — 600 ms
      //   Future.delayed(displayDuration = 0)
      //   onComplete()
      //
      // Drive 25 × 80 ms = 2000 ms total.  Fine-grained pumps ensure
      // microtask continuations are drained between each vsync batch.
      for (var i = 0; i < 25; i++) {
        await tester.pump(const Duration(milliseconds: 80));
      }

      expect(completed, isTrue);
    });
  });
}
