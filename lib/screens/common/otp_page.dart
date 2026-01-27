import 'package:flutter/material.dart';
import 'package:untitled/screens/common/success_page.dart';
import 'package:untitled/screens/input_type_page/input_type_page.dart';
import '../../services/api_service.dart';

class OTPPage extends StatefulWidget {
  final FromPage from;
  final String? lockerId;
  final String? lockerName;
  final String? telOrEmail;
  final String? refCode; // Passed from previous page
  final int? userId; // Passed from previous page

  const OTPPage({
    super.key,
    required this.from,
    this.lockerId,
    this.lockerName,
    this.telOrEmail,
    this.refCode,
    this.userId,
  });

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final ApiService _apiService = ApiService();
  late int resetPass;
  bool _isLoading = false;
  // OTP input controllers - 6 digits
  final List<String> _otpDigits = List.filled(6, '');
  int _currentIndex = 0;

  // State variables
  String? refCode;
  int? userId;

  @override
  void initState() {
    super.initState();
    resetPass =3;
    // Initialize from passed parameters (OTP already sent by previous page)
    refCode = widget.refCode;
    userId = widget.userId;
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
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 20),
                _buildHeader(),
                Expanded(child: _buildBody()),
              ],
            ),
            if (_isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.deepPurple,
                    ),
                  ),
                ),
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
              onPressed: resetPass == 1
                  ? () => setState(() {
                      resetPass = 3;
                    })
                  : () => Navigator.pop(context), // Disable when loading
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildTitle(),
            const SizedBox(height: 10),
            if (widget.from != FromPage.unlock) _buildPhoneDisplay(),

            const SizedBox(height: 25),
            _buildOTPInputBoxes(),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: .center,
              children: [
                resetPass == 1
                    ? const SizedBox.shrink()
                    : widget.from != FromPage.unlock
                    ? _buildRefCodeAndResend()
                    : _buildForgotPassword(),
                SizedBox(width: 10),
                if (widget.from == FromPage.unlock && resetPass == 3) _buildResetPassword(),
              ],
            ),
            const SizedBox(height: 50),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 350),
              child: Column(
                children: [
                  _buildNumericKeypad(),
                  const SizedBox(height: 30),
                  _buildConfirmButton(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      resetPass == 2
          ? 'กรุณากรอกรหัสผ่านใหม่ที่ท่านต้องการเปลี่ยน'
          : resetPass == 1
          ? 'เปลี่ยนรหัสผ่าน กรุณากรอก OTP ที่ถูกต้อง'
          : 'กรุณากรอกรหัส OTP',
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildPhoneDisplay() {
    return Row(
      mainAxisAlignment: .center,
      children: [
        Text(
          'ส่งรหัสไปที่ ${widget.telOrEmail ?? ""} ',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        Text(
          'สำหรับตู้ ${widget.lockerName ?? ""}',
          style: TextStyle(fontSize: 18, color: Colors.blue),
        ),
      ],
    );
  }

  Widget _buildOTPInputBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        return Container(
          width: 50,
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 2),
          ),
          child: Center(
            child: Text(
              _otpDigits[index].isNotEmpty ? '*' : '',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildRefCodeAndResend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'REF CODE',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              refCode ?? 'XXXXXX',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(width: 80),
        TextButton.icon(
          onPressed: _handleResendOTP,
          icon: const Icon(Icons.refresh, color: Colors.orange, size: 20),
          label: const Text(
            'ส่งรหัสใหม่',
            style: TextStyle(
              color: Colors.orange,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildNumericKeypad() {
    return Column(
      children: [
        _buildKeypadRow(['1', '2', '3']),
        const SizedBox(height: 15),
        _buildKeypadRow(['4', '5', '6']),
        const SizedBox(height: 15),
        _buildKeypadRow(['7', '8', '9']),
        const SizedBox(height: 15),
        _buildKeypadRow(['0', 'delete']),
      ],
    );
  }

  Widget _buildKeypadRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys.map((key) {
        if (key == 'delete') {
          return _buildKeypadButton(
            child: const Icon(Icons.backspace_outlined, size: 24),
            onTap: _handleDelete,
          );
        } else if (key == '0') {
          return Row(
            children: [
              const SizedBox(width: 100), // Empty space for alignment
              _buildKeypadButton(
                child: Text(
                  key,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () => _handleNumberTap(key),
              ),
            ],
          );
        } else {
          return _buildKeypadButton(
            child: Text(
              key,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            onTap: () => _handleNumberTap(key),
          );
        }
      }).toList(),
    );
  }

  Widget _buildKeypadButton({
    required Widget child,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }

  Widget _buildConfirmButton() {
    final bool isComplete = _otpDigits.every((digit) => digit.isNotEmpty);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isComplete ? _handleSubmitOTP : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isComplete ? Colors.green : Colors.grey.shade200,
          foregroundColor: isComplete ? Colors.white : Colors.grey.shade400,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check,
              size: 20,
              color: isComplete ? Colors.white : Colors.grey.shade400,
            ),
            const SizedBox(width: 8),
            const Text(
              'ยืนยัน',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNumberTap(String number) {
    if (_currentIndex < 6) {
      setState(() {
        _otpDigits[_currentIndex] = number;
        _currentIndex++;
      });
    }
  }

  void _handleDelete() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _otpDigits[_currentIndex] = '';
      });
    }
  }

  Future<void> _handleSendOTP() async {
    if (widget.lockerId == null) {
      _showSnackBar('ไม่มีตู้ว่าง', Colors.red);
      return;
    }

    // Prevent duplicate calls if already loading
    // if (_isLoading) {
    //   print('Already sending OTP, ignoring duplicate call');
    //   return;
    // }

    setState(() => _isLoading = true);
    String cleanValue = widget.telOrEmail!.replaceAll(' ', '');
    try {
      final result = await _apiService.sendOTP(
        cleanValue,
        cleanValue.contains('@'),
        widget.lockerId!,
        widget.from == FromPage.visitor ? true : false,
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (result['success']) {
        ScaffoldMessenger.of(context).clearSnackBars();
        _showSnackBar('ส่ง OTP สำเร็จ', Colors.green);
        setState(() {
          refCode = result['data']['refercode'] ?? '';
          userId = result['data']['userId'] ?? '';
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

  Future<void> _handleResendOTP() async {
    // Clear current OTP input
    setState(() {
      _otpDigits.fillRange(0, 6, '');
      _currentIndex = 0;
    });

    await _handleSendOTP();
  }

  Future<void> _handleSubmitOTP() async {
    String otpCode = _otpDigits.join('');
    if (otpCode.length != 6) {
      _showSnackBar('กรุณากรอก OTP ให้ครบ 6 หลัก', Colors.orange);
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.from == FromPage.unlock) {
        await _unlockLocker(otpCode);
      } else if (widget.from == FromPage.resetPassword) {
        try {
          final result = await _apiService.handleCheckOTP(
            widget.lockerId!,
            otpCode,
          );
          setState(() {
            _isLoading = false;
          });
          if (result['success']) {
            resetPass = 2;
            userId = result['data']['userID'];
            _otpDigits.clear();
          } else {
            _showSnackBar("PIN ไม่ตรงกับที่ลงทะเบียนไว้", Colors.red);
          }
        } catch (e) {
          if (!mounted) return;
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).clearSnackBars();
          _showSnackBar('เกิดข้อผิดพลาด: $e', Colors.red);
        }
      } else if (resetPass == 2) {
        //API to reset password
        try {
          final result = await _apiService.handleResetPassword(
            userId!,
            otpCode,
          );
          setState(() {
            _isLoading = false;
          });
          if (!mounted) return;
          if (result['success']) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OTPPage(from: FromPage.unlock),
              ),
            );
          } else {
            print(result['error']);
          }
        } catch (e) {
          if (!mounted) return;
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).clearSnackBars();
          _showSnackBar('เกิดข้อผิดพลาด: $e', Colors.red);
        }
      } else {
        String cleanValue = widget.telOrEmail!.replaceAll(' ', '');
        final result = await _apiService.handleSubmitOTP(
          cleanValue,
          otpCode,
          cleanValue.contains('@'),
        );

        if (!mounted) return;

        if (result['success']) {
          await _bookLocker(userId!, otpCode);
        } else {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).clearSnackBars();
          _showSnackBar('เกิดข้อผิดพลาด: ${result['error']}', Colors.red);
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).clearSnackBars();
      _showSnackBar('เกิดข้อผิดพลาด: $e', Colors.red);
    }
  }

  Future<void> _bookLocker(int userId, String otp) async {
    DateTime now = DateTime.now();

    // Don't set loading here since it's already true from _handleSubmitOTP
    String cleanValue = widget.telOrEmail!.replaceAll(' ', '');
    try {
      final result = await _apiService.bookLocker(
        cleanValue.contains('@'),
        cleanValue,
        widget.lockerId!,
        otp,
        now,
        userId,
        widget.from != FromPage.visitor ? false : true,
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (result['success']) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SuccessPage()),
        );
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

  Future<void> _unlockLocker(String otp) async {
    // Loading is already set to true from _handleSubmitOTP
    try {
      final result = await _apiService.handleFillPIN(otp, widget.lockerId!);
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (result['success']) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SuccessPage()),
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

  Widget _buildResetPassword() {
    return TextButton(
      onPressed: () {
        setState(() {
          resetPass = 1;
        });
        _otpDigits.clear();
      },
      child: Text(
        'เปลี่ยนรหัสผ่าน(เฉพาะผู้ใช้ประจำ)',
        style: TextStyle(decoration: TextDecoration.underline),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return TextButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InputTypePage(
            from: FromPage.forgetPassword,
            selectedLocker: widget.lockerId,
            lockerName: widget.lockerName,
          ),
        ),
      ),
      child: Text(
        'ลืมรหัสผ่าน',
        style: TextStyle(decoration: TextDecoration.underline),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
