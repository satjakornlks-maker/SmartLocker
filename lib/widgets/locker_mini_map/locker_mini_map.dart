import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/services/api_service.dart';
import 'package:untitled/theme/theme.dart';
import 'package:untitled/utils/size_color.dart';

/// Compact read-only locker map.
///
/// - When [lockerData] is provided (non-empty), uses it directly — no API call
///   for unit data.
/// - When [lockerData] is empty, loads all locker units from the API itself.
/// - Pass [sizes] (from the sizes API) to get localised display names in the
///   legend. When omitted the mini-map fetches them itself.
/// - When [selectedLockerId] is set, that unit is highlighted with the accent
///   colour and a "Your locker" legend entry is added.
/// - Unit colours are assigned automatically by [SizeColor.forKey] — any
///   number of sizes the backend returns will each get a distinct colour.
class LockerMiniMap extends StatefulWidget {
  final List<Map<String, dynamic>> lockerData;
  final List<Map<String, dynamic>> sizes;
  final String? selectedLockerId;

  const LockerMiniMap({
    super.key,
    this.lockerData = const [],
    this.sizes = const [],
    this.selectedLockerId,
  });

  @override
  State<LockerMiniMap> createState() => _LockerMiniMapState();
}

class _LockerMiniMapState extends State<LockerMiniMap> {
  List<Map<String, dynamic>> _units = [];
  // key (lowercase) → localised display name
  Map<String, String> _sizeNames = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(LockerMiniMap old) {
    super.didUpdateWidget(old);
    final dataChanged = widget.lockerData.isNotEmpty &&
        widget.lockerData != old.lockerData;
    final sizesChanged = widget.sizes != old.sizes;
    if (dataChanged || sizesChanged) _init();
  }

  Future<void> _init() async {
    // Run unit-fetch and size-fetch in parallel when needed.
    final fetchUnits =
        widget.lockerData.isEmpty ? _fetchUnits() : Future.value(<Map<String, dynamic>>[]);
    final fetchSizeNames =
        widget.sizes.isEmpty ? _fetchSizeNames() : Future.value(_buildNameMap(widget.sizes));

    final results = await Future.wait([fetchUnits, fetchSizeNames]);
    if (!mounted) return;

    setState(() {
      _units = widget.lockerData.isNotEmpty
          ? widget.lockerData
          : (results[0] as List<Map<String, dynamic>>);
      _sizeNames = results[1] as Map<String, String>;
      _loading = false;
    });
  }

