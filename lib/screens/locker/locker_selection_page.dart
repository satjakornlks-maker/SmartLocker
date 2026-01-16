import 'package:flutter/material.dart';
import '../common/otp_page.dart';
import '../auth/register_page.dart';
import '../unlock/fill_pin_page.dart';
import '../../widgets/locker/locker_legend.dart';
import '../../widgets/locker/locker_box.dart';
import '../../services/api_service.dart';

enum LockerSelectionMode {
  booking,
  memberSelect,
  unlock,
}

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
              units = lockerUnit.map((e) => Map<String, dynamic>.from(e)).toList();
            }
          }
        } else if (data is Map<String, dynamic>) {
          final lockerUnit = data['lockerUnit'];
          if (lockerUnit is List) {
            units = lockerUnit.map((e) => Map<String, dynamic>.from(e)).toList();
          }
        }

        setState(() {
          lockerStatus = units;
          _isLoading = false;
        });

        print('lockerStatus count = ${lockerStatus.length}');
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

  String get _pageTitle {
    switch (widget.mode) {
      case LockerSelectionMode.booking:
        return 'จองตู้ล็อคเกอร์';
      case LockerSelectionMode.memberSelect:
        return 'เลือกตู้สำหรับสมาชิก';
      case LockerSelectionMode.unlock:
        return 'ปลดล็อคตู้ล็อคเกอร์';
    }
  }

  String get _gridTitle {
    switch (widget.mode) {
      case LockerSelectionMode.booking:
      case LockerSelectionMode.memberSelect:
        return 'ตู้ที่มีให้บริการ';
      case LockerSelectionMode.unlock:
        return 'ตู้ที่กำลังใช้งาน';
    }
  }

  String get _buttonText {
    switch (widget.mode) {
      case LockerSelectionMode.booking:
        return 'จองตู้นี้';
      case LockerSelectionMode.memberSelect:
        return 'ดำเนินการต่อ';
      case LockerSelectionMode.unlock:
        return 'ปลดล็อค';
    }
  }

  IconData get _buttonIcon {
    switch (widget.mode) {
      case LockerSelectionMode.booking:
        return Icons.event_available_rounded;
      case LockerSelectionMode.memberSelect:
        return Icons.app_registration_rounded;
      case LockerSelectionMode.unlock:
        return Icons.lock_open_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade400,
              Colors.deepPurple.shade700,
              Colors.indigo.shade800,
            ],
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Column(
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: _showGrid ? _buildBody() : const SizedBox.shrink(),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _pageTitle,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
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
        child: Container(
          margin: MediaQuery.of(context).size.width > 600
              ? const EdgeInsets.fromLTRB(300, 0, 300, 0)
              : EdgeInsets.zero,
          child: Column(
            children: [
              _buildLegendCard(),
              const SizedBox(height: 20),
              _buildLockerGrid(),
              const SizedBox(height: 20),
              _buildConfirmButton(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline_rounded, color: Colors.deepPurple, size: 24),
              SizedBox(width: 10),
              Text(
                'คำอธิบาย',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const LockerLegend(),
        ],
      ),
    );
  }

  Widget _buildLockerGrid() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.grid_view_rounded, color: Colors.deepPurple, size: 24),
              const SizedBox(width: 10),
              Text(
                _gridTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildLockerGridView(),
        ],
      ),
    );
  }

  Widget _buildLockerGridView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = (constraints.maxWidth - 40) / 3;

        return GridView.extent(
          maxCrossAxisExtent: maxWidth,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          cacheExtent: 0,
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: true,
          children: lockerStatus.map((entry) {
            return LockerBox(
              selectedLocker: selectedLocker,
              lockerStatus: entry,
              onTap: _onLockerTap,
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _handleConfirm,
        icon: Icon(_buttonIcon, size: 28),
        label: Text(
          _buttonText,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 8,
        ),
      ),
    );
  }

  void _onLockerTap(String lockerId, bool isAvailable, String lockerName) {
    ScaffoldMessenger.of(context).clearSnackBars();

    if (widget.mode == LockerSelectionMode.unlock) {
      // Unlock mode: select unavailable (occupied) lockers
      if (!isAvailable) {
        setState(() {
          selectedLocker = lockerId;
          selectedLockerName = lockerName;
        });
      } else {
        _showSnackBar('ตู้ $lockerId ว่างอยู่', Colors.orange);
      }
    } else {
      // Booking/Member mode: select available lockers
      if (isAvailable) {
        setState(() {
          selectedLocker = lockerId;
          selectedLockerName = lockerName;
        });
      } else {
        _showSnackBar('ตู้ $lockerId ไม่ว่าง', Colors.orange);
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
            builder: (context) => OTPPage(

              lockerId: selectedLocker!,
              lockerName: selectedLockerName!,
              mode: OTPPageMode.normal,
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
            builder: (context) => FillPinPage(
              lockerId: selectedLocker!,
              lockerName: selectedLockerName!,
            ),
          ),
        );
        break;
    }
  }
}
