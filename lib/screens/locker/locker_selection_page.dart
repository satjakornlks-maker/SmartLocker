import 'package:flutter/material.dart';
import 'package:untitled/screens/input_type_page/input_type_page.dart';
import '../common/otp_page.dart';
import '../auth/register_page.dart';
import '../../services/api_service.dart';

enum LockerSelectionMode { booking, memberSelect, unlock }

class LockerSelectionPage extends StatefulWidget {
  final LockerSelectionMode mode;

  const LockerSelectionPage({super.key, required this.mode});

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
              units = lockerUnit
                  .map((e) => Map<String, dynamic>.from(e))
                  .toList();
            }
          }
        } else if (data is Map<String, dynamic>) {
          final lockerUnit = data['lockerUnit'];
          if (lockerUnit is List) {
            units = lockerUnit
                .map((e) => Map<String, dynamic>.from(e))
                .toList();
          }
        }

        // Filter by book type if needed
        if (_bookTypeFilter != null) {
          units = units.where((unit) {
            final lockerBookType = unit['locker_booktype'];
            return lockerBookType == _bookTypeFilter;
          }).toList();
        }

        setState(() {
          lockerStatus = units;
          _isLoading = false;
        });

        print('lockerStatus count = ${lockerStatus.length}');
        print('Filtered by bookType: $_bookTypeFilter');
        print(lockerStatus);
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
            : Column(
                children: [
                  SizedBox(height: 15),
                  _buildHeader(),
                  Expanded(
                    child: _showGrid ? _buildBody() : const SizedBox.shrink(),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),

      child: Row(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(50, 0, 0, 0),
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

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Title
                const Text(
                  'เลือกตู้ที่ต้องการ',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 30),

                // Legend
                _buildLegend(),

                const SizedBox(height: 40),

                // Locker Grid
                _buildLockerGrid(),

                const SizedBox(height: 40),

                // Confirm Button
                _buildConfirmButton(),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(Colors.green, 'ว่าง'),
        const SizedBox(width: 30),
        _buildLegendItem(Colors.red.shade400, 'ไม่ว่าง'),
        const SizedBox(width: 30),
        _buildLegendItem(Colors.yellow.shade700, 'กำลังเลือก'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildLockerGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate optimal button size based on available width
        final double maxWidth = constraints.maxWidth > 900
            ? 900
            : constraints.maxWidth;
        final double buttonWidth =
            (maxWidth - 100) / 4; // 6 columns with spacing

        return Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: lockerStatus.map((entry) {
            final lockerId = entry['id']?.toString() ?? '';
            final lockerName = entry['name']?.toString() ?? lockerId;
            final isEnable = entry['enable'] == true;
            final status = entry['status'] == true;

            // Determine availability based on mode
            final isAvailable = widget.mode == LockerSelectionMode.unlock
                ? !status // For unlock mode, show occupied (status: true)
                : !status &&
                      !isEnable; // For booking mode, show available (status: false and enable: true)

            final isSelected = selectedLocker == lockerId;

            Color buttonColor;
            if (isSelected) {
              buttonColor = Colors.yellow.shade700;
            } else if (isAvailable) {
              buttonColor = Colors.green;
            } else {
              buttonColor = Colors.red.shade400;
            }

            return SizedBox(
              width: buttonWidth,
              height: 60,
              child: ElevatedButton(
                onPressed: () =>
                    _onLockerTap(lockerId, isAvailable, lockerName),
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  padding: EdgeInsets.zero,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 24,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lockerName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleConfirm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 3,
        ),
        child: Text(
          selectedLockerName != null
              ? '$_buttonText #$selectedLockerName'
              : _buttonText,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _onLockerTap(String lockerId, bool isAvailable, String lockerName) {
    ScaffoldMessenger.of(context).clearSnackBars();

    if (widget.mode == LockerSelectionMode.unlock) {
      // Unlock mode: select occupied lockers
      if (!isAvailable) {
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
            builder: (context) => OTPPage(from: FromPage.unlock , lockerId: selectedLocker!,lockerName: selectedLockerName,)
          ),
        );
        break;
    }
  }
}
