import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:untitled/screens/chose_time_page/chose_time_page.dart';
import 'package:untitled/screens/otp_page/otp_page.dart';
import 'package:untitled/screens/overtime_page/overtime_page.dart';
import 'package:untitled/screens/payment_page/payment_page.dart';
import 'utils/platform_check.dart';
import 'package:flutter/foundation.dart';
import 'package:untitled/screens/confirmation_page/confirmation_page.dart';
import 'package:untitled/screens/locker_page/locker_selection_page.dart';
import 'package:untitled/screens/user_type_page/user_type_page.dart';
import 'package:untitled/screens/home_page/my_home_page.dart';
import 'package:untitled/screens/input_type_page/input_type_page/input_type_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:window_manager/window_manager.dart';
import 'package:untitled/services/device_config_service.dart';
import 'package:untitled/services/api_service.dart';
import 'utils/config_file_reader.dart';

Process? _pythonProcess;
bool _pythonKilledByUs = false;

Future<void> _launchPythonWatcher() async {
  // Look for board_check.py next to the exe (production) then in cwd (development)
  final exeDir = File(Platform.resolvedExecutable).parent.path;
  String? scriptPath;
  for (final dir in [exeDir, Directory.current.path]) {
    final f = File('$dir/board_check.py');
    if (f.existsSync()) {
      scriptPath = f.path;
      break;
    }
  }
  if (scriptPath == null) {
    debugPrint('[PythonWatcher] board_check.py not found — skipping');
    return;
  }

  try {
    _pythonProcess = await Process.start(
      'python',
      [scriptPath, '--parent-pid', pid.toString()],
      workingDirectory: File(scriptPath).parent.path,
    );
    _pythonProcess!.stdout.transform(utf8.decoder).listen((s) => debugPrint('[py] $s'));
    _pythonProcess!.stderr.transform(utf8.decoder).listen((s) => debugPrint('[py:err] $s'));
    _pythonProcess!.exitCode.then((code) {
      if (!_pythonKilledByUs && code != 0) {
        // code 0 = intentional exit (e.g. daily restart via os.execv on Windows)
        // non-zero = crash — bring Flutter down too
        debugPrint('[PythonWatcher] Crashed (code $code) — shutting down app');
        exit(1);
      }
    });
    debugPrint('[PythonWatcher] Started board_check.py (PID: ${_pythonProcess!.pid})');
  } catch (e) {
    debugPrint('[PythonWatcher] Failed to start board_check.py: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- Device config init ---
  // APP_KEY is sensitive — always from compile-time --dart-define only (baked into binary).
  // BOOTSTRAP_URL is not sensitive — can be overridden per-machine via config.json next to exe.
  const defaultBootstrapUrl = String.fromEnvironment(
    'BOOTSTRAP_URL',
    defaultValue: 'http://10.3.0.4:8098',
  );
  const appKey = String.fromEnvironment(
    'APP_KEY',
    defaultValue: 'tz+6qg0XHbu2LUm4ni3ukmmTQqep/RxX/akO8PRMBCo=',
  );

  final fileConfig = await readConfigFile();
  final bootstrapUrl = (fileConfig['BOOTSTRAP_URL'] as String?)?.isNotEmpty == true
      ? fileConfig['BOOTSTRAP_URL'] as String
      : defaultBootstrapUrl;

  // Always init so baseUrl and appKey are set on every platform (including web).
  await DeviceConfigService.init(bootstrapUrl: bootstrapUrl, appKey: appKey);

  if (!kIsWeb) {
    // Sync device config with backend (register on first run, fetch config on subsequent runs).
    // If network is unavailable, cached values from SharedPreferences are used silently.
    try {
      final apiService = ApiService();
      final result = await apiService.syncDeviceConfig(DeviceConfigService.deviceId);

      if (result['success'] == true) {
        final data = result['data'] as Map<String, dynamic>;
        final newBaseUrl = data['base_url'] as String?;
        final rawIds = data['locker_ids'] as List?;
        final lockerIds = rawIds?.map((e) => e as int).toList();

        await DeviceConfigService.updateFromServer(
          baseUrl: newBaseUrl,
          lockerIds: lockerIds,
        );
      }
    } catch (_) {
      // Network unavailable — app continues with cached config
    }
  }
  // --- End device config init ---

  if (!kIsWeb && isDesktop) {
    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      fullScreen: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });

    // await _launchPythonWatcher(); // TODO: re-enable when board_check.py is ready
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Locale _locale = const Locale('th');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached && _pythonProcess != null) {
      _pythonKilledByUs = true;
      _pythonProcess!.kill();
    }
  }

  void toggleLocale() {
    setState(() {
      _locale = _locale.languageCode == 'th'
          ? const Locale('en')
          : const Locale('th');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      title: 'SmartLocker',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('th'),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Prompt',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Smart Locker'),
        '/unlock': (context) => const LockerSelectionPage(mode: LockerSelectionMode.unlock),
        '/user-type-page': (context) => const UserTypePage(),
        '/otp-unlock-page': (context) => const OTPPage(from: FromPage.unlock),
        '/test-page': (context) => const PaymentPage(lockerId: "", lockerName: "", telOrEmail: "", otp: "", userId: 1, bookingType: "bookingType", quantity: 1, total: 1),
      },
    );
  }
}