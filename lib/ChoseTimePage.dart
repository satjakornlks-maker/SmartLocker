import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'services/api_service.dart';

class ChoseTimePage extends StatefulWidget {
  final String lockerId;
  final String lockerName;
  final String TelOrEmail;
  final String OTP;
  final int userId;
  const ChoseTimePage({
    super.key,
    required this.lockerId,
    required this.TelOrEmail,
    required this.OTP,
    required this.lockerName,
    required this.userId,
  });
  @override
  State<ChoseTimePage> createState() => _ChoseTimePage();
}

class _ChoseTimePage extends State<ChoseTimePage> {
  bool _isLoading = false;
  final ApiService _apiService = ApiService();
  int hour = 0;
  int minute = 0;

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
              if (_isLoading)
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
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 10),
          const Text(
            'เลือกเวลาการจอง',
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
        child: Column(
          children: [
            _buildLockerCard(),
            const SizedBox(height: 20),
            _buildTimeSelectionCard(),
            const SizedBox(height: 20),
            _buildSummaryCard(),
            const SizedBox(height: 20),
            _buildConfirmButton(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildLockerCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade600],
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
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          const Icon(
            Icons.inbox_rounded,
            size: 60,
            color: Colors.white,
          ),
          const SizedBox(height: 15),
          const Text(
            'ตู้ที่เลือก',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            widget.lockerName,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelectionCard() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.schedule_rounded, color: Colors.deepPurple, size: 28),
              SizedBox(width: 10),
              Text(
                'กำหนดระยะเวลา',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildPickerSection(
            'ชั่วโมง',
            Icons.access_time_rounded,
            Colors.blue,
          ),
          const SizedBox(height: 10),
          _buildHourPicker(),
          const SizedBox(height: 25),
          _buildPickerSection(
            'นาที',
            Icons.timer_rounded,
            Colors.orange,
          ),
          const SizedBox(height: 10),
          _buildMinutePicker(),
        ],
      ),
    );
  }

  Widget _buildPickerSection(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildHourPicker() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.shade200, width: 2),
      ),
      child: CupertinoPicker(
        itemExtent: 45,
        scrollController: FixedExtentScrollController(initialItem: hour),
        onSelectedItemChanged: (int index) {
          setState(() => hour = index);
        },
        children: List.generate(
          25,
              (index) => Center(
            child: Text(
              '$index ชม.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMinutePicker() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.orange.shade200, width: 2),
      ),
      child: CupertinoPicker(
        itemExtent: 45,
        scrollController: FixedExtentScrollController(initialItem: minute),
        onSelectedItemChanged: (int index) {
          setState(() => minute = index);
        },
        children: List.generate(
          60,
              (index) => Center(
            child: Text(
              '$index นาที',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.orange.shade700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade400, Colors.purple.shade600],
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
      padding: const EdgeInsets.all(25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.timelapse_rounded,
            size: 40,
            color: Colors.white,
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ระยะเวลาทั้งหมด',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                hour == 0 && minute == 0
                    ? 'โปรดเลือกเวลา'
                    : '${hour > 0 ? "$hour ชม. " : ""}${minute > 0 ? "$minute นาที" : ""}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          if (hour == 0 && minute == 0) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('โปรดเลือกเวลาที่จะใช้ Locker'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          } else {
            _handleSubmitTime();
          }
        },
        icon: const Icon(Icons.check_circle_rounded, size: 28),
        label: const Text(
          'ยืนยันการจอง',
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

  Future<void> _handleSubmitTime() async {
    DateTime now = DateTime.now();
    DateTime futureTime = now.add(Duration(hours: hour, minutes: minute));
    setState(() => _isLoading = true);
    String cleanValue = widget.TelOrEmail.replaceAll(' ', '');
    try {
      final result = await _apiService.bookLocker(
        cleanValue.contains('@'),
        cleanValue,
        widget.lockerId,
        widget.OTP,
        futureTime,
        widget.userId,
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (result['success']) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("เปิดใช้ตู้สำเร็จ"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาด: ${result['error']}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาด: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}