import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  static final AppSettings instance = AppSettings._internal();
  AppSettings._internal();

  static const _keyAppTitle = 'app_title';
  static const _keyHomeTitle = 'home_title';
  static const _keyLogoAsset = 'logo_asset';
  static const _keyFooterLeft = 'footer_left';
  static const _keyContactInfo = 'contact_info';
  static const _keyapiBaseUrl = 'bootstrap_url';
  static const _keyHfConnections = 'hf_connections';
  static const _keyRestartHour = 'restart_hour';
  static const _keyPollSec = 'poll_sec';
  static const _keySockTimeout = 'sock_timeout';
  static const _keySettingsPassword = 'settings_password';
  static const _keyClientSecret    = 'client_secret';

  String _appTitle = 'SmartLocker';
  String _homeTitle = 'Smart Locker';
  String _logoAsset = 'assets/images/logo.png';
  String _footerLeft = '©LANNACOM 2026';
  String _contactInfo = 'ติดต่อกรณีมีปัญหา: 099-999-9999 | LINE: @lannacom';
  String _apiBaseUrl = '';
  String _hfConnections = '';
  int _restartHour = 0;
  double _pollSec = 0.3;
  double _sockTimeout = 2.0;
  String _clientSecret = '';
  // Stored as SHA-256 hex hash, never plaintext.
  String _settingsPasswordHash = _hashPassword('admin');

  String get appTitle => _appTitle;
  String get homeTitle => _homeTitle;
  String get logoAsset => _logoAsset;
  String get footerLeft => _footerLeft;
  String get contactInfo => _contactInfo;
  String get apiBaseUrl => _apiBaseUrl;
  String get hfConnections => _hfConnections;
  int get restartHour => _restartHour;
  double get pollSec => _pollSec;
  double get sockTimeout => _sockTimeout;
  String get clientSecret => _clientSecret;
  // Intentionally not exposing the raw password or hash.

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    _appTitle = prefs.getString(_keyAppTitle) ?? _appTitle;
    _homeTitle = prefs.getString(_keyHomeTitle) ?? _homeTitle;
    _logoAsset = prefs.getString(_keyLogoAsset) ?? _logoAsset;
    _footerLeft = prefs.getString(_keyFooterLeft) ?? _footerLeft;
    _contactInfo = prefs.getString(_keyContactInfo) ?? _contactInfo;
    _apiBaseUrl = prefs.getString(_keyapiBaseUrl) ?? _apiBaseUrl;
    _hfConnections = prefs.getString(_keyHfConnections) ?? _hfConnections;
    _restartHour = prefs.getInt(_keyRestartHour) ?? _restartHour;
    _pollSec = prefs.getDouble(_keyPollSec) ?? _pollSec;
    _sockTimeout = prefs.getDouble(_keySockTimeout) ?? _sockTimeout;
    _clientSecret = prefs.getString(_keyClientSecret) ?? _clientSecret;
    final stored = prefs.getString(_keySettingsPassword);
    if (stored != null) {
      // Migrate plaintext values written by older app versions.
      if (stored.length != 64 || !RegExp(r'^[0-9a-f]+$').hasMatch(stored)) {
        _settingsPasswordHash = _hashPassword(stored);
        await prefs.setString(_keySettingsPassword, _settingsPasswordHash);
      } else {
        _settingsPasswordHash = stored;
      }
    }
    notifyListeners();
  }

  Future<void> updateGeneral({
    required String appTitle,
    required String homeTitle,
    required String logoAsset,
    required String footerLeft,
    required String contactInfo,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    _appTitle = appTitle.trim().isEmpty ? 'SmartLocker' : appTitle.trim();
    _homeTitle = homeTitle.trim().isEmpty ? 'Smart Locker' : homeTitle.trim();
    _logoAsset = logoAsset.trim().isEmpty
        ? 'assets/images/logo.png'
        : logoAsset.trim();
    _footerLeft = footerLeft.trim().isEmpty
        ? '©LANNACOM 2026'
        : footerLeft.trim();
    _contactInfo = contactInfo.trim().isEmpty
        ? 'ติดต่อกรณีมีปัญหา: -'
        : contactInfo.trim();

    await prefs.setString(_keyAppTitle, _appTitle);
    await prefs.setString(_keyHomeTitle, _homeTitle);
    await prefs.setString(_keyLogoAsset, _logoAsset);
    await prefs.setString(_keyFooterLeft, _footerLeft);
    await prefs.setString(_keyContactInfo, _contactInfo);

    notifyListeners();
  }

  Future<void> updateSystem({
    required String apiBaseUrl,
    required String hfConnections,
    required int restartHour,
    required double pollSec,
    required double sockTimeout,
    String? clientSecret,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    _apiBaseUrl = apiBaseUrl.trim();
    _hfConnections = hfConnections.trim();
    _restartHour = restartHour;
    _pollSec = pollSec;
    _sockTimeout = sockTimeout;
    if (clientSecret != null) _clientSecret = clientSecret.trim();

    await prefs.setString(_keyapiBaseUrl, _apiBaseUrl);
    await prefs.setString(_keyHfConnections, _hfConnections);
    await prefs.setInt(_keyRestartHour, _restartHour);
    await prefs.setDouble(_keyPollSec, _pollSec);
    await prefs.setDouble(_keySockTimeout, _sockTimeout);
    await prefs.setString(_keyClientSecret, _clientSecret);

    notifyListeners();
  }

  Future<void> updateSettingsPassword(String value) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = value.trim().isEmpty ? 'admin' : value.trim();
    _settingsPasswordHash = _hashPassword(raw);
    await prefs.setString(_keySettingsPassword, _settingsPasswordHash);
    notifyListeners();
  }

  bool verifySettingsPassword(String value) {
    return _hashPassword(value) == _settingsPasswordHash;
  }

  static String _hashPassword(String password) =>
      sha256.convert(utf8.encode(password)).toString();
}
