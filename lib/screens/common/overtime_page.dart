import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class OvertimePage extends StatefulWidget {
  final String day;
  final String hour;
  final String minute;
  final String second;
  final String lockerId;

  const OvertimePage({
    super.key,
    required this.second,
    required this.day,
    required this.hour,
    required this.minute,
    required this.lockerId,
  });

  @override
  State<OvertimePage> createState() => _OvertimePage();
}

class _OvertimePage extends State<OvertimePage> {
  final ApiService _apiService = ApiService();
  bool isLoading = false;

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
          child: Stack(
            children: [
              Column(
                children: [
                  _buildHeader(),
                  Expanded(child: _buildBody()),
                ],
              ),
              if (isLoading)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
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
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning_rounded, color: Colors.white, size: 28),
          SizedBox(width: 10),
          Text(
            'แจ้งเตือนล่วงเวลา',
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
          margin: MediaQuery.of(context).size.width > 940
              ? const EdgeInsets.fromLTRB(200, 0, 200, 0)
              : EdgeInsets.zero,
          child: Column(
            children: [
              const SizedBox(height: 40),
              _buildWarningCard(),
              const SizedBox(height: 25),
              _buildOvertimeDetailsCard(),
              const SizedBox(height: 25),
              _buildInstructionCard(),
              const SizedBox(height: 30),
              _buildConfirmButton(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWarningCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade400, Colors.red.shade600],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(30),
      child: const Column(
        children: [
          Icon(Icons.access_time_filled_rounded, size: 70, color: Colors.white),
          SizedBox(height: 15),
          Text(
            'เกินเวลาที่กำหนด',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'คุณได้ปลดล็อคเกินกำหนด',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildOvertimeDetailsCard() {
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
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.timer_rounded, color: Colors.red, size: 28),
              SizedBox(width: 12),
              Text(
                'ระยะเวลาที่เกิน',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTimeUnit(widget.day, 'วัน', Colors.red),
              _buildTimeUnit(widget.hour, 'ชม.', Colors.orange),
              _buildTimeUnit(widget.minute, 'นาที', Colors.amber),
              _buildTimeUnit(widget.second, 'วินาที', Colors.yellow),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(String value, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color, width: 2),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.amber.shade300, width: 2),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.info_rounded,
              color: Colors.amber.shade900,
              size: 28,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'โปรดตรวจสอบ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'กดยืนยันเมื่อปิดตู้เรียบร้อยแล้ว',
                  style: TextStyle(fontSize: 14, color: Colors.amber.shade800),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _handleCheckStatus,
        icon: const Icon(Icons.check_circle_rounded, size: 28),
        label: const Text(
          'ยืนยันปิดตู้แล้ว',
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

  Future<void> _handleCheckStatus() async {
    setState(() => isLoading = true);
    try {
      final result = await _apiService.handleCheckLockerStatus(widget.lockerId);
      if (!mounted) return;
      setState(() => isLoading = false);
      if (result['success'] && result['data']['lockStatus'] == 'Locked') {
        ScaffoldMessenger.of(context).clearSnackBars();
        _showSnackBar('ดำเนินการเสร็จสิ้น', Colors.green);
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else if (result['success'] &&
          result['data']['lockStatus'] == 'Unlocked') {
        ScaffoldMessenger.of(context).clearSnackBars();
        _showSnackBar('ล็อคเกอร์ยังปิดไม่สนิท', Colors.orange);
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        _showSnackBar('เกิดข้อผิดพลาด: ${result['error']}', Colors.red);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).clearSnackBars();
      _showSnackBar('เกิดข้อผิดพลาด: $e', Colors.red);
    }
  }
}
