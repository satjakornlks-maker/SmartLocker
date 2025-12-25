import 'package:flutter/material.dart';
import 'package:untitled/ForgotPasswordPage.dart';
import 'package:untitled/componants/BuildConfirmButton.dart';
import 'componants/BuildFromField.dart';
import 'services/api_service.dart';
import 'validators/validator.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPage();
}

class _ResetPasswordPage extends State<ResetPasswordPage> {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  final _OldPINController = TextEditingController();
  final _NewPINController = TextEditingController();
  final _EnsurePINController = TextEditingController();
  final _TelController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

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
            'เปลี่ยนรหัสผ่าน',
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
          key: _formkey,
          child: Column(
            children: [
              _buildInfoCard(),
              const SizedBox(height: 20),
              _buildFormCard(),
              const SizedBox(height: 20),
              _buildConfirmButton(),
              const SizedBox(height: 15),
              _buildForgotPasswordButton(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
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
      child: const Column(
        children: [
          Icon(
            Icons.security_rounded,
            size: 60,
            color: Colors.white,
          ),
          SizedBox(height: 15),
          Text(
            'เปลี่ยนรหัสผ่าน',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'สำหรับสมาชิกใช้งานประจำ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
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
              Icon(Icons.vpn_key_rounded, color: Colors.deepPurple, size: 28),
              SizedBox(width: 12),
              Text(
                'กรอกข้อมูล',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildStyledTextField(
            controller: _TelController,
            label: 'เบอร์โทรศัพท์',
            icon: Icons.phone_rounded,
            keyboardType: TextInputType.phone,
            validator: (value) => Validators.validateTel(value),
          ),
          const SizedBox(height: 15),
          _buildStyledTextField(
            controller: _OldPINController,
            label: 'รหัส PIN เดิม',
            icon: Icons.lock_outline_rounded,
            keyboardType: TextInputType.number,
            obscureText: true,
            validator: (value) => Validators.validateOTP(value),
          ),
          const SizedBox(height: 15),
          const Divider(height: 30),
          const SizedBox(height: 5),
          _buildStyledTextField(
            controller: _NewPINController,
            label: 'รหัส PIN ใหม่',
            icon: Icons.lock_rounded,
            keyboardType: TextInputType.number,
            obscureText: true,
            validator: (value) => Validators.validateOTP(value),
          ),
          const SizedBox(height: 15),
          _buildStyledTextField(
            controller: _EnsurePINController,
            label: 'ยืนยันรหัส PIN ใหม่',
            icon: Icons.lock_reset_rounded,
            keyboardType: TextInputType.number,
            obscureText: true,
            validator: (value) {
              final otpError = Validators.validateOTP(value);
              if (otpError != null) return otpError;
              if (value != _NewPINController.text) {
                return 'รหัส PIN ไม่ตรงกัน';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.amber.shade700, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'รหัส PIN ต้องตรงกันทั้งสองช่อง',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.amber.shade900,
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

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: obscureText
          ? const TextStyle(letterSpacing: 4, fontWeight: FontWeight.bold)
          : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
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
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          _handleResetPassword();
        },
        icon: const Icon(Icons.check_circle_rounded, size: 28),
        label: const Text(
          'เปลี่ยนรหัสผ่าน',
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
              builder: (context) => const ForgotPasswordPage(),
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

  Future<void> _handleResetPassword() async {
    if (_formkey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final result = await _apiService.handleResetPassword(
          _OldPINController.text,
          _NewPINController.text,
          _TelController.text,
        );
        if (!mounted) return;
        setState(() => _isLoading = false);
        if (result['success']) {
          ScaffoldMessenger.of(context).clearSnackBars();
          _showSnackBar('เปลี่ยนรหัสผ่านเสร็จสิ้น', Colors.green);
          Navigator.of(context).popUntil((route) => route.isFirst);
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
  }

  @override
  void dispose() {
    _OldPINController.dispose();
    _NewPINController.dispose();
    _EnsurePINController.dispose();
    _TelController.dispose();
    super.dispose();
  }
}