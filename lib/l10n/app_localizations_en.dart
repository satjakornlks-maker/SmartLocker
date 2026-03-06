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
  String get userType => 'Choose your user type.';

  @override
  String get choseLockerType => 'Choose locker size.';

  @override
  String get choseLocker => 'Choose locker.';

  @override
  String get randomLocker => 'Random locker';

  @override
  String get usageMethod => 'Choose usage method.';

  @override
  String get register => 'Registration (employee only)';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Phone';

  @override
  String get choseInput => 'Choose contact type.';

  @override
  String get selectLocker => 'Select your locker.';

  @override
  String get occupiedLegend => 'Occupied';

  @override
  String get choosing => 'Choosing';

  @override
  String get cantBeUse => 'Can\'t be used';

  @override
  String get confirm => 'Confirm';

  @override
  String get proceed => 'Proceed';

  @override
  String get unlock => 'Unlock';

  @override
  String get phoneInstruct => 'Enter your phone number.';

  @override
  String get emailInstruct => 'Enter your email address.';

  @override
  String get resend => 'Resend OTP';

  @override
  String get referCode => 'REFER CODE';

  @override
  String get sendTo => 'Send to';

  @override
  String get forLocker => 'For locker';

  @override
  String get resetPass => 'Please fill in the correct OTP.';

  @override
  String get changePass => 'Fill in your new password.';

  @override
  String get otpInstruct => 'Fill in your OTP.';

  @override
  String get resetPassOption => 'Change password (employee only).';

  @override
  String get forgotPass => 'Get new OTP';

  @override
  String get successTitle => 'Locker has been opened';

  @override
  String get successSupTitle => 'Thank you for using Smart Locker';

  @override
  String get registerSuccess => 'Register successful.';

  @override
  String get errorOccur => 'An error has occurred.';

  @override
  String get noLocker => 'No locker available.';

  @override
  String get otpSuccess => 'OTP has been sent';

  @override
  String get otpWarning => 'Please fill all 6 digits.';

  @override
  String get wrongOtp => 'This PIN does not match the registered PIN.';

  @override
  String get wrongEmail => 'This email does not match the registered email.';

  @override
  String get noAvailableLocker =>
      'None of the lockers are available at the moment.';

  @override
  String get loading => 'Loading locker data...';

  @override
  String get wrongPhone => 'This number does not match the registered number.';

  @override
  String get locker => 'Locker';

  @override
  String get empty => 'Empty';

  @override
  String get occupied => 'Currently occupied';

  @override
  String get noAvailable =>
      'No available locker (all lockers have been opened or are disabled)';

  @override
  String get cardReaderInstruct => 'Or use card reader.';

  @override
  String get addMoreItem => 'Open to add more items.';

  @override
  String get endOfUse => 'Open to end the use of this locker.';

  @override
  String get bookingTypeTitle => 'Booking type\n(Day or Hour)';

  @override
  String get bookByDay => 'Book by day';

  @override
  String get bookByHour => 'Book by hour';

  @override
  String get day => 'Day';

  @override
  String get hour => 'Hour';

  @override
  String get dayType => 'Daily';

  @override
  String get hourType => 'Hourly';

  @override
  String get amount => 'Amount';

  @override
  String get priceDetails => 'Price and promotion details';

  @override
  String get price => 'Price';

  @override
  String get baht => 'Baht';

  @override
  String get totalAmount => 'Total amount';

  @override
  String get promoCode => 'Promo code';

  @override
  String get enterPromoCode => 'Enter promo code';

  @override
  String get applyCode => 'Apply';

  @override
  String get invalidPromoCode => 'Invalid promo code';

  @override
  String get pleaseEnterPromoCode => 'Please enter a promo code';

  @override
  String get proceedBooking => 'Proceed with booking';

  @override
  String get lockerOpenedSuccess => 'Locker opened successfully';

  @override
  String get pleaseSpecifyAmount => 'Please specify the amount';

  @override
  String get discountCode => 'Discount code';

  @override
  String get promoApplied => 'Code applied!';

  @override
  String get availablePromotions => 'Available promotions';

  @override
  String get paymentSubtitle => 'Complete your locker booking';

  @override
  String get paymentChannels => 'Payment channels';

  @override
  String get scanToPayPromptPay => 'Scan QR code to pay via PromptPay';

  @override
  String get totalDuration => 'Total duration';

  @override
  String get amountDue => 'Amount due';

  @override
  String get discountDetails => 'Discount details';

  @override
  String get payNow => 'Pay now';

  @override
  String get qrPayment => 'QR Payment';

  @override
  String get qrPaymentSubtitle => 'Supports major banking apps';

  @override
  String get creditCard => 'Credit / Debit Card';

  @override
  String get creditCardSubtitle => 'Visa and Mastercard accepted';

  @override
  String get aliPaySubtitle => 'Scan with Alipay';

  @override
  String get linePaySubtitle => 'Scan with LINE Pay';

  @override
  String get supportedApps => 'Supported apps';

  @override
  String get scanWithBankApp => 'Scan with your banking app';

  @override
  String get overtimeWarning =>
      'You have exceeded your booking time.\nPlease pay the fine to unlock your locker.';

  @override
  String get overtimeExceeded => 'Overtime used';

  @override
  String get overtimeFine => 'Fine to pay';

  @override
  String get overtimePaymentTitle => 'Payment options';

  @override
  String get autoOpenNote =>
      'After payment, please wait a moment. The locker will open automatically.';

  @override
  String get dropBox => 'Drop Box';
}
