import 'dart:math';

import 'package:flutter/material.dart';
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
  const ChoseSizeMainContent({super.key, this.mode, this.from, this.onLoadingChanged});

  @override
  State<ChoseSizeMainContent> createState() => _ChoseSizeMainContentState();
}

class _ChoseSizeMainContentState extends State<ChoseSizeMainContent> {
  Future<void> _onDropBoxSizeSelected(String size) async {
    widget.onLoadingChanged?.call(true);

    final apiService = ApiService();
    final lockerService = LockerService(apiService);

    final result = await lockerService.loadLocker(
      bookTypeFilter: 1,
      sizeFilter: size,
      systemMode: 'B2C',
    );

    if (!mounted) return;
    widget.onLoadingChanged?.call(false);

    if (!result.isSuccess || result.isEmpty) {
      context.showErrorSnackBar(AppLocalizations.of(context)!.noAvailableLocker);
      return;
    }

    final available = result.data!.where((u) => u['_isFiltered'] == true).toList();
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.choseLockerType,
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: HoverMenuCard(
                        titleTh: Text(l10n.small, textAlign: TextAlign.center),
                        icon: Icons.home_work,
                        color: Colors.blue,
                        onPressed: () => _onSizeSelected('small'),
                        haveIcon: false,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: HoverMenuCard(
                        titleTh: Text(l10n.medium, textAlign: TextAlign.center),
                        icon: Icons.person,
                        color: Colors.blue,
                        onPressed: () => _onSizeSelected('medium'),
                        haveIcon: false,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: HoverMenuCard(
                        titleTh: Text(l10n.large, textAlign: TextAlign.center),
                        icon: Icons.person,
                        color: Colors.blue,
                        onPressed: () => _onSizeSelected('large'),
                        haveIcon: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                const ChoseSizeBottom(),
              ],
            ),
          ),
        );

  }
}
