// lib/services/board_watcher/cu16c_protocol.dart
// CU16C v5.2 protocol helpers — frame building, parsing, and status query.
//
// Send frame (6 bytes):     02 ADDR LOCKNUM CMD 03 SUM
// Response frame (12 bytes): 02 ADDR LOCKNUM CMD D1 D2 D3 D4 D5 D6 03 SUM
// Status command: 0x70  |  Status response: 0x85

import 'hf_socket.dart';

// ---- Frame constants ----

const int _cmdStatus  = 0x70;
const int _respStatus = 0x85;
const int _cmdUnlock  = 0x71;
const int _cmdSetTime = 0x72;

// ---- Frame helpers (private — only used by queryStatus below) ----

int _sumLow(List<int> b) => b.fold(0, (s, x) => s + x) & 0xFF;

List<int> _buildFrame(int addr, int locknum, int cmd) {
  final body = [0x02, addr & 0xFF, locknum & 0xFF, cmd & 0xFF, 0x03];
  return body..add(_sumLow(body));
}

Map<int, int> _bits16(int lo, int hi) {
  final out = <int, int>{};
  for (var i = 0; i < 8; i++) {
    out[i + 1] = (lo >> i) & 1;
    out[i + 9] = (hi >> i) & 1;
  }
  return out;
}

// ---- Public helpers used by BoardWatcher ----

/// Formats a byte list as an uppercase hex string (e.g. "02 01 00 70 03 76").
String hexDump(List<int> b) => b
    .map((x) => x.toRadixString(16).padLeft(2, '0').toUpperCase())
    .join(' ');

/// Human-readable label for an IR sensor bit.
String labelIr(int v)   => v == 1 ? 'OCCUPIED' : 'EMPTY';

/// Human-readable label for a lock state bit.
String labelLock(int v) => v == 1 ? 'LOCKED'   : 'UNLOCKED';

/// Returns `[channel, prevValue, curValue]` for every channel that changed.
List<List<int>> diffChannels(Map<int, int> prev, Map<int, int> cur) {
  final changed = <List<int>>[];
  for (var ch = 1; ch <= 16; ch++) {
    final pv = prev[ch] ?? 0;
    final cv = cur[ch] ?? 0;
    if (pv != cv) changed.add([ch, pv, cv]);
  }
  return changed;
}

/// Sets push-to-unlock trigger time (0x72). seconds=0 = immediate, no push needed.
Future<void> sendTriggerTime(HfSocket sock, int cuAddr, int seconds) async {
  final frame = _buildFrame(cuAddr, seconds & 0xFF, _cmdSetTime);
  await sock.query(frame, 2.0); // wait briefly for ack, ignore result
}

/// Sends unlock command (0x71) for [ch] (1-based, CH1..CH16). No response expected.
Future<void> sendUnlock(HfSocket sock, int cuAddr, int ch) async {
  final locknum = (ch - 1) & 0xFF; // CH1=0x00, CH16=0x0F
  final frame = _buildFrame(cuAddr, locknum, _cmdUnlock);
  await sock.send(frame);
}

/// Sends a status command (0x70) to [cuAddr] and parses the 12-byte response.
/// Returns a map with keys `raw`, `lock` (Map<int,int>), `ir` (Map<int,int>),
/// or null if no valid response was received.
Future<Map<String, dynamic>?> queryStatus(
    HfSocket sock, int cuAddr, double sockTimeout) async {
  final raw = await sock.query(_buildFrame(cuAddr, 0x00, _cmdStatus), sockTimeout);
  if (raw == null || raw.length < 12) return null;

  for (var i = 0; i <= raw.length - 12; i++) {
    if (raw[i] == 0x02 && raw[i + 3] == _respStatus && raw[i + 1] == cuAddr) {
      final d1 = raw[i + 4], d2 = raw[i + 5];
      final d3 = raw[i + 6], d4 = raw[i + 7];
      return {
        'raw':  raw.sublist(i, i + 12),
        'lock': _bits16(d1, d2),
        'ir':   _bits16(d3, d4),
      };
    }
  }
  return null;
}
