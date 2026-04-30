import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/services/board_watcher/hf_connection.dart';

void main() {
  // ── parseCuAddresses ──────────────────────────────────────────────────────
  group('parseCuAddresses', () {
    test('empty string defaults to [0x01]', () {
      expect(parseCuAddresses(''), equals([0x01]));
    });

    test('whitespace-only string defaults to [0x01]', () {
      expect(parseCuAddresses('   '), equals([0x01]));
    });

    test('parses single hex address', () {
      expect(parseCuAddresses('0x01'), equals([1]));
    });

    test('parses multiple hex addresses', () {
      expect(parseCuAddresses('0x01,0x02'), equals([1, 2]));
    });

    test('parses uppercase hex prefix 0X', () {
      expect(parseCuAddresses('0X0A'), equals([10]));
    });

    test('parses decimal address', () {
      expect(parseCuAddresses('1'), equals([1]));
    });

    test('parses mixed hex and decimal', () {
      expect(parseCuAddresses('0x01,2'), equals([1, 2]));
    });

    test('handles spaces around addresses', () {
      expect(parseCuAddresses(' 0x01 , 0x02 '), equals([1, 2]));
    });

    test('parses larger hex address', () {
      expect(parseCuAddresses('0xFF'), equals([255]));
    });
  });

  // ── HFConnection ──────────────────────────────────────────────────────────
  group('HFConnection', () {
    test('stores ip, port, cuAddresses', () {
      final conn = HFConnection('192.168.1.10', 8899, [0x01, 0x02]);
      expect(conn.ip, equals('192.168.1.10'));
      expect(conn.port, equals(8899));
      expect(conn.cuAddresses, equals([0x01, 0x02]));
    });

    test('toString formats correctly with single CU', () {
      final conn = HFConnection('192.168.22.40', 8899, [0x01]);
      expect(conn.toString(), equals('192.168.22.40:8899 -> [0x01]'));
    });

    test('toString formats correctly with multiple CUs', () {
      final conn = HFConnection('192.168.22.40', 8899, [0x01, 0x02]);
      expect(conn.toString(), equals('192.168.22.40:8899 -> [0x01,0x02]'));
    });

    test('toString zero-pads single hex digit CU addresses', () {
      final conn = HFConnection('10.0.0.1', 9000, [0x0A]);
      expect(conn.toString(), contains('0x0A'));
    });

    test('toString formats high address correctly', () {
      final conn = HFConnection('10.0.0.1', 9000, [0xFF]);
      expect(conn.toString(), contains('0xFF')); // format is 0x + uppercase hex digits
    });
  });
}