  // ── data loading ──────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> _fetchUnits() async {
    try {
      final result = await ApiService.instance.getLocker();
      final data = result['data'];
      Map<String, dynamic>? firstMap;
      if (data is List && data.isNotEmpty && data.first is Map<String, dynamic>) {
        firstMap = data.first as Map<String, dynamic>;
      } else if (data is Map<String, dynamic>) {
        firstMap = data;
      }
      if (firstMap != null) {
        final raw = firstMap['lockerUnit'] ??
            firstMap['locker_unit'] ??
            firstMap['LockerUnit'];
        if (raw is List) {
          return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        }
      }
    } catch (_) {}
    return [];
  }

  Future<Map<String, String>> _fetchSizeNames() async {
    try {
      final sizes = await ApiService.instance.getSizes();
      return _buildNameMap(sizes);
    } catch (_) {
      return {};
    }
  }

  Map<String, String> _buildNameMap(List<Map<String, dynamic>> sizes) {
    final Map<String, String> map = {};
    for (final s in sizes) {
      final key = (s['key'] ?? s['Key'] ?? s['size_key'] ?? '')
          .toString()
          .toLowerCase();
      if (key.isEmpty) continue;
      // Prefer the locale of the running app; fall back to English then the key.
      // We read the locale later in build; store both here.
      final en = (s['name_en'] ?? s['nameEn'])?.toString() ?? '';
      final th = (s['name_th'] ?? s['nameTh'])?.toString() ?? '';
      // Store as "th|en" so we can split in build.
      map[key] = '$th|$en';
    }
    return map;
  }

  // ── helpers ───────────────────────────────────────────────────────────────

  Color _colorForUnit(Map<String, dynamic> unit) {
    if (unit['id']?.toString() == widget.selectedLockerId) {
      return AppColors.lockerChoosing;
    }
    final raw = unit['lockerSize'] ?? unit['locker_size'] ?? unit['LockerSize'];
    if (raw == null) return SizeColor.forKey('');
    return SizeColor.forKey(raw.toString());
  }

  Map<int, List<Map<String, dynamic>>> _grouped() {
    final Map<int, List<Map<String, dynamic>>> g = {};
    for (final u in _units) {
      final id = u['lockerId'] as int? ?? 0;
      g.putIfAbsent(id, () => []);
      g[id]!.add(u);
    }
    return g;
  }

  List<String> get _presentSizeKeys {
    // Collect keys that actually appear in the rendered units.
    final inUnits = <String>{};
    for (final u in _units) {
      final raw = u['lockerSize'] ?? u['locker_size'] ?? u['LockerSize'];
      if (raw != null) inUnits.add(raw.toString().toLowerCase());
    }
    // Return in API order (insertion order of _sizeNames) so the legend
    // matches the order of the size-selection cards above it.
    final ordered =
        _sizeNames.keys.where((k) => inUnits.contains(k)).toList();
    // Any key present in units but missing from _sizeNames goes at the end.
    final extras = inUnits.difference(ordered.toSet()).toList()..sort();
    return [...ordered, ...extras];
  }

  String _displayName(String key, String locale) {
    final packed = _sizeNames[key];
    if (packed == null) return key.toUpperCase();
    final parts = packed.split('|');
    final th = parts.isNotEmpty ? parts[0] : '';
    final en = parts.length > 1 ? parts[1] : '';
    if (locale == 'th' && th.isNotEmpty) return th;
    if (en.isNotEmpty) return en;
    return key.toUpperCase();
  }

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (_units.isEmpty) return const SizedBox.shrink();

    final grouped = _grouped();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLegend(context),
        const SizedBox(height: AppSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;
            final sectionCount = grouped.length;
            const double sectionGap = 12.0;
            final double widthPerSection = sectionCount == 0
                ? totalWidth
                : (totalWidth - (sectionCount - 1) * sectionGap) / sectionCount;

            final entries = grouped.entries.toList();
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < entries.length; i++) ...[
                  if (i > 0) const SizedBox(width: 12),
                  _buildSection(entries[i].value, widthPerSection),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildSection(List<Map<String, dynamic>> units, double sectionWidth) {
    int maxCol = 0, maxRow = 0;
    for (final u in units) {
      final x = u['x'] as int? ?? 0;
      final y = u['y'] as int? ?? 0;
      final w = u['w'] as int? ?? 1;
      final h = u['h'] as int? ?? 1;
      if (x + w > maxCol) maxCol = x + w;
      if (y + h > maxRow) maxRow = y + h;
    }
    if (maxCol == 0 || maxRow == 0) return const SizedBox.shrink();

    const double gap = 4.0;
    final double rawCell = (sectionWidth - (maxCol - 1) * gap) / maxCol;
    final double cellSize = rawCell.clamp(14.0, 36.0);
    final double gridW = maxCol * cellSize + (maxCol - 1) * gap;
    final double gridH = maxRow * cellSize + (maxRow - 1) * gap;

    return SizedBox(
      width: gridW,
      height: gridH,
      child: Stack(
        children: units.map((unit) {
          final x = unit['x'] as int? ?? 0;
          final y = unit['y'] as int? ?? 0;
          final w = unit['w'] as int? ?? 1;
          final h = unit['h'] as int? ?? 1;
          final isSelected = unit['id']?.toString() == widget.selectedLockerId;
          final color = _colorForUnit(unit);
          final name = unit['name']?.toString() ?? '';

          return Positioned(
            left: x * (cellSize + gap),
            top: y * (cellSize + gap),
            width: w * cellSize + (w - 1) * gap,
            height: h * cellSize + (h - 1) * gap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
                border: isSelected
                    ? Border.all(color: Colors.white, width: 2)
                    : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.6),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final sizeKeys = _presentSizeKeys;
    final hasSelected = widget.selectedLockerId != null;

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.xl,
      runSpacing: AppSpacing.xs,
      children: [
        ...sizeKeys.map((key) => _legendItem(
              SizeColor.forKey(key),
              _displayName(key, locale),
            )),
        if (hasSelected) _legendItem(AppColors.lockerChoosing, l.yourLocker),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppText.bodySmall.copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
