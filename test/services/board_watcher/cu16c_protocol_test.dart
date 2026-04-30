import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/services/board_watcher/cu16c_protocol.dart';

void main() {
  // ── hexDump ────────────────────────────────────────────────────────────────
  group('hexDump', () {
    test('formats single byte', () {
      expect(hexDump([0x02]), equals('02'));
    });

    test('formats full status frame bytes', () {
      expect(hexDump([0x02, 0x01, 0x00, 0x70, 0x03, 0x76]),
          equals('02 01 00 70 03 76'));
    });

    test('formats byte with value > 0x0F with no padding issues', () {
      expect(hexDump([0xFF, 0x10, 0x0A]), equals('FF 10 0A'));
    });

    test('empty list returns empty string', () {
      expect(hexDump([]), equals(''));
    });
  });

  // ── labelIr ───────────────────────────────────────────────────────────────
  group('labelIr', () {
    test('returns OCCUPIED for 1', () {
      expect(labelIr(1), equals('OCCUPIED'));
    });

    test('returns EMPTY for 0', () {
      expect(labelIr(0), equals('EMPTY'));
    });
  });

  // ── labelLock ─────────────────────────────────────────────────────────────
  group('labelLock', () {
    test('returns LOCKED for 1', () {
      expect(labelLock(1), equals('LOCKED'));
    });

    test('returns UNLOCKED for 0', () {
      expect(labelLock(0), equals('UNLOCKED'));
    });
  });

  // ── diffChannels ──────────────────────────────────────────────────────────
  group('diffChannels', () {
    test('returns empty list when maps are identical', () {
      final state = {for (var i = 1; i <= 16; i++) i: 0};
      expect(diffChannels(state, Map.from(state)), isEmpty);
    });

    test('detects single channel change', () {
      final prev = {for (var i = 1; i <= 16; i++) i: 0};
      final cur  = {for (var i = 1; i <= 16; i++) i: 0};
      cur[3] = 1;
      final result = diffChannels(prev, cur);
      expect(result.length, equals(1));
      expect(result.first, equals([3, 0, 1]));
    });

    test('detects multiple channel changes', () {
      final prev = {for (var i = 1; i <= 16; i++) i: 0};
      final cur  = {for (var i = 1; i <= 16; i++) i: 0};
      cur[1] = 1;
      cur[16] = 1;
      final result = diffChannels(prev, cur);
      expect(result.length, equals(2));
    });

    test('reports [channel, prevValue, curValue] correctly', () {
      final prev = {for (var i = 1; i <= 16; i++) i: 1};
      final cur  = {for (var i = 1; i <= 16; i++) i: 1};
      cur[5] = 0;
      final result = diffChannels(prev, cur);
      expect(result.first, equals([5, 1, 0]));
    });

    test('treats missing key as 0', () {
      final prev = <int, int>{};
      final cur  = {1: 1};
      // ch 1 missing in prev (treated as 0), set to 1 in cur — should detect change
      final result = diffChannels(prev, cur);
      expect(result.any((r) => r[0] == 1 && r[1] == 0 && r[2] == 1), isTrue);
    });

    test('all 16 channels changed', () {
      final prev = {for (var i = 1; i <= 16; i++) i: 0};
      final cur  = {for (var i = 1; i <= 16; i++) i: 1};
      expect(diffChannels(prev, cur).length, equals(16));
    });
  });
}
