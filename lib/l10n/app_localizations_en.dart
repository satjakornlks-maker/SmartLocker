// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get hello => 'Hello';

  @override
  String get welcome => 'Welcome';

  @override
  String get receive => 'Receive';

  @override
  String get deposit => 'Deposit';

  @override
  String get chose => 'Select the service you wish to proceed with.';

  @override
  String get employee => 'Employee';

  @override
  String get visitor => 'Visitor';

  @override
  String get small => 'Small';

  @override
  String get medium => 'Medium';

  @override
  String get large => 'Large';

  @override
  String get userType => 'Chose your user type.';

  @override
  String get choseLockerType => 'Chose locker size.';

  @override
  String get choseLocker => 'Chose locker.';

  @override
  String get randomLocker => 'Random locker';

  @override
  String get usageMethod => 'Chose usage method.';

  @override
  String get register => 'Registration (employee only)';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Phone';

  @override
  String get choseInput => 'Chose contact type.';

  @override
  String get selectLocker => 'Select your locker.';

  @override
  String get empty => 'Empty';

  @override
  String get occupiedLegend => 'Occupied';

  @override
  String get choosing => 'Choosing';

  @override
  String get cantBeUse => 'Can\'t be use';

  @override
  String get confirm => 'Confirm';

  @override
  String get proceed => 'Proceed';

  @override
  String get unlock => 'Unlock';

  @override
  String get phoneInstruct => 'Enter your phone number.';

  @override
  String get emailInstruct => 'Enter your email address';

  @override
  String get resend => 'Resend OTP';

  @override
  String get referCode => 'REFER CODE';

  @override
  String get sendTo => 'Send to';

  @override
  String get forLocker => 'For locker';

  @override
  String get resetPass => 'To change password, Fill in the correct PIN.';

  @override
  String get changePass => 'Fill in your new password.';

  @override
  String get otpInstruct => 'Fill in your OTP';

  @override
  String get resetPassOption => 'Change password (employee only).';

  @override
  String get forgotPass => 'Forgot password';

  @override
  String get successTitle => 'Locker has been open';

  @override
  String get successSupTitle => 'Thank you for using Smart Locker';

  @override
  String get registerSuccess => 'Register successful.';

  @override
  String get errorOccur => 'An error has occur.';

  @override
  String get noLocker => 'No locker available.';

  @override
  String get optSuccess => 'OTP has been sent';

  @override
  String get otpWarning => 'Please fill all 6 digit.';

  @override
  String get wrongOtp => 'This OTP not match any available OTP.';

  @override
  String get wrongEmail => 'This email not match the registered email.';

  @override
  String get noAvailableLocker =>
      'None of the lockers are available at the moment.';

  @override
  String get loading => 'Loading locker data...';

  @override
  String get wrongPhone => 'This number doesn\'t match the registered number.';

  @override
  String get locker => 'Locker';

  @override
  String get occupied => 'Are currently occupied';

  @override
  String get noAvailable =>
      'No Available Locker(All locker has been open or the entire locker are disable)';
}
