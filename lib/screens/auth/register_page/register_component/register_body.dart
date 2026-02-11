import 'package:flutter/material.dart';
import 'package:untitled/screens/auth/register_page/register_component/register_confirm_button.dart';
import 'package:untitled/screens/auth/register_page/register_component/register_form_card.dart';

class RegisterBody extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController telController;
  final TextEditingController emailController;
  final TextEditingController reasonController;
  final GlobalKey<FormState> formKey;
  final VoidCallback handleUnlockMember;
  const RegisterBody({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.telController,
    required this.emailController,
    required this.reasonController,
    required this.handleUnlockMember,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 800,
            ), // Set max width here
            child: Form(
              key: formKey,
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
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 40),

                  RegisterFormCard(
                    nameController: nameController,
                    telController: telController,
                    emailController: emailController,
                    reasonController: reasonController,
                  ),

                  const SizedBox(height: 30),

                  RegisterConfirmButton(
                    handleUnlockMember: handleUnlockMember,
                    formKey: formKey,
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
