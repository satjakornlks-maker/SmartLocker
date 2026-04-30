import 'package:flutter/material.dart';

/// Deterministic colour assignment for locker size keys.
///
/// Any size key (however named by the backend) is hashed to a stable index
/// into [_palette]. Adding new sizes in the backend automatically receives a
/// colour without any code change needed.
class SizeColor {
  SizeColor._();

  static const List<Color> _palette = [
    Color(0xFF00897B), // teal
    Color(0xFF8E24AA), // purple
    Color(0xFFEF6C00), // orange
    Color(0xFFE53935), // red
    Color(0xFF1E88E5), // blue
    Color(0xFF43A047), // green
    Color(0xFFD81B60), // pink
    Color(0xFF5E35B1), // deep purple
    Color(0xFF00ACC1), // cyan
    Color(0xFF6D4C41), // brown
    Color(0xFF7CB342), // light green
    Color(0xFFF4511E), // deep orange
  ];

  /// Returns a stable colour for [sizeKey].
  /// The same key always produces the same colour regardless of what other
  /// sizes exist, so adding new sizes never shifts existing ones.
  static Color forKey(String sizeKey) {
    final key = sizeKey.toLowerCase().trim();
    if (key.isEmpty) return const Color(0xFF78909C); // grey fallback
    return _palette[key.hashCode.abs() % _palette.length];
  }
}
