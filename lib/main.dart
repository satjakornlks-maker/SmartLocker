import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:untitled/screens/otp_page/otp_page.dart';
import 'package:untitled/screens/payment_page/payment_page.dart';
import 'utils/platform_check.dart';
import 'package:flutter/foundation.dart';
import 'package:untitled/screens/locker_page/locker_selection_page.dart';
import 'package:untitled/screens/user_type_page/user_type_page.dart';
import 'package:untitled/screens/home_page/my_home_page.dart';
import 'package:untitled/screens/input_type_page/input_type_page/input_type_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:window_manager/window_manager.dart';
import 'package:untitled/services/device_config_service.dart';
import 'package:untitled/services/api_service.dart';
import 'package:untitled/services/board_watcher/board_watcher.dart';
import 'package:untitled/services/device_heartbeat_service.dart';
import 'package:untitled/services/pin_cache_service.dart';
import 'package:untitled/services/offline_status_queue.dart';
import 'utils/config_file_reader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- Device config init ---
  // APP_KEY is baked in at build time via --dart-define (extracted from config.prod.json by build.bat).
  // BOOTSTRAP_URL can be overridden at runtime via config.json next to the exe.
  const appKey = String.fromEnvironment('APP_KEY', defaultValue: '');
  const defaultBootstrapUrl = String.fromEnvironment(
    'BOOTSTRAP_URL',
    defaultValue: 'http://10.3.0.4:5183',
  );

  final fileConfig = await readConfigFile();
  final rawBootstrap = ((fileConfig['BOOTSTRAP_URL'] as String?) ?? '').trim();
  final bootstrapUrl = rawBootstrap.isNotEmpty ? rawBootstrap : defaultBootstrapUrl;

  // Always init so baseUrl and appKey are set on every platform (including web).
  await DeviceConfigService.init(configUrl: bootstrapUrl, appKey: appKey);

  if (!kIsWeb) {
    // Load cached values first so the app starts immediately without waiting for network.
    await PinCacheService.load();
    await OfflineStatusQueue.load();

    // Fire-and-forget: sync device config in background.
    // Admin assigns lockers from the admin panel — device picks up the update here.
    // If the assigned locker changed, navigate to home so the UI reflects the new assignment.
    final prevAssignedLocker = DeviceConfigService.assignedLocker;
    final prevLockerIds = List<int>.from(DeviceConfigService.lockerIds);
    ApiService().syncDeviceConfig(DeviceConfigService.deviceId).then((result) async {
      print('[syncDeviceConfig] result: $result');
      if (result['success'] == true) {
        final data = result['data'] as Map<String, dynamic>;
        final rawIds = data['locker_ids'] as List?;
        final lockerIds = rawIds?.map((e) => e as int).toList();
        final assignedLocker = (data['AssignedLocker'] ?? data['assigned_locker']) as int?;
        final systemMode = data['system_mode'] as String?;
        print('[syncDeviceConfig] assigned_locker=$assignedLocker, locker_ids=$lockerIds, system_mode=$systemMode');
        await DeviceConfigService.updateFromServer(
          lockerIds: lockerIds,
          assignedLocker: assignedLocker,
          systemMode: systemMode,
        );
        // If the assignment changed, reload home so the UI reflects the new locker
        final assignedChanged = DeviceConfigService.assignedLocker != prevAssignedLocker;
        final idsChanged = !_listEquals(DeviceConfigService.lockerIds, prevLockerIds);
        if (assignedChanged || idsChanged) {
          print('[syncDeviceConfig] config changed — reloading home');
          navigatorKey.currentState?.pushNamedAndRemoveUntil('/', (route) => false);
        }
      }
    }).catchError((e) {
      print('[syncDeviceConfig] failed: $e');
    });

    ApiService().syncPinCache().ignore();        // non-blocking — uses cache if offline
    ApiService().getLocker().ignore();           // pre-populate locker cache for offline use
    ApiService().flushOfflineQueue().ignore();   // send any queued status updates
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
    // Delay start so the UI renders first, then board watcher kicks in background.
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
      // unlock (LockerCommandService) works, but does NOT start polling loops.
      BoardWatcher(
        apiBaseUrl:             DeviceConfigService.baseUrl,
        apiKey:                 DeviceConfigService.appKey,
        assignedLocker:         DeviceConfigService.assignedLocker,
        pollSec:                0.3,
        sockTimeout:            2.0,
        restartHour:            0,
        hfConnectionsOverride:  fileConfig['HF_CONNECTIONS'] as String? ?? '',
      ).registerOnly().ignore();
    });
  }

  runApp(const MyApp());
}

/// Graceful shutdown: stops the board watcher, notifies the backend, then
/// destroys the window. Used both by onWindowClose and the daily restart timer.
Future<void> _handleShutdown() async {
  // Explicit HTTP call — reliable for graceful shutdown.
  // WebSocket disconnect handles crashes/power cuts passively once backend WS endpoint is ready.
  try {
    final result = await ApiService().setDeviceOffline(DeviceConfigService.deviceId);
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

class _MyAppState extends State<MyApp> with WidgetsBindingObserver, WindowListener {
  Locale _locale = const Locale('th');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (!kIsWeb && isDesktop) {
      windowManager.addListener(this);
      windowManager.setPreventClose(true);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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

bool _listEquals(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}