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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadSizes();
    });
  }

  Future<void> _loadSizes() async {
    widget.onLoadingChanged?.call(true);
    try {
      final sizes = await ApiService().getSizes();
      if (!mounted) return;
      setState(() {
        _sizes = sizes;
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

  Future<void> _onDropBoxSizeSelected(String size) async {
    widget.onLoadingChanged?.call(true);

    final apiService = ApiService();
    final lockerService = LockerService(apiService);

    final result = await lockerService.loadLocker(
      bookTypeFilter: 1,
      sizeFilter: size,
      systemMode: DeviceConfigService.systemMode,
    );

    if (!mounted) return;
    widget.onLoadingChanged?.call(false);

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
  }

  void _onSizeSelected(String size) {
    if (widget.from == FromPage.dropBox) {
      _onDropBoxSizeSelected(size);
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget.mode != null
            ? LockerSelectionPage(mode: widget.mode!, size: size)
            : InputTypePage(from: widget.from!, size: size),
      ),
    );
  }

  String _label(Map<String, dynamic> size) {
    final locale = Localizations.localeOf(context).languageCode;
    final fallback =
        (size['key'] ?? size['Key'] ?? size['size_key'] ?? '').toString();
    return locale == 'th'
        ? ((size['name_th'] ?? size['nameTh']) as String? ?? fallback)
        : ((size['name_en'] ?? size['nameEn']) as String? ?? fallback);
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
              l.choseLockerType,
              style: AppText.displayMediumR(context),
            ),
            const SizedBox(height: AppSpacing.xl),
            if (!_sizesReady)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xxl),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_sizesError || _sizes.isEmpty)
              Center(
                child: Text(
                  l.noAvailableLocker,
                  style: AppText.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            else
              Wrap(
                spacing: AppSpacing.xl,
                runSpacing: AppSpacing.xl,
                children: _sizes.map((size) {
                  final key = (size['key'] ??
                          size['Key'] ??
                          size['size_key'] ??
                          '')
                      .toString();
                  final label = _label(size);
                  return SizedBox(
                    width: (MediaQuery.of(context).size.width -
                            (AppSpacing.xl * 2)) /
                        _sizes.length,
                    child: HoverMenuCard(
                      titleTh: Text(label, textAlign: TextAlign.center),
                      semanticLabel: '$label. Tap to pick this size.',
                      icon: Icons.home_work,
                      color: AppColors.primary,
                      onPressed: () => _onSizeSelected(key),
                      haveIcon: false,
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: AppSpacing.xxxl),
            const ChoseSizeBottom(),
          ],
        ),
      ),
    );
  }
}
