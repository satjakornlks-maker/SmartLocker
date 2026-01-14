import 'package:flutter/material.dart';
import '../auth/forgot_password_page.dart';
import '../common/overtime_page.dart';
import '../../services/api_service.dart';

class FillPinPage extends StatefulWidget {
  final String lockerId;
  final String lockerName;
  const FillPinPage({super.key, required this.lockerId, required this.lockerName});
  @override
  State<FillPinPage> createState() => _FillPinPage();
}

class _FillPinPage extends State<FillPinPage> {
  bool _isLoading = false;
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  final _PINController = TextEditingController();

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
            'ใส่รหัส PIN',
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
        child: Form(
          key: _formKey,
          child: Container(
            margin: MediaQuery.of(context).size.width > 600
                ? const EdgeInsets.fromLTRB(300, 0, 300, 0)
                : EdgeInsets.zero,
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildLockerCard(),
                const SizedBox(height: 25),
                _buildPINCard(),
                const SizedBox(height: 25),
                _buildConfirmButton(),
                const SizedBox(height: 15),
                _buildForgotPasswordButton(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLockerCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade400, Colors.orange.shade600],
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
            Icons.lock_open_rounded,
            size: 30,
            color: Colors.white,
          ),
          const SizedBox(height: 15),
          Text(
            'ตู้ที่เลือก : ${widget.lockerName}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPINCard() {
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
              Icon(Icons.pin_rounded, color: Colors.deepPurple, size: 28),
              SizedBox(width: 12),
              Text(
                'กรอกรหัส PIN',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _PINController,
            keyboardType: TextInputType.number,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'กรุณากรอก PIN';
              }
              return null;
            },
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 8,
            ),
            decoration: InputDecoration(
              labelText: 'PIN (OTP)',
              hintText: '••••••',
              prefixIcon: const Icon(Icons.lock_rounded, color: Colors.deepPurple),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, color: Colors.blue.shade700, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'ใช้รหัส PIN ที่ได้รับจาก SMS หรือ Email',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue.shade700,
                    ),
                  ),
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
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _handlePINSubmit();
          }
        },
        icon: const Icon(Icons.check_circle_rounded, size: 28),
        label: const Text(
          'ยืนยัน',
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

  Widget _buildForgotPasswordButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ForgotPasswordPage(lockerId: widget.lockerId),
            ),
          );
        },
        icon: const Icon(Icons.help_outline_rounded, size: 24),
        label: const Text(
          'ลืมรหัสผ่าน',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white, width: 2),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  Future<void> _handlePINSubmit() async {
    setState(() => _isLoading = true);
    try {
      final result = await _apiService.handleFillPIN(
        _PINController.text,
        widget.lockerId,
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (result['success']) {
        ScaffoldMessenger.of(context).clearSnackBars();
        _showSnackBar('ยืนยัน PIN สำเร็จ', Colors.green);
        if (result['data'] != null && result['data']['overtime'] != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OvertimePage(
                day: result['data']['overtime']['days'].toString(),
                hour: result['data']['overtime']['hours'].toString(),
                minute: result['data']['overtime']['minutes'].toString(),
                second: result['data']['overtime']['seconds'].toString(),
                lockerId: widget.lockerId,
              ),
            ),
          );
        } else {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        _showSnackBar('เกิดข้อผิดพลาด: ${result['error']}', Colors.red);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).clearSnackBars();
      _showSnackBar('เกิดข้อผิดพลาด: $e', Colors.red);
    }
  }

  @override
  void dispose() {
    _PINController.dispose();
    super.dispose();
  }
}
