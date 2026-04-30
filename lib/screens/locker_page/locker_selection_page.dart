import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/screens/locker_page/locker_component/locker_responsive_body.dart';
import 'package:untitled/theme/theme.dart';
import 'package:untitled/widgets/snackbar/snackbar.dart';
import '../../services/api_service.dart';
import '../../services/device_config_service.dart';
import 'locker_component/locker_grid.dart';
import 'locker_function/locker_service.dart';

enum LockerSelectionMode { booking, memberSelect, unlock }

class LockerSelectionPage extends StatefulWidget {
  final LockerSelectionMode mode;
  final String? size;
  const LockerSelectionPage({super.key, required this.mode, this.size});

  @override
  State<LockerSelectionPage> createState() => _LockerSelectionPageState();
}

class _LockerSelectionPageState extends State<LockerSelectionPage> {
  bool _isLoading = true;
  String? selectedLocker;
  String? selectedLockerName;
  final ApiService _apiService = ApiService.instance;
  List<Map<String, dynamic>> lockerStatus = [];
  bool _showGrid = false;
  String get systemMode => DeviceConfigService.systemMode;
  late final LockerService _lockerService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _lockerService = LockerService(_apiService);
      _loadLocker();
      Future.delayed(const Duration(microseconds: 50), () {
        if (mounted) setState(() => _showGrid = true);
      });
    });
  }

  // Get book type based on mode
  int? get _bookTypeFilter {
    switch (widget.mode) {
      case LockerSelectionMode.booking:
        return 1; // Filter for booking type
      case LockerSelectionMode.memberSelect:
        return 3; // Filter for member type
      case LockerSelectionMode.unlock:
        return null; // No filter for unlock, show all
    }
  }

  Future<void> _loadLocker() async {
    setState(() => _isLoading = true);

    final result = await _lockerService.loadLocker(
      bookTypeFilter: _bookTypeFilter,
      sizeFilter: widget.size,
      systemMode: systemMode,
    );

    if (!mounted) return;

    if (result.isEmpty) {
      context.showErrorSnackBar(AppLocalizations.of(context)!.noAvailable);
      Navigator.pop(context);
      return;
    }

    if (!result.isSuccess) {
      setState(() => _isLoading = false);
      context.showErrorSnackBar(AppLocalizations.of(context)!.errorOccur);
      return;
    }

    setState(() {
      lockerStatus = result.data!;
      _isLoading = false;
    });
  }
  String get _buttonText {
    switch (widget.mode) {
      case LockerSelectionMode.booking:
        return AppLocalizations.of(context)!.confirm;
      case LockerSelectionMode.memberSelect:
        return AppLocalizations.of(context)!.proceed;
      case LockerSelectionMode.unlock:
        return AppLocalizations.of(context)!.unlock;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
            : _showGrid
                ? LockerResponsiveBody(
                    mode: widget.mode,
                    selectedLocker: selectedLocker,
                    selectedLockerName: selectedLockerName,
                    buttonText: Text(
                      selectedLockerName != null
                          ? '$_buttonText #$selectedLockerName'
                          : _buttonText,
                      style: const TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    gridBuilder: _buildResponsiveLockerGrid,
                    lockerData: lockerStatus,
                  )
                : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildResponsiveLockerGrid(
      double availableWidth,
      double availableHeight,
      ) {
    final groupedLockers = _groupLockersByLockerId();

    // ✅ Use the new LockerGrid widget
    return LockerGrid(
      groupedLockers: groupedLockers,
      availableWidth: availableWidth,
      availableHeight: availableHeight,
      mode: widget.mode,
      selectedLocker: selectedLocker,
      onTap: _onLockerTap,
    );
  }

  Map<int, List<Map<String, dynamic>>> _groupLockersByLockerId() {
    final Map<int, List<Map<String, dynamic>>> grouped = {};

    for (var unit in lockerStatus) {
      final lockerId = unit['lockerId'] as int? ?? 0;
      grouped.putIfAbsent(lockerId, () => []);
      grouped[lockerId]!.add(unit);
    }

    return grouped;
  }

  void _onLockerTap(String lockerId, bool isAvailable, String lockerName) {
    ScaffoldMessenger.of(context).clearSnackBars();

    if (widget.mode == LockerSelectionMode.unlock) {
      // Unlock mode: select occupied lockers
      if (isAvailable) {
        setState(() {
          selectedLocker = lockerId;
          selectedLockerName = lockerName;
        });
      } else {
        context.showWarningSnackBar('${AppLocalizations.of(context)!.locker} $lockerName ${AppLocalizations.of(context)!.empty}');
      }
    } else {
      // Booking/Member mode: select available lockers
      if (isAvailable) {
        setState(() {
          selectedLocker = lockerId;
          selectedLockerName = lockerName;
        });
      } else {
        context.showWarningSnackBar('${AppLocalizations.of(context)!.locker} $lockerName ${AppLocalizations.of(context)!.occupied}');
      }
    }
  }
}
