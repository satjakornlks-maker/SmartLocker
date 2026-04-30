// lib/services/board_watcher/hf_connection.dart
// HF converter connection descriptor + CU address parser.

/// Describes one HF converter TCP endpoint and the CU addresses behind it.
class HFConnection {
  final String ip;
  final int port;
  final List<int> cuAddresses;
  const HFConnection(this.ip, this.port, this.cuAddresses);

  @override
  String toString() {
    final cus = cuAddresses
        .map((a) => '0x${a.toRadixString(16).padLeft(2, '0').toUpperCase()}')
        .join(',');
    return '$ip:$port -> [$cus]';
  }
}

/// Parses a comma-separated list of CU addresses.
/// Accepts hex ("0x01") or decimal ("1") notation.
/// Defaults to [0x01] if the string is empty.
List<int> parseCuAddresses(String s) {
  if (s.trim().isEmpty) return [0x01];
  return s.split(',').map((p) {
    p = p.trim();
    return (p.startsWith('0x') || p.startsWith('0X'))
        ? int.parse(p.substring(2), radix: 16)
        : int.parse(p);
  }).toList();
}
