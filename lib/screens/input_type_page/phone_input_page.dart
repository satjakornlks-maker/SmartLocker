import 'package:flutter/material.dart';
import 'package:untitled/screens/common/otp_page.dart';
import 'package:untitled/screens/common/success_page.dart';
import 'package:untitled/screens/input_type_page/input_type_page.dart';
import 'package:untitled/services/api_service.dart';

class PhoneInputPage extends StatefulWidget {
  final String selectedLocker;
  final String lockerName;
  final FromPage from;

  const PhoneInputPage({
    super.key,
    required this.selectedLocker,
    required this.lockerName,
    required this.from,
  });

  @override
  State<PhoneInputPage> createState() => _PhoneInputPageState();
}

class _PhoneInputPageState extends State<PhoneInputPage> {
  final ApiService _apiService = ApiService();
  String phoneNumber = '';
  final int maxLength = 10;
  bool _isLoading = false; // Add loading state

  void _onNumberPress(String number) {
    if (phoneNumber.length < maxLength) {
      setState(() {
        phoneNumber += number;
      });
    }
  }

  void _onBackspace() {
    if (phoneNumber.isNotEmpty) {
      setState(() {
        phoneNumber = phoneNumber.substring(0, phoneNumber.length - 1);
      });
    }
  }

  Future<void> _onConfirm() async {
    if (phoneNumber.length == maxLength) {
      setState(() => _isLoading = true);
      try {
        print(phoneNumber);
        final result = await _apiService.sendOTP(
          phoneNumber,
          phoneNumber.contains('@'),
          widget.selectedLocker,
        );
        if (!mounted) return;
        setState(() => _isLoading = false);
        if (result['success']) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OTPPage(
                    telOrEmail: phoneNumber.toString(),
                    from: widget.from,
                    lockerId: widget.selectedLocker,
                    lockerName: widget.lockerName,
                    userId: result['data']['userId'],
                    refCode: result['data']['refercode'],
                  ),
            ),
          );
        }
        else if (result['success'] && widget.from == FromPage.resetPassword){
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

  bool get _isComplete => phoneNumber.length == maxLength;

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
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Column(
                            children: [
                              const SizedBox(height: 40),

                              // Title
                              const Text(
                                'กรุณากรอกเบอร์โทรศัพท์',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),

                              const SizedBox(height: 40),

                              // Phone number display
                              _buildPhoneDisplay(),

                              const SizedBox(height: 50),

                              // Numpad
                              _buildNumpad(),

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
            margin: const EdgeInsets.fromLTRB(50, 0, 0, 0),
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

  Widget _buildPhoneDisplay() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400, minHeight: 80),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Text(
          phoneNumber.isEmpty ? '' : phoneNumber,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w500,
            letterSpacing: 3,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildNumpad() {
    return AbsorbPointer(
      absorbing: _isLoading, // Disable numpad when loading
      child: Opacity(
        opacity: _isLoading ? 0.5 : 1.0, // Reduce opacity when loading
        child: Column(
          children: [
            // Row 1: 1, 2, 3
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNumButton('1'),
                const SizedBox(width: 20),
                _buildNumButton('2'),
                const SizedBox(width: 20),
                _buildNumButton('3'),
              ],
            ),
            const SizedBox(height: 20),

            // Row 2: 4, 5, 6
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNumButton('4'),
                const SizedBox(width: 20),
                _buildNumButton('5'),
                const SizedBox(width: 20),
                _buildNumButton('6'),
              ],
            ),
            const SizedBox(height: 20),

            // Row 3: 7, 8, 9
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNumButton('7'),
                const SizedBox(width: 20),
                _buildNumButton('8'),
                const SizedBox(width: 20),
                _buildNumButton('9'),
              ],
            ),
            const SizedBox(height: 20),

            // Row 4: 0, backspace
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 70),
                const SizedBox(width: 20),
                _buildNumButton('0'),
                const SizedBox(width: 20),
                _buildBackspaceButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumButton(String number) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onNumberPress(number),
          borderRadius: BorderRadius.circular(35),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _onBackspace,
          borderRadius: BorderRadius.circular(35),
          child: const Center(
            child: Icon(
              Icons.backspace_outlined,
              size: 28,
              color: Colors.black87,
            ),
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
        onPressed: (_isComplete && !_isLoading) ? _onConfirm : null, // Disable when loading
        style: ElevatedButton.styleFrom(
          backgroundColor: (_isComplete && !_isLoading) ? Colors.green : Colors.grey.shade300,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: (_isComplete && !_isLoading) ? 3 : 0,
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
              color: (_isComplete && !_isLoading) ? Colors.white : Colors.grey.shade500,
            ),
            const SizedBox(width: 8),
            Text(
              'ยืนยัน',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: (_isComplete && !_isLoading) ? Colors.white : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}