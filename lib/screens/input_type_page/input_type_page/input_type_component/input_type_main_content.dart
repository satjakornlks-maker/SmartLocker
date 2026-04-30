import 'package:flutter/material.dart';
import 'package:untitled/services/device_config_service.dart';
import 'package:untitled/theme/theme.dart';
import 'package:untitled/widgets/snackbar/snackbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../input_type_page.dart';
import '../input_type_service/locker_service.dart';
import 'input_type_bottom.dart';
import 'input_type_selection_cards.dart';
import '../../../../widgets/locker_mini_map/locker_mini_map.dart';

class InputTypeMainContent extends StatefulWidget {
  final FromPage from;
  final String? selectedLocker;
  final String? lockerName;
  final String? size;
  final List<Map<String, dynamic>> lockerData;
  final ValueChanged<bool>? onLoadingChanged;

  const InputTypeMainContent({
    super.key,
    required this.from,
    this.selectedLocker,
    this.lockerName,
    this.size,
    this.lockerData = const [],
    this.onLoadingChanged,
  });

  @override
  State<InputTypeMainContent> createState() => _InputTypeMainContentState();
}

class _InputTypeMainContentState extends State<InputTypeMainContent> {
  final LockerService _lockerService = LockerService();
  bool _isLoading = false;
  String get systemMode => DeviceConfigService.systemMode;

  String? _selectedLockerId;
  String? _selectedLockerName;
  List<Map<String, dynamic>> _lockerStatus = [];

  String? get _lockerId =>
      widget.from == FromPage.instance || widget.from == FromPage.visitor
          ? _selectedLockerId
          : widget.selectedLocker;

  String? get _lockerName =>
      widget.from == FromPage.instance || widget.from == FromPage.visitor
          ? _selectedLockerName
          : widget.lockerName;

  List<Map<String, dynamic>> get _effectiveLockerData =>
      widget.lockerData.isNotEmpty ? widget.lockerData : _lockerStatus;

  @override
  void initState() {
    super.initState();
    if (widget.from == FromPage.instance || widget.from == FromPage.visitor) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadLocker();
      });
    }
  }

  Future<void> _loadLocker() async {
    setState(() => _isLoading = true);
    widget.onLoadingChanged?.call(true);

    final result = await _lockerService.fetchLockerUnits();
    if (!mounted) return;

    if (result['success'] != true) {
      setState(() => _isLoading = false);
      widget.onLoadingChanged?.call(false);
      context.showErrorSnackBar(
          '${AppLocalizations.of(context)!.errorOccur}: ${result['error']}');
      return;
    }

    final List<Map<String, dynamic>> units =
        List<Map<String, dynamic>>.from(result['data']);

    final selected = _lockerService.selectRandomLocker(
      units: units,
      from: widget.from,
      systemMode: systemMode,
      size: widget.size,
    );

    if (!mounted) return;

    if (selected == null) {
      setState(() => _isLoading = false);
      Navigator.pop(context);
      context.showWarningSnackBar(
          AppLocalizations.of(context)!.noAvailableLocker);
      return;
    }

    setState(() {
      _lockerStatus = units;
      _selectedLockerId = selected['id'].toString();
      _selectedLockerName = selected['name'];
      _isLoading = false;
    });
    widget.onLoadingChanged?.call(false);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.choseInput,
              style: AppText.displayMediumR(context),
            ),
            const SizedBox(height: AppSpacing.xl),
            InputTypeSelectionCards(
              from: widget.from,
              lockerId: _lockerId,
              lockerName: _lockerName,
              lockerData: _effectiveLockerData,
            ),
            if (widget.from == FromPage.instance ||
                widget.from == FromPage.visitor) ...[
              const SizedBox(height: AppSpacing.xxl),
              LockerMiniMap(
                lockerData: _effectiveLockerData,
                selectedLockerId: _selectedLockerId,
              ),
            ],
            const SizedBox(height: AppSpacing.xxxl),
            InputTypeBottom(from: widget.from,),
          ],
        ),
      ),
    );
  }
}
