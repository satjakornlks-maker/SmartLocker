import 'package:flutter/material.dart';
import 'chose_time_page.dart';
import '../../validators/validator.dart';
import '../../services/api_service.dart';

class OTPPage extends StatefulWidget {
  final String lockerId;
  final String lockerName;
  const OTPPage({super.key, required this.lockerId, required this.lockerName});
  @override
  State<OTPPage> createState() => _OTPPage();
}

class _OTPPage extends State<OTPPage> {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  bool _otpSent = false;
  final _OTPController = TextEditingController();
  final _TelOrEMailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double fontsize = 20;
  String? refCode;
  int? userId;

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
            'ลงทะเบียน',
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
                _buildLockerCard(),
                const SizedBox(height: 20),
                _buildFormCard(),
                const SizedBox(height: 20),
                if (refCode != null) _buildRefCodeCard(),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'กรอกข้อมูล',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          _buildStyledTextField(
            controller: _TelOrEMailController,
            label: 'เบอร์โทรศัพท์หรืออีเมล',
            icon: Icons.contact_phone_rounded,
            validator: (value) => Validators.validateEmailOrPhone(value),
          ),
          const SizedBox(height: 15),
          _buildActionButton(
            label: 'ส่ง OTP',
            icon: Icons.send_rounded,
            color: Colors.blue,
            onPressed: _handleSendOTPValidation,
          ),
          const SizedBox(height: 20),
          _buildStyledTextField(
            controller: _OTPController,
            label: 'รหัส OTP',
            icon: Icons.lock_rounded,
            keyboardType: TextInputType.number,
            validator: Validators.validateOTP,
          ),
          const SizedBox(height: 20),
          _buildActionButton(
            label: 'ยืนยัน',
            icon: Icons.check_circle_rounded,
            color: _otpSent ? Colors.green : Colors.grey,
            onPressed: _otpSent
                ? () {
                    if (_formKey.currentState!.validate()) {
                      _handleSubmitOTP();
                    }
                  }
                : () {
                    _showSnackBar('กรุณาส่ง OTP ก่อน', Colors.orange);
                  },
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
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: (value) {
        if (controller == _TelOrEMailController && _otpSent) {
          setState(() {
            _otpSent = false;
            refCode = null;
          });
        }
      },
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

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    final bool isDisabled = (label == 'ยืนยัน' && !_otpSent);

    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 24),
        label: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: isDisabled ? 0 : 5,
        ),
      ),
    );
  }

  Widget _buildRefCodeCard() {
    return Container(
      width: double.infinity,
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
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            'รหัสอ้างอิง',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            refCode!,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  void _handleSendOTPValidation() {
    String? validatorError = Validators.validateEmailOrPhone(
      _TelOrEMailController.text,
    );
    if (validatorError != null) {
      _showSnackBar(validatorError, Colors.red);
      return;
    }
    _handleSendOTP();
  }

  Future<void> _handleSendOTP() async {
    setState(() => _isLoading = true);
    String cleanValue = _TelOrEMailController.text.replaceAll(' ', '');
    try {
      final result = await _apiService.sendOTP(
        cleanValue,
        cleanValue.contains('@'),
        widget.lockerId,
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (result['success']) {
        ScaffoldMessenger.of(context).clearSnackBars();
        _showSnackBar('ส่ง OTP สำเร็จ', Colors.green);
        setState(() {
          refCode = result['data']['refercode'] ?? '';
          userId = result['data']['userId'] ?? '';
          _otpSent = true;
        });
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

  Future<void> _handleSubmitOTP() async {
    setState(() => _isLoading = true);
    String cleanValue = _TelOrEMailController.text.replaceAll(' ', '');
    try {
      final result = await _apiService.handleSubmitOTP(
        cleanValue,
        _OTPController.text,
        cleanValue.contains('@'),
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (result['success']) {
        ScaffoldMessenger.of(context).clearSnackBars();
        _showSnackBar('ยืนยัน OTP สำเร็จ', Colors.green);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChoseTimePage(
              lockerId: widget.lockerId,
              TelOrEmail: _TelOrEMailController.text,
              OTP: _OTPController.text,
              lockerName: widget.lockerName,
              userId: userId!,
            ),
          ),
        );
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
    _OTPController.dispose();
    _TelOrEMailController.dispose();
    super.dispose();
  }
}
