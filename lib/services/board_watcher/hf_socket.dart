// lib/services/board_watcher/hf_socket.dart
// TCP socket wrapper for HF converter communication.
//
// Sends one CU16C frame and collects the response using a Completer signal.
// Queries must be sequential within a single watcher loop (no concurrent use).

import 'dart:async';
import 'dart:io';

class HfSocket {
  final Socket _socket;
  final _buf = <int>[];
  Completer<void>? _signal;
  late StreamSubscription<dynamic> _sub;
  bool _closed = false;

  HfSocket._(this._socket) {
    _sub = _socket.listen(
      (data) {
        _buf.addAll(data as List<int>);
        _signal?.complete();
        _signal = null;
      },
      onDone:  () { _closed = true; _signal?.complete(); _signal = null; },
      onError: (_) { _closed = true; _signal?.complete(); _signal = null; },
    );
  }

  static Future<HfSocket?> connect(String host, int port,
      {Duration timeout = const Duration(seconds: 5)}) async {
    try {
      final s = await Socket.connect(host, port, timeout: timeout);
      return HfSocket._(s);
    } catch (_) {
      return null;
    }
  }

  /// Sends [frame] and collects response bytes.
  /// Waits up to [sockTimeoutSec] for the first byte, then 250 ms idle.
  Future<List<int>?> query(List<int> frame, double sockTimeoutSec) async {
    if (_closed) return null;
    _buf.clear();

    // Set signal BEFORE sending to avoid missing a fast response.
    _signal = Completer();
    _socket.add(frame);

    final to = Duration(milliseconds: (sockTimeoutSec * 1000).toInt());
    final got = await _signal!.future
        .then((_) => true)
        .timeout(to, onTimeout: () => false);
    if (!got || _buf.isEmpty) return null;

    // Drain until 250 ms of silence.
    while (!_closed) {
      _signal = Completer();
      final more = await _signal!.future
          .then((_) => true)
          .timeout(const Duration(milliseconds: 250), onTimeout: () => false);
      if (!more) break;
    }
    return List<int>.from(_buf);
  }

  /// Sends [frame] without waiting for a response (fire-and-forget).
  Future<void> send(List<int> frame) async {
    if (_closed) return;
    _socket.add(frame);
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await _sub.cancel();
    _socket.destroy();
  }
}
