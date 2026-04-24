// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get hello => 'สวัสดี';

  @override
  String get welcome => 'ยินดีต้อนรับ';

  @override
  String get receive => 'รับของ';

  @override
  String get deposit => 'ฝากของ';

  @override
  String get chose => 'เลือกรายการที่ท่านต้องการดำเนินการ';

  @override
  String get chooseService => 'เลือกรายการที่ท่านต้องการดำเนินการ';

  @override
  String get employee => 'พนักงาน';

  @override
  String get visitor => 'ผู้เยี่ยมชม';

  @override
  String get small => 'เล็ก';

  @override
  String get medium => 'กลาง';

  @override
  String get large => 'ใหญ่';

  @override
  String get userType => 'เลือกประเภทผู้ใช้';

  @override
  String get choseLockerType => 'เลือกขนาดของล็อคเกอร์';

  @override
  String get choseLocker => 'เลือกล็อคเกอร์';

  @override
  String get randomLocker => 'จองด่วน';

  @override
  String get usageMethod => 'กรุณาเลือกวิธีการเข้าใช้งาน';

  @override
  String get register => 'ลงทะเบียนพนักงาน (ใช้งานประจำ)';

  @override
  String get email => 'อีเมล';

  @override
  String get phone => 'เบอร์โทรศัพท์';

  @override
  String get choseInput => 'เลือกวิธีการกรอกข้อมูล';

  @override
  String get selectLocker => 'เลือกตู้ล็อคเกอร์ที่ต้องการ';

  @override
  String get occupiedLegend => 'ไม่ว่าง';

  @override
  String get choosing => 'กำลังเลือก';

  @override
  String get cantBeUse => 'ไม่พร้อมใช้งาน';

  @override
  String get confirm => 'ยืนยัน';

  @override
  String get proceed => 'ดำเนินการต่อ';

  @override
  String get unlock => 'ปลดล็อค';

  @override
  String get phoneInstruct => 'กรอกเบอร์โทรศัพท์ — ระบบจะส่งรหัส OTP ให้';

  @override
  String get emailInstruct => 'กรอกอีเมล — ระบบจะส่งรหัส OTP ให้';

  @override
  String get resend => 'ส่งรหัสใหม่';

  @override
  String get referCode => 'รหัสอ้างอิง';

  @override
  String get sendTo => 'ส่งไปยัง';

  @override
  String get forLocker => 'สำหรับตู้';

  @override
  String get resetPass => 'กรุณากรอกรหัสผ่าน (OTP) ที่ถูกต้อง';

  @override
  String get changePass => 'กรุณากรอกรหัสผ่านใหม่ที่ท่านต้องการเปลี่ยน';

  @override
  String get otpInstruct => 'กรุณากรอกรหัส OTP';

  @override
  String get resetPassOption => 'เปลี่ยนรหัสผ่าน (สำหรับจองประจำ)';

  @override
  String get forgotPass => 'รับ OTP ใหม่';

  @override
  String get successTitle => 'ตู้ได้ถูกเปิดออกแล้ว';

  @override
  String get successSupTitle =>
      'มองหาตู้ที่ไฟกระพริบและกดตู้นั้นเพื่อเปิด ขอบคุณที่ใช้บริการ';

  @override
  String get registerSuccess => 'สมัครสมาชิกเสร็จสิ้น';

  @override
  String get errorOccur => 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง';

  @override
  String get noLocker => 'ไม่มีล็อคเกอร์ที่ว่างอยู่';

  @override
  String get otpSuccess => 'ส่ง OTP เรียบร้อยแล้ว';

  @override
  String get otpWarning => 'กรุณากรอก OTP ให้ครบ 6 หลัก';

  @override
  String get wrongOtp => 'รหัส OTP ไม่ถูกต้อง กรุณาตรวจสอบแล้วลองใหม่อีกครั้ง';

  @override
  String get wrongEmail =>
      'อีเมลนี้ไม่ได้ลงทะเบียนไว้ กรุณาตรวจสอบแล้วลองใหม่อีกครั้ง';

  @override
  String get noAvailableLocker => 'ไม่มีตู้ว่าง กรุณาลองใหม่อีกครั้ง';

  @override
  String get loading => 'กำลังโหลดข้อมูลตู้...';

  @override
  String get wrongPhone =>
      'หมายเลขนี้ไม่ได้ลงทะเบียนไว้ กรุณาตรวจสอบแล้วลองใหม่อีกครั้ง';

  @override
  String get locker => 'ตู้';

  @override
  String get empty => 'ว่างอยู่';

  @override
  String get occupied => 'ไม่ว่าง';

  @override
  String get noAvailable =>
      'ไม่มีตู้ที่ใช้งานได้ในตอนนี้ (ตู้ทั้งหมดถูกเปิดอยู่หรือตู้ล็อคเกอร์ถูกปิดการใช้งาน)';

  @override
  String get cardReaderInstruct => 'หรือใช้ card reader';

  @override
  String get addMoreItem => 'เปิดตู้เพื่อใส่ของเพิ่ม';

  @override
  String get endOfUse => 'เปิดเพื่อจบการใช้งานตู้นี้ (คืนตู้)';

  @override
  String get whatWouldYouLikeToDo => 'คุณต้องการทำอะไรต่อไป?';

  @override
  String get registrationComplete => 'ลงทะเบียนสำเร็จ!';

  @override
  String get awaitingApproval => 'รอการตอบกลับจากผู้ดูแล';

  @override
  String get backToHome => 'กลับสู่หน้าหลัก';

  @override
  String get choosePreferredMethod => 'เลือกช่องทางที่ต้องการ';

  @override
  String get registerTitle => 'สมัครสมาชิก';

  @override
  String get registerSubtitle => 'กรอกข้อมูลเพื่อสมัครใช้งานตู้ประจำ';

  @override
  String get fullName => 'ชื่อ-นามสกุล';

  @override
  String get reason => 'เหตุผล';

  @override
  String get pleaseEnterName => 'กรุณากรอกชื่อ';

  @override
  String get pleaseEnterReason => 'กรุณากรอกเหตุผล';

  @override
  String get reasonForBooking => 'เหตุผลในการจอง';

  @override
  String get phoneNumber => 'เบอร์โทรศัพท์';

  @override
  String get submitRequest => 'ส่งคำร้อง';

  @override
  String get bookingTypeTitle => 'ประเภทการจอง\n(วันหรือชั่วโมง)';

  @override
  String get bookByDay => 'จองรายวัน';

  @override
  String get bookByHour => 'จองรายชั่วโมง';

  @override
  String get day => 'วัน';

  @override
  String get hour => 'ชั่วโมง';

  @override
  String get dayType => 'รายวัน';

  @override
  String get hourType => 'รายชั่วโมง';

  @override
  String get amount => 'จำนวน';

  @override
  String get priceDetails => 'รายละเอียดราคาและโปรโมชั่นต่าง ๆ';

  @override
  String get price => 'ราคา';

  @override
  String get baht => 'บาท';

  @override
  String get totalAmount => 'ยอดรวมทั้งหมด';

  @override
  String get promoCode => 'โค้ดโปรโมชั่น';

  @override
  String get enterPromoCode => 'กรอกโค้ดโปรโมชั่น';

  @override
  String get applyCode => 'ใช้โค้ด';

  @override
  String get invalidPromoCode => 'โค้ดโปรโมชั่นไม่ถูกต้อง';

  @override
  String get pleaseEnterPromoCode => 'โปรดกรอกโค้ดโปรโมชั่น';

  @override
  String get proceedBooking => 'ดำเนินการจอง';

  @override
  String get lockerOpenedSuccess => 'เปิดใช้ตู้สำเร็จ';

  @override
  String get pleaseSpecifyAmount => 'โปรดระบุจำนวน';

  @override
  String get discountCode => 'ส่วนลดโค้ด';

  @override
  String get promoApplied => 'ใช้โค้ดสำเร็จ!';

  @override
  String get availablePromotions => 'โปรโมชั่นที่มีอยู่';

  @override
  String get paymentSubtitle => 'ชำระเงินเพื่อจบขั้นตอนการจองล็อคเกอร์';

  @override
  String get paymentChannels => 'รายการช่องทางการชำระเงิน';

  @override
  String get scanToPayPromptPay => 'สแกนเพื่อชำระผ่านพร้อมเพย์';

  @override
  String get totalDuration => 'ระยะเวลาทั้งหมด';

  @override
  String get amountDue => 'จำนวนเงินที่ต้องชำระ';

  @override
  String get discountDetails => 'รายละเอียดส่วนลด';

  @override
  String get payNow => 'ชำระเงินเลย';

  @override
  String get qrPayment => 'ชำระผ่าน QR';

  @override
  String get qrPaymentSubtitle => 'รองรับแอปธนาคารชั้นนำ';

  @override
  String get creditCard => 'บัตรเครดิต / บัตรเดบิต';

  @override
  String get creditCardSubtitle => 'รับ Visa และ Mastercard';

  @override
  String get aliPaySubtitle => 'สแกนด้วยอาลีเพย์';

  @override
  String get linePaySubtitle => 'สแกนด้วย LINE Pay';

  @override
  String get supportedApps => 'แอปที่รองรับ';

  @override
  String get scanWithBankApp => 'สแกนด้วยแอปธนาคาร';

  @override
  String get overtimeWarning =>
      'ท่านได้ใช้งานเกินเวลาที่จองไว้\nกรุณาชำระเงินค่าปรับเพื่อเปิดตู้';

  @override
  String get overtimeExceeded => 'ใช้เวลาเกินที่จอง';

  @override
  String get overtimeFine => 'ค่าปรับที่ต้องชำระ';

  @override
  String get overtimePaymentTitle => 'เลือกวิธีชำระเงิน';

  @override
  String get autoOpenNote =>
      'หลังชำระเงินกรุณารอสักครู่ ระบบจะทำการเปิดตู้โดยอัตโนมัติ';

  @override
  String get dropBox => 'ฝากพัสดุ';

  @override
  String get appTitle => 'SMART LOCKER';

  @override
  String get scanQrTitle => 'สแกน QR เพื่อลงทะเบียน';

  @override
  String get scanQrSubtitle => 'ลงทะเบียนผ่านมือถือของคุณ\nโดยสแกน QR code นี้';

  @override
  String get tryAgain => 'ลองอีกครั้ง';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get back => 'ย้อนกลับ';

  @override
  String get sessionTimeoutTitle => 'หมดเวลาใช้งาน';

  @override
  String get sessionTimeoutMessage => 'ไม่มีการใช้งาน กำลังกลับสู่หน้าหลัก';

  @override
  String get deleteDigit => 'ลบตัวเลขล่าสุด';

  @override
  String get goBack => 'ย้อนกลับ';

  @override
  String get languageSwitch => 'เปลี่ยนภาษา';

  @override
  String get loadingGeneric => 'กำลังโหลด...';

  @override
  String get pleaseWait => 'กรุณารอสักครู่';

  @override
  String get errorEnterEmailOrPhone => 'กรุณากรอกเบอร์โทรศัพท์หรืออีเมล';

  @override
  String get errorInvalidEmailFormat => 'รูปแบบอีเมลไม่ถูกต้อง';

  @override
  String get errorPhoneMustBe10Digits => 'เบอร์โทรศัพท์ต้องเป็น 10 หลัก';

  @override
  String get errorEnterValidEmailOrPhone =>
      'กรุณากรอกอีเมลหรือเบอร์โทรศัพท์ที่ถูกต้อง';

  @override
  String get errorEnterOtp => 'กรุณากรอก OTP';

  @override
  String get errorOtpInvalid => 'กรุณากรอก OTP 6 หลักให้ถูกต้อง';

  @override
  String get errorEnterPhone => 'กรุณากรอกเบอร์โทรศัพท์';

  @override
  String get errorEnterEmail => 'กรุณากรอกอีเมล';

  @override
  String get errorInvalidEmail => 'รูปแบบอีเมลไม่ถูกต้อง';
}
