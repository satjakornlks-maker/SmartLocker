import 'package:flutter/material.dart';
import 'package:untitled/screens/input_type_page/input_type_page.dart';
import '../common/otp_page.dart';
import '../auth/register_page.dart';
import '../../services/api_service.dart';

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
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> lockerStatus = [];
  bool _showGrid = false;
  static const String systemMode =
  String.fromEnvironment('TYPE', defaultValue: 'B2C');
  int _gridColumns = 0;
  int _gridRows = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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

    try {
      final result = await _apiService.getLocker();
      if (!mounted) return;

      if (result['success'] == true) {
        final data = result['data'];

        List<Map<String, dynamic>> units = [];

        if (data is List && data.isNotEmpty) {
          final first = data.first;

          if (first is Map<String, dynamic>) {
            final lockerUnit = first['lockerUnit'];

            if (lockerUnit is List) {
              units =
                  lockerUnit.map((e) => Map<String, dynamic>.from(e)).toList();
            }
          }
        } else if (data is Map<String, dynamic>) {
          final lockerUnit = data['lockerUnit'];
          if (lockerUnit is List) {
            units =
                lockerUnit.map((e) => Map<String, dynamic>.from(e)).toList();
          }
        }

        // Calculate grid dimensions from data
        _calculateGridDimensions(units);

        // Filter by book type if needed (but keep all for grid layout reference)
        List<Map<String, dynamic>> filteredUnits = List.from(units);

        // Step 1: Filter by book type
        if (_bookTypeFilter != null) {
          filteredUnits = filteredUnits.where((unit) {
            final lockerBookType = unit['locker_booktype'];
            return lockerBookType == _bookTypeFilter;
          }).toList();
        }

        // Step 2: Filter by size (only for B2C mode)
        if (systemMode == 'B2C') {
          if (widget.size != null && widget.size!.isNotEmpty) {
            filteredUnits = filteredUnits.where((unit) {
              final lockerSize = unit['lockerSize']?.toString().toLowerCase();
              final targetSize = widget.size!.toLowerCase();
              return lockerSize == targetSize;
            }).toList();
          }
        }

        if (filteredUnits.isEmpty) {
          // Show snackbar and pop after a short delay
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showSnackBar("ไม่มีตู้ล็อคเกอร์ไซส์นี้", Colors.red);
            Navigator.pop(context);
          });
          return; // Stop execution here
        }

        setState(() {
          lockerStatus = units.map((unit) {
            final isFiltered = filteredUnits.any((f) => f['id'] == unit['id']);
            return {...unit, '_isFiltered': isFiltered};
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        _showSnackBar('เกิดข้อผิดพลาด: ${result['error']}', Colors.red);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showSnackBar('เกิดข้อผิดพลาดในการเชื่อมต่อ', Colors.red);
    }
  }

  void _calculateGridDimensions(List<Map<String, dynamic>> units) {
    int maxCol = 0;
    int maxRow = 0;

    for (var unit in units) {
      final x = unit['x'] as int? ?? 0;
      final y = unit['y'] as int? ?? 0;
      final w = unit['w'] as int? ?? 1;
      final h = unit['h'] as int? ?? 1;

      // x is column, y is row
      if (x + w > maxCol) maxCol = x + w;
      if (y + h > maxRow) maxRow = y + h;
    }

    _gridColumns = maxCol;
    _gridRows = maxRow;

    print('Grid dimensions: $_gridColumns columns x $_gridRows rows');
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  String get _buttonText {
    switch (widget.mode) {
      case LockerSelectionMode.booking:
        return 'ยืนยัน';
      case LockerSelectionMode.memberSelect:
        return 'ดำเนินการต่อ';
      case LockerSelectionMode.unlock:
        return 'ปลดล็อค';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: _isLoading
            ? const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
          ),
        )
            : _showGrid ? _buildResponsiveBody() : const SizedBox.shrink(),
      ),
    );
  }

  /// Responsive body that fits within screen without scrolling
  Widget _buildResponsiveBody() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Available space
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        // Fixed heights for UI elements
        const double headerHeight = 70;
        const double titleHeight = 50;
        const double legendHeight = 30;
        const double buttonHeight = 60;
        const double paddingTotal = 80; // Top/bottom padding + spacing between elements

        // Calculate available height for grid
        final double availableGridHeight = screenHeight -
            headerHeight -
            titleHeight -
            legendHeight -
            buttonHeight -
            paddingTotal;

        // Calculate available width for grid (with side padding)
        final double availableGridWidth = screenWidth - 80; // 40px padding each side

        return Column(
          children: [
            // Header
            _buildHeader(),

            // Main content area - uses remaining space
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // Title
                    const Text(
                      'เลือกตู้ที่ต้องการ',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Legend
                    _buildLegend(),

                    const SizedBox(height: 20),

                    // Locker Grid - Flexible to fill available space
                    Expanded(
                      child: Center(
                        child: _buildResponsiveLockerGrid(
                          availableGridWidth,
                          availableGridHeight,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Confirm Button
                    _buildConfirmButton(),

                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'SMART LOCKER',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(Colors.green, 'ว่าง'),
        const SizedBox(width: 25),
        _buildLegendItem(Colors.red.shade400, 'ไม่ว่าง'),
        const SizedBox(width: 25),
        _buildLegendItem(Colors.yellow.shade700, 'กำลังเลือก'),
        const SizedBox(width: 25),
        _buildLegendItem(Colors.grey.shade400, 'ไม่พร้อมใช้งาน'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }

  /// Responsive grid that fits within available space
  Widget _buildResponsiveLockerGrid(
      double availableWidth, double availableHeight) {
    if (_gridColumns == 0 || _gridRows == 0) {
      return const Text('No lockers available');
    }

    // Calculate cell size to fit within available space
    const double gap = 8.0;

    // Calculate max cell size based on width
    final double maxCellByWidth =
        (availableWidth - (_gridColumns - 1) * gap) / _gridColumns;

    // Calculate max cell size based on height
    final double maxCellByHeight =
        (availableHeight - (_gridRows - 1) * gap) / _gridRows;

    // Use the smaller value to ensure grid fits both dimensions
    final double cellSize = maxCellByWidth < maxCellByHeight
        ? maxCellByWidth
        : maxCellByHeight;

    // Clamp cell size to reasonable bounds
    final double finalCellSize = cellSize.clamp(40.0, 120.0);

    // Calculate actual grid dimensions
    final double gridWidth =
        _gridColumns * finalCellSize + (_gridColumns - 1) * gap;
    final double gridHeight =
        _gridRows * finalCellSize + (_gridRows - 1) * gap;

    return SizedBox(
      width: gridWidth,
      height: gridHeight,
      child: Stack(
        children: lockerStatus.map((entry) {
          return _buildPositionedLocker(entry, finalCellSize, finalCellSize, gap);
        }).toList(),
      ),
    );
  }

  Widget _buildPositionedLocker(
      Map<String, dynamic> entry,
      double cellWidth,
      double cellHeight,
      double gap,
      ) {
    final lockerId = entry['id']?.toString() ?? '';
    final lockerName = entry['name']?.toString() ?? lockerId;
    final isEnable = entry['enable'] == true;
    final status = entry['status'] == true;
    final isFiltered = entry['_isFiltered'] == true;

    // Position data
    final int x = entry['x'] as int? ?? 0; // Column
    final int y = entry['y'] as int? ?? 0; // Row
    final int w = entry['w'] as int? ?? 1; // Width in cells
    final int h = entry['h'] as int? ?? 1; // Height in cells

    // Calculate position and size
    final double left = x * (cellWidth + gap);
    final double top = y * (cellHeight + gap);
    final double width = w * cellWidth + (w - 1) * gap;
    final double height = h * cellHeight + (h - 1) * gap;

    // Determine availability based on mode
    final isAvailable = widget.mode == LockerSelectionMode.unlock
        ? status // For unlock mode, select occupied (status: true)
        : !status && !isEnable; // For booking mode, select available

    final isSelected = selectedLocker == lockerId;

    // Determine color
    Color buttonColor;
    Color borderColor = Colors.transparent;

    if (!isFiltered) {
      buttonColor = Colors.grey.shade300;
    } else if (isSelected) {
      buttonColor = Colors.yellow.shade700;
    } else if (widget.mode == LockerSelectionMode.unlock) {
      // Unlock mode: Green = occupied (can unlock), Red = empty
      buttonColor = status ?  Colors.red.shade400 : Colors.green;
    } else {
      // Booking mode: Green = available, Red = occupied
      buttonColor = isAvailable ? Colors.green : Colors.red.shade400;
    }

    // Calculate responsive font and icon sizes based on cell size
    final double baseFontSize = (cellWidth * 0.18).clamp(10.0, 16.0);
    final double iconSize = (cellWidth * 0.3).clamp(16.0, 32.0);

    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 3 : 0,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.orange.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 2,
            )
          ]
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: isFiltered
                ? () => _onLockerTap(lockerId, isAvailable, lockerName)
                : null,
            child: Container(
              padding: EdgeInsets.all(cellWidth * 0.08),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon
                  Icon(
                    w >= 2 || h >= 2
                        ? Icons.inventory_2
                        : Icons.inventory_2_outlined,
                    size: iconSize,
                    color: Colors.white,
                  ),
                  SizedBox(height: cellHeight * 0.05),
                  // Locker name
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      lockerName,
                      style: TextStyle(
                        fontSize: baseFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Status indicator for occupied lockers
                  if (status && isFiltered && height > 60)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,

                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 350),
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _handleConfirm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
        child: Text(
          selectedLockerName != null
              ? '$_buttonText #$selectedLockerName'
              : _buttonText,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
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
        _showSnackBar('ตู้ $lockerName ว่างอยู่', Colors.orange);
      }
    } else {
      // Booking/Member mode: select available lockers
      if (isAvailable) {
        setState(() {
          selectedLocker = lockerId;
          selectedLockerName = lockerName;
        });
      } else {
        _showSnackBar('ตู้ $lockerName ไม่ว่าง', Colors.orange);
      }
    }
  }

  void _handleConfirm() {
    if (selectedLocker == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      _showSnackBar('โปรดเลือกตู้ล็อคเกอร์', Colors.orange);
      return;
    }

    switch (widget.mode) {
      case LockerSelectionMode.booking:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InputTypePage(
              from: FromPage.normal,
              selectedLocker: selectedLocker!,
              lockerName: selectedLockerName!,
            ),
          ),
        );
        break;
      case LockerSelectionMode.memberSelect:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterPage(selectedLocker: selectedLocker!),
          ),
        );
        break;
      case LockerSelectionMode.unlock:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OTPPage(
                from: FromPage.unlock,
                lockerId: selectedLocker!,
                lockerName: selectedLockerName,
              )),
        );
        break;
    }
  }
}