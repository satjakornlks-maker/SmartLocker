import 'package:flutter/material.dart';
import 'package:untitled/MemberLockerSelectPage.dart';
import 'package:untitled/componants/BuildConfirmButton.dart';
import 'package:untitled/validators/validator.dart';
import 'NoticePage.dart';
import 'componants/BuildFromField.dart';
import 'services/api_service.dart';

class RegisterPage extends StatefulWidget {
  final String selectedLocker;
  const RegisterPage({super.key, required this.selectedLocker});

  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
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
            'สมัครสมาชิก',
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
          child: Column(
            children: [
              _buildInfoCard(),
              const SizedBox(height: 20),
              _buildFormCard(),
              const SizedBox(height: 20),
              _buildConfirmButton(),
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
      child: Column(
        children: [
          const Icon(
            Icons.card_membership_rounded,
            size: 60,
            color: Colors.white,
          ),
          const SizedBox(height: 15),
          const Text(
            'สมัครสมาชิกใช้งานประจำ',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'กรอกข้อมูลเพื่อสมัครใช้งานตู้ประจำ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
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
              Icon(Icons.edit_note_rounded, color: Colors.deepPurple, size: 28),
              SizedBox(width: 12),
              Text(
                'ข้อมูลผู้สมัคร',
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
            controller: _nameController,
            label: 'ชื่อ-นามสกุล',
            icon: Icons.person_rounded,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'กรุณากรอกชื่อ';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          _buildStyledTextField(
            controller: _telController,
            label: 'เบอร์โทรศัพท์',
            icon: Icons.phone_rounded,
            keyboardType: TextInputType.phone,
            validator: Validators.validateTel,
          ),
          const SizedBox(height: 15),
          _buildStyledTextField(
            controller: _emailController,
            label: 'อีเมล',
            icon: Icons.email_rounded,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
          ),
          const SizedBox(height: 15),
          _buildStyledTextField(
            controller: _reasonController,
            label: 'เหตุผลในจอง',
            icon: Icons.description_rounded,
            maxLines: 3,
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
          if (_formKey.currentState!.validate()) {
            _handleUnlockMember();
          }
        },
        icon: const Icon(Icons.how_to_reg_rounded, size: 28),
        label: const Text(
          'ส่งคำร้อง',
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