import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

/// Reads config.json from the same directory as the executable.
/// Only BOOTSTRAP_URL should be placed here — never sensitive keys like APP_KEY.
/// Returns an empty map if the file doesn't exist or can't be parsed.
Future<Map<String, dynamic>> readConfigFile() async {
  try {
    final exeDir = path.dirname(Platform.resolvedExecutable);
    final file = File(path.join(exeDir, 'config.json'));
    if (!await file.exists()) return {};
    final json = jsonDecode(await file.readAsString());
    if (json is Map<String, dynamic>) return json;
  } catch (_) {}
  return {};
}
