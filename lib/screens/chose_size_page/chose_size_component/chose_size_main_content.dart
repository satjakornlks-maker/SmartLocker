import 'dart:math';

import 'package:flutter/material.dart';
import 'package:untitled/services/device_config_service.dart';
import 'package:untitled/theme/theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/api_service.dart';
import '../../../../widgets/grid/HoverMenuCard.dart';
import '../../../../widgets/snackbar/snackbar.dart';
import '../../input_type_page/input_type_page/input_type_page.dart';
import '../../input_type_page/phone_input_page/phone_input_page.dart';
import '../../locker_page/locker_selection_page.dart';
import '../../locker_page/locker_function/locker_service.dart';
import 'chose_size_bottom.dart';
import '../../../../widgets/locker_mini_map/locker_mini_map.dart';
import '../../../../utils/size_color.dart';

class ChoseSizeMainContent extends StatefulWidget {
  final LockerSelectionMode? mode;
  final FromPage? from;
  final ValueChanged<bool>? onLoadingChanged;
  const ChoseSizeMainContent({
    super.key,
    this.mode,
    this.from,
    this.onLoadingChanged,
  });

  @override
  State<ChoseSizeMainContent> createState() => _ChoseSizeMainContentState();
}

class _ChoseSizeMainContentState extends State<ChoseSizeMainContent> {
  List<Map<String, dynamic>> _sizes = [];
  bool _sizesReady = false;
  bool _sizesError = false;
  // null = availability unknown (show all enabled); non-null = checked set
  Set<String>? _availableSizeKeys;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadSizes();
    });
  }

  // ── booktype used to check availability ────────────────────────────────────

  int? get _bookTypeForAvailability {
    if (widget.from == FromPage.visitor) return 5;
    if (widget.from == FromPage.dropBox) return 1;
    if (widget.from == FromPage.instance) return 1;
    return null; // mode-based (employee choose locker) — check any type
  }

  // ── data loading ───────────────────────────────────────────────────────────

  Future<void> _loadSizes() async {
    widget.onLoadingChanged?.call(true);
    try {
      final sizeFuture = ApiService.instance.getSizes();
      final availFuture = _fetchAvailableSizeKeys();

      final sizes = await sizeFuture;
      final avail = await availFuture;

      if (!mounted) return;
      setState(() {
        _sizes = sizes;
        _availableSizeKeys = avail;
        _sizesReady = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _sizesError = true;
        _sizesReady = true;
      });
    } finally {
      if (mounted) widget.onLoadingChanged?.call(false);
    }
  }

  Future<Set<String>?> _fetchAvailableSizeKeys() async {
    try {
      final result = await LockerService(ApiService.instance).loadLocker(
        bookTypeFilter: _bookTypeForAvailability,
        systemMode: DeviceConfigService.systemMode,
      );
      if (!result.isSuccess) return null;
      final available = result.data?.where((u) =>
              u['_isFiltered'] == true &&
              u['status'] == false &&
              u['enable'] == true) ??
          [];
      return available
          .map((u) =>
              (u['lockerSize'] ?? u['locker_size'] ?? u['LockerSize'] ?? '')
                  .toString()
                  .toLowerCase())
          .where((k) => k.isNotEmpty)
          .toSet();
    } catch (_) {
      return null; // on error show all as enabled
    }
  }

  bool _isEnabled(String key) {
    if (_availableSizeKeys == null) return true;
    return _availableSizeKeys!.contains(key.toLowerCase());
  }

  // ── navigation helpers ─────────────────────────────────────────────────────

  Future<void> _onDropBoxSizeSelected(String size) async {
    widget.onLoadingChanged?.call(true);
    try {
      final apiService = ApiService.instance;
      final lockerService = LockerService(apiService);

      final result = await lockerService.loadLocker(
        bookTypeFilter: 1,
        sizeFilter: size,
        systemMode: DeviceConfigService.systemMode,
      );

      if (!mounted) return;

      if (!result.isSuccess || result.isEmpty) {
        context.showErrorSnackBar(AppLocalizations.of(context)!.noAvailableLocker);
        return;
      }

      final available =
          result.data!.where((u) => u['_isFiltered'] == true).toList();
      if (available.isEmpty) {
        context.showErrorSnackBar(AppLocalizations.of(context)!.noAvailableLocker);
        return;
      }

      final locker = available[Random().nextInt(available.length)];
      final lockerId = locker['id']?.toString() ?? '';
      final lockerName = locker['name']?.toString() ?? '';

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhoneInputPage(
            from: FromPage.visitor,
            selectedLocker: lockerId,
            lockerName: lockerName,
            lockerData: result.data!,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      context.showErrorSnackBar('${AppLocalizations.of(context)!.errorOccur}: $e');
    } finally {
      if (mounted) widget.onLoadingChanged?.call(false);
    }
  }

  Future<void> _checkAvailabilityThenNavigate(
      String size, FromPage from, int bookTypeFilter) async {
    widget.onLoadingChanged?.call(true);

    final result = await LockerService(ApiService.instance).loadLocker(
      bookTypeFilter: bookTypeFilter,
      sizeFilter: size,
      systemMode: DeviceConfigService.systemMode,
    );

    if (!mounted) return;
    widget.onLoadingChanged?.call(false);

    final available =
        result.data?.where((u) => u['_isFiltered'] == true).toList() ?? [];
    if (!result.isSuccess || result.isEmpty || available.isEmpty) {
      context.showErrorSnackBar(AppLocalizations.of(context)!.noAvailableLocker);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhoneInputPage(from: from, size: size),
      ),
    );
  }

  void _onSizeSelected(String size) {
    if (widget.from == FromPage.dropBox) {
      _onDropBoxSizeSelected(size);
      return;
    }
    if (widget.from == FromPage.visitor) {
      _checkAvailabilityThenNavigate(size, FromPage.visitor, 5);
      return;
    }
    if (widget.from == FromPage.instance) {
      _checkAvailabilityThenNavigate(size, FromPage.instance, 1);
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget.mode != null
            ? LockerSelectionPage(mode: widget.mode!, size: size)
            : PhoneInputPage(from: widget.from!, size: size),
      ),
    );
  }

  // ── display helpers ────────────────────────────────────────────────────────

  Color _cardColorForKey(String key) => SizeColor.forKey(key);

  String _label(Map<String, dynamic> size) {
    final locale = Localizations.localeOf(context).languageCode;
    final fallback =
        (size['key'] ?? size['Key'] ?? size['size_key'] ?? '').toString();
    return locale == 'th'
        ? ((size['name_th'] ?? size['nameTh']) as String? ?? fallback)
        : ((size['name_en'] ?? size['nameEn']) as String? ?? fallback);
  }

  // ── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final compact = MediaQuery.of(context).size.height <= 800;
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.choseLockerType,
              style: AppText.displayMediumR(context),
            ),
            SizedBox(height: compact ? AppSpacing.xs : AppSpacing.xl),
            if (!_sizesReady)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_sizesError || _sizes.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    l.noAvailableLocker,
                    style: AppText.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              )
            else ...[
              Row(
                children: [
                  for (int i = 0; i < _sizes.length; i++) ...[
                    if (i > 0) const SizedBox(width: AppSpacing.xl),
                    Expanded(
                      child: () {
                        final size = _sizes[i];
                        final key = (size['key'] ??
                                size['Key'] ??
                                size['size_key'] ??
                                '')
                            .toString();
                        final label = _label(size);
                        final enabled = _isEnabled(key);
                        return HoverMenuCard(
                          titleTh: Text(label, textAlign: TextAlign.center),
                          semanticLabel: '$label. ${l.tapToPickSize}',
                          icon: Icons.home_work,
                          color: AppColors.primary,
                          cardColor: _cardColorForKey(key),
                          aspectRatio: 2.8,
                          enabled: enabled,
                          onPressed: () => _onSizeSelected(key),
                          haveIcon: false,
                        );
                      }(),
                    ),
                  ],
                ],
              ),
              const Spacer(),
              LockerMiniMap(sizes: _sizes),
              const SizedBox(height: AppSpacing.lg),
              const ChossSizeBottom(),
              const SizedBox(height: AppSpacing.lg),
            ],
          ],
        ),
      ),
    );
  }
}
