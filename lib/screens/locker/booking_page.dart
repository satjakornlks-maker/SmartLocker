import 'package:flutter/material.dart';
import '../common/otp_page.dart';
import '../../widgets/locker/locker_legend.dart';
import '../../widgets/locker/locker_box.dart';
import '../../services/api_service.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPage();
}

class _BookingPage extends State<BookingPage> {
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
          const Text(
            'จองตู้ล็อคเกอร์',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
          const Row(
            children: [
              Icon(Icons.grid_view_rounded, color: Colors.deepPurple, size: 24),
              SizedBox(width: 10),
              Text(
                'ตู้ที่มีให้บริการ',
                style: TextStyle(
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
        onPressed: _handleBooking,
        icon: const Icon(Icons.event_available_rounded, size: 28),
        label: const Text(
          'จองตู้นี้',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
    if (isAvailable) {
      setState(() {
        selectedLocker = lockerId;
        selectedLockerName = lockerName;
      });
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      _showSnackBar('ตู้ $lockerId ไม่ว่าง', Colors.orange);
    }
  }

  void _handleBooking() {
    if (selectedLocker != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPPage(
            lockerId: selectedLocker!,
            lockerName: selectedLockerName!,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      _showSnackBar('โปรดเลือกตู้ล็อคเกอร์', Colors.orange);
    }
  }
}
