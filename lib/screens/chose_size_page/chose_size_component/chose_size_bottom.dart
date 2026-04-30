import 'package:flutter/material.dart';
import 'package:untitled/screens/chose_size_page/chose_size_component/locker_mini_map.dart';
import 'package:untitled/screens/locker_page/locker_selection_page.dart';
import 'package:untitled/theme/theme.dart';

import '../../../l10n/app_localizations.dart';
import '../../../services/api_service.dart';
import '../../../services/device_config_service.dart';
import '../../../widgets/snackbar/snackbar.dart';
import '../../locker_page/locker_function/locker_service.dart';

class ChossSizeBottom extends StatefulWidget{
  const ChossSizeBottom({super.key});

  @override
  State<ChossSizeBottom> createState() => _ChossSizeBottom();
}

class _ChossSizeBottom extends State<ChossSizeBottom> {
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
    _lockerService = LockerService(_apiService);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadLocker();
    });
  }

  Future<void> _loadLocker() async {
    setState(() => _isLoading = true);

    final result = await _lockerService.loadLocker(
      bookTypeFilter: null,
      sizeFilter: null,
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
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LockerMiniMap(lockerData: lockerStatus,
            ),
        const Text(
          'SECURE ACCESS',
          style: TextStyle(
            fontFamily: AppText.family,
            fontSize: 12,
            letterSpacing: 2,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
