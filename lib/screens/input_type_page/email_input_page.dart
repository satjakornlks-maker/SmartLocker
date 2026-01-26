import 'package:flutter/material.dart';
import 'package:untitled/screens/common/otp_page.dart';
import 'package:untitled/screens/input_type_page/input_type_page.dart';
import 'package:untitled/services/api_service.dart';

import '../common/success_page.dart';

class EmailInputPage extends StatefulWidget {
  final String selectedLocker;
  final String lockerName;
  final FromPage from;

  const EmailInputPage({
    super.key,
    required this.selectedLocker,
    required this.lockerName,
    required this.from,
  });

  @override
  State<EmailInputPage> createState() => _EmailInputPageState();
}

class _EmailInputPageState extends State<EmailInputPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isLoading = false; // Add loading state

  @override
  void dispose() {
    _emailController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _onConfirm() async {
    if (_isValidEmail) {
      setState(() => _isLoading = true);
      String cleanValue = _emailController.text.trim();
      try {
        final result = await _apiService.sendOTP(
          cleanValue,
          true, // isEmail = true
          widget.selectedLocker,
        );
        if (!mounted) return;
        setState(() => _isLoading = false);
        if (result['success']) {


          // Navigate to OTP page with proper parameters
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPPage(
                telOrEmail: _emailController.text,
                from: widget.from,
                lockerId: widget.selectedLocker,
                lockerName: widget.lockerName,
                userId: result['data']['userId'],
                refCode: result['data']['refercode'],
              )
            ),
          );
        } else if (result['success'] && widget.from == FromPage.resetPassword){
          print('resetPassword');
          Navigator.push(context, MaterialPageRoute(builder: (context) => SuccessPage()));
        }else{
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

  bool get _isValidEmail {
    final email = _emailController.text.trim();
    if (email.isEmpty) return false;

    // Basic email validation
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
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
                const SizedBox(height: 20),
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: Column(
                            children: [
                              const SizedBox(height: 40),

                              // Title
                              const Text(
                                'กรุณากรอกอีเมล',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),

                              const SizedBox(height: 40),

                              // Email input field
                              _buildEmailInput(),

                              const SizedBox(height: 40),

                              // Confirm button
                              _buildConfirmButton(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Loading overlay
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
              onPressed: _isLoading ? null : () => Navigator.pop(context), // Disable when loading
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

  Widget _buildEmailInput() {
    return AbsorbPointer(
      absorbing: _isLoading, // Disable input when loading
      child: Opacity(
        opacity: _isLoading ? 0.5 : 1.0, // Reduce opacity when loading
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _emailController,
            focusNode: _focusNode,
            keyboardType: TextInputType.emailAddress,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: 'example@email.com',
              hintStyle: TextStyle(
                fontSize: 24,
                color: Colors.grey.shade400,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 30,
              ),
            ),
            onChanged: (value) {
              setState(() {}); // Rebuild to update button state
            },
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 300),
      child: ElevatedButton(
        onPressed: (_isValidEmail && !_isLoading) ? _onConfirm : null, // Disable when loading
        style: ElevatedButton.styleFrom(
          backgroundColor: (_isValidEmail && !_isLoading) ? Colors.green : Colors.grey.shade300,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: (_isValidEmail && !_isLoading) ? 3 : 0,
          disabledBackgroundColor: Colors.grey.shade300,
          disabledForegroundColor: Colors.grey.shade500,
        ),
        child: _isLoading
            ? const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check,
              color: (_isValidEmail && !_isLoading) ? Colors.white : Colors.grey.shade500,
            ),
            const SizedBox(width: 8),
            Text(
              'ยืนยัน',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: (_isValidEmail && !_isLoading) ? Colors.white : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}