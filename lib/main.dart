import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:window_manager/window_manager.dart';

import 'l10n/app_localizations.dart';
import 'package:untitled/screens/home_page/my_home_page.dart';
import 'package:untitled/screens/input_type_page/input_type_page/input_type_page.dart';
import 'package:untitled/screens/locker_page/locker_selection_page.dart';
import 'package:untitled/screens/otp_page/otp_page.dart';
import 'package:untitled/screens/payment_page/payment_page.dart';
import 'package:untitled/screens/settings_page/settings_page.dart';
import 'package:untitled/screens/user_type_page/user_type_page.dart';
import 'package:untitled/services/api_service.dart';
import 'package:untitled/services/app_settings.dart';
import 'package:untitled/services/board_watcher/board_watcher.dart';
import 'package:untitled/services/device_config_service.dart';
import 'package:untitled/services/device_heartbeat_service.dart';
import 'package:untitled/services/offline_status_queue.dart';
import 'package:untitled/services/pin_cache_service.dart';
import 'utils/config_file_reader.dart';
import 'utils/platform_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // โหลด settings จากเครื่องก่อน
  await AppSettings.instance.load();

  // --- Device config init ---
  // APP_KEY is baked in at build time via --dart-define
  const appKey = String.fromEnvironment('APP_KEY', defaultValue: '');
  const envBootstrapUrl = String.fromEnvironment(
    'BOOTSTRAP_URL',
    defaultValue: 'http://10.3.0.4:5183',
  );

  final fileConfig = await readConfigFile();

  final rawBootstrapFromFile = ((fileConfig['BOOTSTRAP_URL'] as String?) ?? '')
      .trim();

  final bootstrapUrl = AppSettings.instance.bootstrapUrl.isNotEmpty
      ? AppSettings.instance.bootstrapUrl
      : (rawBootstrapFromFile.isNotEmpty
            ? rawBootstrapFromFile
            : envBootstrapUrl);

  // Always init so baseUrl and appKey are set on every platform (including web).
  await DeviceConfigService.init(configUrl: bootstrapUrl, appKey: appKey);

  if (!kIsWeb) {
    // Load cached values first so the app starts immediately without waiting for network.
    await PinCacheService.load();
    await OfflineStatusQueue.load();

    // Fire-and-forget: sync device config in background.
    final prevAssignedLocker = DeviceConfigService.assignedLocker;
    final prevLockerIds = List<int>.from(DeviceConfigService.lockerIds);

    ApiService()
        .syncDeviceConfig(DeviceConfigService.deviceId)
        .then((result) async {
          print('[syncDeviceConfig] result: $result');

          if (result['success'] == true) {
            final data = result['data'] as Map<String, dynamic>;
            final rawIds = data['locker_ids'] as List?;
            final lockerIds = rawIds?.map((e) => e as int).toList();
            final assignedLocker =
                (data['AssignedLocker'] ?? data['assigned_locker']) as int?;
            final systemMode = data['system_mode'] as String?;

            print(
              '[syncDeviceConfig] assigned_locker=$assignedLocker, locker_ids=$lockerIds, system_mode=$systemMode',
            );

            await DeviceConfigService.updateFromServer(
              lockerIds: lockerIds,
              assignedLocker: assignedLocker,
              systemMode: systemMode,
            );

            final assignedChanged =
                DeviceConfigService.assignedLocker != prevAssignedLocker;
            final idsChanged = !_listEquals(
              DeviceConfigService.lockerIds,
              prevLockerIds,
            );

            if (assignedChanged || idsChanged) {
              print('[syncDeviceConfig] config changed — reloading home');
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                '/',
                (route) => false,
              );
            }
          }
        })
        .catchError((e) {
          print('[syncDeviceConfig] failed: $e');
        });

    ApiService().syncPinCache().ignore();
    ApiService().getLocker().ignore();
    ApiService().flushOfflineQueue().ignore();
  }
  // --- End device config init ---

  if (!kIsWeb && isDesktop) {
    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setFullScreen(true);
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // Start heartbeat + board watcher on Windows (desktop) and Android only.
  if (!kIsWeb && (isDesktop || Platform.isAndroid)) {
    Future.delayed(const Duration(seconds: 5), () {
      // Flush queued offline status updates every 60 s while app is running.
      Timer.periodic(const Duration(seconds: 60), (_) {
        if (OfflineStatusQueue.pendingCount > 0) {
          ApiService().flushOfflineQueue().ignore();
        }
      });

      // Start HTTP health ping — tells the backend this device is alive every 10 min.
      DeviceHeartbeatService.connect(
        DeviceConfigService.baseUrl,
        DeviceConfigService.deviceId,
      ).ignore();

      // registerOnly() resolves HF connections + locker data so that offline
      // unlock works, but does NOT start polling loops.
      BoardWatcher(
        apiBaseUrl: DeviceConfigService.baseUrl,
        apiKey: DeviceConfigService.appKey,
        assignedLocker: DeviceConfigService.assignedLocker,
        pollSec: AppSettings.instance.pollSec,
        sockTimeout: AppSettings.instance.sockTimeout,
        restartHour: AppSettings.instance.restartHour,
        hfConnectionsOverride: AppSettings.instance.hfConnections.isNotEmpty
            ? AppSettings.instance.hfConnections
            : ((fileConfig['HF_CONNECTIONS'] as String?) ?? ''),
      ).registerOnly().ignore();
    });
  }

  runApp(const MyApp());
}

/// Graceful shutdown: stops the board watcher, notifies the backend, then
/// destroys the window. Used both by onWindowClose and the daily restart timer.
Future<void> _handleShutdown() async {
  try {
    final result = await ApiService().setDeviceOffline(
      DeviceConfigService.deviceId,
    );
    print('[shutdown] setDeviceOffline: $result');
  } catch (e) {
    print('[shutdown] setDeviceOffline error: $e');
  }

  await DeviceHeartbeatService.disconnect();

  if (!kIsWeb && isDesktop) {
    await windowManager.destroy();
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp>
    with WidgetsBindingObserver, WindowListener {
  Locale _locale = const Locale('th');

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    AppSettings.instance.addListener(_onSettingsChanged);

    if (!kIsWeb && isDesktop) {
      windowManager.addListener(this);
      windowManager.setPreventClose(true);
    }
  }

  void _onSettingsChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AppSettings.instance.removeListener(_onSettingsChanged);

    if (!kIsWeb && isDesktop) {
      windowManager.removeListener(this);
    }

    super.dispose();
  }

  @override
  Future<void> onWindowClose() => _handleShutdown();

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
      navigatorKey: navigatorKey,
      locale: _locale,
      title: AppSettings.instance.appTitle,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('th')],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Prompt',
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'Prompt',
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(
          title: AppSettings.instance.homeTitle,
          logoAsset: AppSettings.instance.logoAsset,
        ),
        '/unlock': (context) =>
            const LockerSelectionPage(mode: LockerSelectionMode.unlock),
        '/user-type-page': (context) => const UserTypePage(),
        '/otp-unlock-page': (context) => const OTPPage(from: FromPage.unlock),
        '/test-page': (context) => const PaymentPage(
          lockerId: "",
          lockerName: "",
          telOrEmail: "",
          otp: "",
          userId: 1,
          bookingType: "bookingType",
          quantity: 1,
          total: 1,
        ),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}

bool _listEquals(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
