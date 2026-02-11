import 'package:flutter/material.dart';
import 'package:untitled/screens/auth/register_page/register_component/register_styled_text_field.dart';

import '../../../../validators/validator.dart';

class RegisterFormCard extends StatelessWidget{
  final TextEditingController nameController;
  final TextEditingController telController;
  final TextEditingController emailController;
  final TextEditingController reasonController;
  const RegisterFormCard({super.key, required this.nameController, required this.telController, required this.emailController, required this.reasonController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RegisterStyledTextField(
          controller: nameController,
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

        RegisterStyledTextField(
          controller: telController,
          label: 'เบอร์โทรศัพท์',
          icon: Icons.phone_rounded,
          keyboardType: TextInputType.phone,
          validator: Validators.validateTel,
        ),
        const SizedBox(height: 20),

        RegisterStyledTextField(
          controller: emailController,
          label: 'อีเมล',
          icon: Icons.email_rounded,
          keyboardType: TextInputType.emailAddress,
          validator: Validators.validateEmail,
        ),
        const SizedBox(height: 20),

        RegisterStyledTextField(
          controller: reasonController,
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
    );
  }
}