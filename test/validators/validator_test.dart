import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/validators/validator.dart';

void main() {
  // ── validateEmailOrPhone ───────────────────────────────────────────────────
  group('Validators.validateEmailOrPhone', () {
    test('returns error on null', () {
      expect(Validators.validateEmailOrPhone(null), isNotNull);
    });

    test('returns error on empty string', () {
      expect(Validators.validateEmailOrPhone(''), isNotNull);
    });

    // Phone
    test('accepts valid 10-digit phone starting with 0', () {
      expect(Validators.validateEmailOrPhone('0812345678'), isNull);
    });

    test('accepts phone with spaces/dashes (cleaned)', () {
      expect(Validators.validateEmailOrPhone('081-234-5678'), isNull);
    });

    test('rejects phone shorter than 10 digits', () {
      expect(Validators.validateEmailOrPhone('081234567'), isNotNull);
    });

    test('rejects phone longer than 10 digits', () {
      expect(Validators.validateEmailOrPhone('08123456789'), isNotNull);
    });

    test('rejects phone not starting with 0', () {
      expect(Validators.validateEmailOrPhone('1234567890'), isNotNull);
    });

    // Email
    test('accepts valid email', () {
      expect(Validators.validateEmailOrPhone('user@example.com'), isNull);
    });

    test('accepts email with subdomain', () {
      expect(Validators.validateEmailOrPhone('user@mail.example.com'), isNull);
    });

    test('rejects email without @', () {
      expect(Validators.validateEmailOrPhone('userexample.com'), isNotNull);
    });

    test('rejects email without domain', () {
      expect(Validators.validateEmailOrPhone('user@'), isNotNull);
    });

    test('rejects email without local part', () {
      expect(Validators.validateEmailOrPhone('@example.com'), isNotNull);
    });
  });

  // ── validateOTP ───────────────────────────────────────────────────────────
  group('Validators.validateOTP', () {
    test('returns error on null', () {
      expect(Validators.validateOTP(null), isNotNull);
    });

    test('returns error on empty string', () {
      expect(Validators.validateOTP(''), isNotNull);
    });

    test('accepts exactly 6-character OTP', () {
      expect(Validators.validateOTP('123456'), isNull);
    });

    test('rejects OTP shorter than 6', () {
      expect(Validators.validateOTP('12345'), isNotNull);
    });

    test('rejects OTP longer than 6', () {
      expect(Validators.validateOTP('1234567'), isNotNull);
    });
  });

  // ── validateTel ───────────────────────────────────────────────────────────
  group('Validators.validateTel', () {
    test('returns error on null', () {
      expect(Validators.validateTel(null), isNotNull);
    });

    test('returns error on empty string', () {
      expect(Validators.validateTel(''), isNotNull);
    });

    test('accepts valid 10-digit phone', () {
      expect(Validators.validateTel('0812345678'), isNull);
    });

    test('accepts phone with leading/trailing spaces', () {
      expect(Validators.validateTel(' 0812345678 '), isNull);
    });

    test('rejects 9-digit phone', () {
      expect(Validators.validateTel('081234567'), isNotNull);
    });

    test('rejects phone not starting with 0', () {
      expect(Validators.validateTel('9812345678'), isNotNull);
    });
  });

  // ── validateEmail ─────────────────────────────────────────────────────────
  group('Validators.validateEmail', () {
    test('returns error on null', () {
      expect(Validators.validateEmail(null), isNotNull);
    });

    test('returns error on empty string', () {
      expect(Validators.validateEmail(''), isNotNull);
    });

    test('accepts valid email', () {
      expect(Validators.validateEmail('test@example.com'), isNull);
    });

    test('accepts email with spaces (cleaned)', () {
      expect(Validators.validateEmail(' test@example.com '), isNull);
    });

    test('rejects email without @', () {
      expect(Validators.validateEmail('testexample.com'), isNotNull);
    });

    test('rejects email with only @', () {
      expect(Validators.validateEmail('@'), isNotNull);
    });
  });
}
