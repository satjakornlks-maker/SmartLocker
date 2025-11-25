class Validators {
  static String? validateEmailOrPhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอก เบอร์โทรศัพท์หรืออีเมล';
    }

    String cleanValue = value.trim().replaceAll(' ', '').replaceAll('-', '');

    if (cleanValue.contains('@')) {
      final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(cleanValue)) {
        return 'รูปแบบอีเมลไม่ถูกต้อง';
      }
    } else if (cleanValue.startsWith('0')) {
      final phoneRegex = RegExp(r'^0[0-9]{9}$');
      if (!phoneRegex.hasMatch(cleanValue)) {
        return 'เบอร์โทรศัพท์ต้องเป็น 10 หลัก';
      }
    } else {
      return 'กรุณากรอกอีเมลหรือเบอร์โทรศัพท์ที่ถูกต้อง';
    }

    return null;
  }

  static String? validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอก OTP';
    }

    if (value.length != 6) {
      return 'กรุณากรอก OTP ให้ถูกต้อง';
    }

    return null;
  }

  static String? validateTel(String? value){
    if(value == null || value.isEmpty){
      return 'กรุณากรอกเบอร์โทรศัพท์';
    }
    String cleanValue = value.trim().replaceAll(' ', '');
    final phoneRegex = RegExp(r'^0[0-9]{9}$');

    if(!phoneRegex.hasMatch(cleanValue)){
      return 'เบอร์โทรศัพท์ต้องเป็น 10 หลัก';
    }

    return null;

  }

  static String? validateEmail(String? value){
    if(value == null || value.isEmpty){
      return 'กรุณากรอก Email';
    }
    String cleanValue = value.trim().replaceAll(' ', '');
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

    if(!emailRegex.hasMatch(cleanValue)){
      return 'รูปแบบ email ไม่ถูกต้อง';
    }
    return null;
  }
}