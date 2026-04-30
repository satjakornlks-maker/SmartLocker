import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('th'),
  ];

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @receive.
  ///
  /// In en, this message translates to:
  /// **'Receive'**
  String get receive;

  /// No description provided for @deposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get deposit;

  /// No description provided for @chose.
  ///
  /// In en, this message translates to:
  /// **'Select the service you wish to proceed with.'**
  String get chose;

  /// No description provided for @chooseService.
  ///
  /// In en, this message translates to:
  /// **'Select the service you wish to proceed with.'**
  String get chooseService;

  /// No description provided for @employee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get employee;

  /// No description provided for @visitor.
  ///
  /// In en, this message translates to:
  /// **'Visitor'**
  String get visitor;

  /// No description provided for @small.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get small;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @large.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get large;

  /// No description provided for @userType.
  ///
  /// In en, this message translates to:
  /// **'Choose your user type.'**
  String get userType;

  /// No description provided for @choseLockerType.
  ///
  /// In en, this message translates to:
  /// **'Choose locker size.'**
  String get choseLockerType;

  /// No description provided for @choseLocker.
  ///
  /// In en, this message translates to:
  /// **'Choose locker.'**
  String get choseLocker;

  /// No description provided for @randomLocker.
  ///
  /// In en, this message translates to:
  /// **'Quick booking'**
  String get randomLocker;

  /// No description provided for @usageMethod.
  ///
  /// In en, this message translates to:
  /// **'Choose usage method.'**
  String get usageMethod;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Registration (employee only)'**
  String get register;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @choseInput.
  ///
  /// In en, this message translates to:
  /// **'Choose contact type.'**
  String get choseInput;

  /// No description provided for @selectLocker.
  ///
  /// In en, this message translates to:
  /// **'Select your locker.'**
  String get selectLocker;

  /// No description provided for @occupiedLegend.
  ///
  /// In en, this message translates to:
  /// **'Occupied'**
  String get occupiedLegend;

  /// No description provided for @choosing.
  ///
  /// In en, this message translates to:
  /// **'Choosing'**
  String get choosing;

  /// No description provided for @cantBeUse.
  ///
  /// In en, this message translates to:
  /// **'Can\'t be used'**
  String get cantBeUse;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get proceed;

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// No description provided for @phoneInstruct.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number — we\'ll send a one-time code.'**
  String get phoneInstruct;

  /// No description provided for @emailInstruct.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address — we\'ll send a one-time code.'**
  String get emailInstruct;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resend;

  /// No description provided for @referCode.
  ///
  /// In en, this message translates to:
  /// **'REFER CODE'**
  String get referCode;

  /// No description provided for @sendTo.
  ///
  /// In en, this message translates to:
  /// **'Send to'**
  String get sendTo;

  /// No description provided for @forLocker.
  ///
  /// In en, this message translates to:
  /// **'For locker'**
  String get forLocker;

  /// No description provided for @resetPass.
  ///
  /// In en, this message translates to:
  /// **'Please fill in the correct OTP.'**
  String get resetPass;

  /// No description provided for @changePass.
  ///
  /// In en, this message translates to:
  /// **'Fill in your new password.'**
  String get changePass;

  /// No description provided for @otpInstruct.
  ///
  /// In en, this message translates to:
  /// **'Fill in your OTP.'**
  String get otpInstruct;

  /// No description provided for @resetPassOption.
  ///
  /// In en, this message translates to:
  /// **'Change password (employee only).'**
  String get resetPassOption;

  /// No description provided for @forgotPass.
  ///
  /// In en, this message translates to:
  /// **'Get new OTP'**
  String get forgotPass;

  /// No description provided for @successTitle.
  ///
  /// In en, this message translates to:
  /// **'Locker has been opened'**
  String get successTitle;

  /// No description provided for @successSupTitle.
  ///
  /// In en, this message translates to:
  /// **'Look for the locker with the flashing light and push it to open. Thank you for using Smart Locker.'**
  String get successSupTitle;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registered successfully.'**
  String get registerSuccess;

  /// No description provided for @errorOccur.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorOccur;

  /// No description provided for @noLocker.
  ///
  /// In en, this message translates to:
  /// **'No locker available.'**
  String get noLocker;

  /// No description provided for @otpSuccess.
  ///
  /// In en, this message translates to:
  /// **'OTP has been sent'**
  String get otpSuccess;

  /// No description provided for @otpWarning.
  ///
  /// In en, this message translates to:
  /// **'Please enter all 6 digits.'**
  String get otpWarning;

  /// No description provided for @wrongOtp.
  ///
  /// In en, this message translates to:
  /// **'That code doesn\'t match. Please check and try again.'**
  String get wrongOtp;

  /// No description provided for @wrongEmail.
  ///
  /// In en, this message translates to:
  /// **'This email isn\'t registered. Please check and try again.'**
  String get wrongEmail;

  /// No description provided for @noAvailableLocker.
  ///
  /// In en, this message translates to:
  /// **'No lockers are available at the moment.'**
  String get noAvailableLocker;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading locker data…'**
  String get loading;

  /// No description provided for @wrongPhone.
  ///
  /// In en, this message translates to:
  /// **'This phone number isn\'t registered. Please check and try again.'**
  String get wrongPhone;

  /// No description provided for @locker.
  ///
  /// In en, this message translates to:
  /// **'Locker'**
  String get locker;

  /// No description provided for @empty.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get empty;

  /// No description provided for @occupied.
  ///
  /// In en, this message translates to:
  /// **'Currently occupied'**
  String get occupied;

  /// No description provided for @noAvailable.
  ///
  /// In en, this message translates to:
  /// **'No lockers are available right now (all lockers are open or disabled).'**
  String get noAvailable;

  /// No description provided for @cardReaderInstruct.
  ///
  /// In en, this message translates to:
  /// **'Or use the card reader.'**
  String get cardReaderInstruct;

  /// No description provided for @addMoreItem.
  ///
  /// In en, this message translates to:
  /// **'Open to add more items.'**
  String get addMoreItem;

  /// No description provided for @endOfUse.
  ///
  /// In en, this message translates to:
  /// **'Open to end use of this locker.'**
  String get endOfUse;

  /// No description provided for @whatWouldYouLikeToDo.
  ///
  /// In en, this message translates to:
  /// **'What would you like to do?'**
  String get whatWouldYouLikeToDo;

  /// No description provided for @registrationComplete.
  ///
  /// In en, this message translates to:
  /// **'Registration complete!'**
  String get registrationComplete;

  /// No description provided for @awaitingApproval.
  ///
  /// In en, this message translates to:
  /// **'Waiting for admin approval.'**
  String get awaitingApproval;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get backToHome;

  /// No description provided for @choosePreferredMethod.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred method'**
  String get choosePreferredMethod;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fill in your details to register for locker access.'**
  String get registerSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name.'**
  String get pleaseEnterName;

  /// No description provided for @pleaseEnterReason.
  ///
  /// In en, this message translates to:
  /// **'Please enter a reason.'**
  String get pleaseEnterReason;

  /// No description provided for @reasonForBooking.
  ///
  /// In en, this message translates to:
  /// **'Reason for booking'**
  String get reasonForBooking;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @submitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit request'**
  String get submitRequest;

  /// No description provided for @bookingTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking type\n(Day or Hour)'**
  String get bookingTypeTitle;

  /// No description provided for @bookByDay.
  ///
  /// In en, this message translates to:
  /// **'Book by day'**
  String get bookByDay;

  /// No description provided for @bookByHour.
  ///
  /// In en, this message translates to:
  /// **'Book by hour'**
  String get bookByHour;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'Hour'**
  String get hour;

  /// No description provided for @dayType.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get dayType;

  /// No description provided for @hourType.
  ///
  /// In en, this message translates to:
  /// **'Hourly'**
  String get hourType;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @priceDetails.
  ///
  /// In en, this message translates to:
  /// **'Price and promotion details'**
  String get priceDetails;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @baht.
  ///
  /// In en, this message translates to:
  /// **'Baht'**
  String get baht;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total amount'**
  String get totalAmount;

  /// No description provided for @promoCode.
  ///
  /// In en, this message translates to:
  /// **'Promo code'**
  String get promoCode;

  /// No description provided for @enterPromoCode.
  ///
  /// In en, this message translates to:
  /// **'Enter promo code'**
  String get enterPromoCode;

  /// No description provided for @applyCode.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get applyCode;

  /// No description provided for @invalidPromoCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid promo code'**
  String get invalidPromoCode;

  /// No description provided for @pleaseEnterPromoCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter a promo code'**
  String get pleaseEnterPromoCode;

  /// No description provided for @proceedBooking.
  ///
  /// In en, this message translates to:
  /// **'Proceed with booking'**
  String get proceedBooking;

  /// No description provided for @lockerOpenedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Locker opened successfully'**
  String get lockerOpenedSuccess;

  /// No description provided for @pleaseSpecifyAmount.
  ///
  /// In en, this message translates to:
  /// **'Please specify the amount'**
  String get pleaseSpecifyAmount;

  /// No description provided for @discountCode.
  ///
  /// In en, this message translates to:
  /// **'Discount code'**
  String get discountCode;

  /// No description provided for @promoApplied.
  ///
  /// In en, this message translates to:
  /// **'Code applied!'**
  String get promoApplied;

  /// No description provided for @availablePromotions.
  ///
  /// In en, this message translates to:
  /// **'Available promotions'**
  String get availablePromotions;

  /// No description provided for @paymentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete your locker booking'**
  String get paymentSubtitle;

  /// No description provided for @paymentChannels.
  ///
  /// In en, this message translates to:
  /// **'Payment channels'**
  String get paymentChannels;

  /// No description provided for @scanToPayPromptPay.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code to pay via PromptPay'**
  String get scanToPayPromptPay;

  /// No description provided for @totalDuration.
  ///
  /// In en, this message translates to:
  /// **'Total duration'**
  String get totalDuration;

  /// No description provided for @amountDue.
  ///
  /// In en, this message translates to:
  /// **'Amount due'**
  String get amountDue;

  /// No description provided for @discountDetails.
  ///
  /// In en, this message translates to:
  /// **'Discount details'**
  String get discountDetails;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay now'**
  String get payNow;

  /// No description provided for @qrPayment.
  ///
  /// In en, this message translates to:
  /// **'QR Payment'**
  String get qrPayment;

  /// No description provided for @qrPaymentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Supports major banking apps'**
  String get qrPaymentSubtitle;

  /// No description provided for @creditCard.
  ///
  /// In en, this message translates to:
  /// **'Credit / Debit Card'**
  String get creditCard;

  /// No description provided for @creditCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Visa and Mastercard accepted'**
  String get creditCardSubtitle;

  /// No description provided for @aliPaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scan with Alipay'**
  String get aliPaySubtitle;

  /// No description provided for @linePaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scan with LINE Pay'**
  String get linePaySubtitle;

  /// No description provided for @supportedApps.
  ///
  /// In en, this message translates to:
  /// **'Supported apps'**
  String get supportedApps;

  /// No description provided for @scanWithBankApp.
  ///
  /// In en, this message translates to:
  /// **'Scan with your banking app'**
  String get scanWithBankApp;

  /// No description provided for @overtimeWarning.
  ///
  /// In en, this message translates to:
  /// **'You\'ve exceeded your booking time.\nPlease pay the fine to unlock your locker.'**
  String get overtimeWarning;

  /// No description provided for @overtimeExceeded.
  ///
  /// In en, this message translates to:
  /// **'Overtime used'**
  String get overtimeExceeded;

  /// No description provided for @overtimeFine.
  ///
  /// In en, this message translates to:
  /// **'Fine to pay'**
  String get overtimeFine;

  /// No description provided for @overtimePaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment options'**
  String get overtimePaymentTitle;

  /// No description provided for @autoOpenNote.
  ///
  /// In en, this message translates to:
  /// **'After payment, please wait a moment. The locker will open automatically.'**
  String get autoOpenNote;

  /// No description provided for @dropBox.
  ///
  /// In en, this message translates to:
  /// **'Drop Box'**
  String get dropBox;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SMART LOCKER'**
  String get appTitle;

  /// No description provided for @scanQrTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan QR to register'**
  String get scanQrTitle;

  /// No description provided for @scanQrSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register on your phone by scanning this QR code.'**
  String get scanQrSubtitle;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @sessionTimeoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Session timed out'**
  String get sessionTimeoutTitle;

  /// No description provided for @sessionTimeoutMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ve been inactive. Returning to home.'**
  String get sessionTimeoutMessage;

  /// No description provided for @deleteDigit.
  ///
  /// In en, this message translates to:
  /// **'Delete last digit'**
  String get deleteDigit;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get goBack;

  /// No description provided for @languageSwitch.
  ///
  /// In en, this message translates to:
  /// **'Switch language'**
  String get languageSwitch;

  /// No description provided for @loadingGeneric.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loadingGeneric;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait'**
  String get pleaseWait;

  /// No description provided for @errorEnterEmailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number or email.'**
  String get errorEnterEmailOrPhone;

  /// No description provided for @errorInvalidEmailFormat.
  ///
  /// In en, this message translates to:
  /// **'That email format isn\'t valid.'**
  String get errorInvalidEmailFormat;

  /// No description provided for @errorPhoneMustBe10Digits.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be 10 digits.'**
  String get errorPhoneMustBe10Digits;

  /// No description provided for @errorEnterValidEmailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email or phone number.'**
  String get errorEnterValidEmailOrPhone;

  /// No description provided for @errorEnterOtp.
  ///
  /// In en, this message translates to:
  /// **'Please enter the OTP.'**
  String get errorEnterOtp;

  /// No description provided for @errorOtpInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 6-digit OTP.'**
  String get errorOtpInvalid;

  /// No description provided for @errorEnterPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number.'**
  String get errorEnterPhone;

  /// No description provided for @errorEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email.'**
  String get errorEnterEmail;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'That email isn\'t valid.'**
  String get errorInvalidEmail;

  /// No description provided for @otpUnlockPage.
  ///
  /// In en, this message translates to:
  /// **'Enter your OTP that you got from booking SMS'**
  String get otpUnlockPage;

  /// No description provided for @yourLocker.
  ///
  /// In en, this message translates to:
  /// **'Your locker'**
  String get yourLocker;

  /// No description provided for @notAuthorizedEmployee.
  ///
  /// In en, this message translates to:
  /// **'You are not authorised to use this locker. Please contact the administrator.'**
  String get notAuthorizedEmployee;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get enterPassword;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get wrongPassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get settingsSaved;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customize screen and system settings'**
  String get settingsSubtitle;

  /// No description provided for @sectionDisplay.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get sectionDisplay;

  /// No description provided for @sectionSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get sectionSystem;

  /// No description provided for @sectionSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get sectionSecurity;

  /// No description provided for @fieldAppTitle.
  ///
  /// In en, this message translates to:
  /// **'App title'**
  String get fieldAppTitle;

  /// No description provided for @fieldHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home title'**
  String get fieldHomeTitle;

  /// No description provided for @fieldLogoAsset.
  ///
  /// In en, this message translates to:
  /// **'Logo path'**
  String get fieldLogoAsset;

  /// No description provided for @fieldFooterLeft.
  ///
  /// In en, this message translates to:
  /// **'Footer left text'**
  String get fieldFooterLeft;

  /// No description provided for @fieldContactInfo.
  ///
  /// In en, this message translates to:
  /// **'Emergency contact'**
  String get fieldContactInfo;

  /// No description provided for @fieldSettingsPassword.
  ///
  /// In en, this message translates to:
  /// **'Settings password'**
  String get fieldSettingsPassword;

  /// No description provided for @fieldSettingsPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Set new password (default: admin)'**
  String get fieldSettingsPasswordHint;

  /// No description provided for @emailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get emailPlaceholder;

  /// No description provided for @emailAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddressLabel;

  /// No description provided for @decreaseUnit.
  ///
  /// In en, this message translates to:
  /// **'Decrease {unit}'**
  String decreaseUnit(String unit);

  /// No description provided for @increaseUnit.
  ///
  /// In en, this message translates to:
  /// **'Increase {unit}'**
  String increaseUnit(String unit);

  /// No description provided for @tapToChooseLocker.
  ///
  /// In en, this message translates to:
  /// **'Tap to choose a locker.'**
  String get tapToChooseLocker;

  /// No description provided for @tapForQuickBooking.
  ///
  /// In en, this message translates to:
  /// **'Tap for quick booking.'**
  String get tapForQuickBooking;

  /// No description provided for @tapToPickSize.
  ///
  /// In en, this message translates to:
  /// **'Tap to pick this size.'**
  String get tapToPickSize;

  /// No description provided for @tapToSignInWithPhone.
  ///
  /// In en, this message translates to:
  /// **'Tap to sign in with phone number.'**
  String get tapToSignInWithPhone;

  /// No description provided for @tapToSignInWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Tap to sign in with email.'**
  String get tapToSignInWithEmail;

  /// No description provided for @tapToRegisterNow.
  ///
  /// In en, this message translates to:
  /// **'Tap to register now.'**
  String get tapToRegisterNow;

  /// No description provided for @submitPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Submit your phone number.'**
  String get submitPhoneNumber;

  /// No description provided for @submitOtpCode.
  ///
  /// In en, this message translates to:
  /// **'Submit the 6-digit OTP code.'**
  String get submitOtpCode;

  /// No description provided for @submitEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Submit your email address.'**
  String get submitEmailAddress;

  /// No description provided for @digitLabel.
  ///
  /// In en, this message translates to:
  /// **'Digit {digit}'**
  String digitLabel(String digit);

  /// No description provided for @otpEntryStatus.
  ///
  /// In en, this message translates to:
  /// **'OTP entry. {filled} of 6 digits entered.'**
  String otpEntryStatus(int filled);

  /// No description provided for @lockerStatusDisabled.
  ///
  /// In en, this message translates to:
  /// **'disabled'**
  String get lockerStatusDisabled;

  /// No description provided for @lockerStatusNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'not available for this selection'**
  String get lockerStatusNotAvailable;

  /// No description provided for @lockerStatusOccupiedUnlock.
  ///
  /// In en, this message translates to:
  /// **'occupied, tap to unlock'**
  String get lockerStatusOccupiedUnlock;

  /// No description provided for @lockerStatusEmpty.
  ///
  /// In en, this message translates to:
  /// **'empty'**
  String get lockerStatusEmpty;

  /// No description provided for @lockerStatusAvailable.
  ///
  /// In en, this message translates to:
  /// **'available, tap to select'**
  String get lockerStatusAvailable;

  /// No description provided for @lockerStatusOccupied.
  ///
  /// In en, this message translates to:
  /// **'occupied'**
  String get lockerStatusOccupied;

  /// No description provided for @lockerSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Locker {name}. {status}.'**
  String lockerSemanticLabel(String name, String status);

  /// No description provided for @currentLanguageName.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get currentLanguageName;

  /// No description provided for @switchToEnglish.
  ///
  /// In en, this message translates to:
  /// **'Switch to English'**
  String get switchToEnglish;

  /// No description provided for @switchToThai.
  ///
  /// In en, this message translates to:
  /// **'เปลี่ยนเป็นภาษาไทย'**
  String get switchToThai;

  /// No description provided for @depositSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start Deposit process'**
  String get depositSubtitle;

  /// No description provided for @receiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive your package via OTP'**
  String get receiveSubtitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'th':
      return AppLocalizationsTh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
