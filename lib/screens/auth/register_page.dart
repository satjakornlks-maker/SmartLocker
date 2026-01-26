import 'package:flutter/material.dart';
import '../../validators/validator.dart';
import '../common/notice_page.dart';
import '../../services/api_service.dart';

class RegisterPage extends StatefulWidget {
  final String selectedLocker;
  const RegisterPage({super.key, required this.selectedLocker});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _telController = TextEditingController();
  final _emailController = TextEditingController();
  final _reasonController = TextEditingController();

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
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
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
      margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
      padding: const EdgeInsets.all(20),

      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
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
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800), // Set max width here
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    'สมัครสมาชิก',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'กรอกข้อมูลเพื่อสมัครใช้งานตู้ประจำ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 40),

                  _buildFormCard(),

                  const SizedBox(height: 30),

                  _buildConfirmButton(),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildStyledTextField(
            controller: _nameController,
            label: 'ชื่อ-นามสกุล',
            icon: Icons.badge_rounded,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'กรุณากรอกชื่อ';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          _buildStyledTextField(
            controller: _telController,
            label: 'เบอร์โทรศัพท์',
            icon: Icons.phone_rounded,
            keyboardType: TextInputType.phone,
            validator: Validators.validateTel,
          ),
          const SizedBox(height: 20),

          _buildStyledTextField(
            controller: _emailController,
            label: 'อีเมล',
            icon: Icons.email_rounded,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
          ),
          const SizedBox(height: 20),

          _buildStyledTextField(
            controller: _reasonController,
            label: 'เหตุผลในการจอง',
            icon: Icons.description_rounded,
            maxLines: 4,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'กรุณากรอกเหตุผล';
              }
              return null;
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
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(

      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 16,
        ),
        prefixIcon: Icon(icon, color: Colors.grey.shade600, size: 22),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurple.shade400, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: double.infinity),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _handleUnlockMember();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 3,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.check_circle_rounded, size: 24),
            SizedBox(width: 10),
            Text(
              'ส่งคำร้อง',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleUnlockMember() async {
    setState(() => _isLoading = true);
    try {
      final result = await _apiService.regisAccount(
        _nameController.text,
        _telController.text,
        _emailController.text,
        _reasonController.text,
        widget.selectedLocker,
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (result['success']) {
        ScaffoldMessenger.of(context).clearSnackBars();
        _showSnackBar('สมัครสมาชิกเสร็จสิ้น', Colors.green);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NoticePage()),
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
    _nameController.dispose();
    _telController.dispose();
    _emailController.dispose();
    _reasonController.dispose();
    super.dispose();
  }
}