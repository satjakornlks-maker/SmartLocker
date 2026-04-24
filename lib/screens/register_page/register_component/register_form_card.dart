import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/screens/register_page/register_component/register_styled_text_field.dart';
import 'package:untitled/theme/theme.dart';

import '../../../../validators/validator.dart';

class RegisterFormCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController telController;
  final TextEditingController emailController;
  final TextEditingController reasonController;
  const RegisterFormCard({
    super.key,
    required this.nameController,
    required this.telController,
    required this.emailController,
    required this.reasonController,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RegisterStyledTextField(
          controller: nameController,
          label: l.fullName,
          icon: Icons.badge_rounded,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l.pleaseEnterName;
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.xl),

        RegisterStyledTextField(
          controller: telController,
          label: l.phoneNumber,
          icon: Icons.phone_rounded,
          keyboardType: TextInputType.phone,
          validator: Validators.validateTel,
        ),
        const SizedBox(height: AppSpacing.xl),

        RegisterStyledTextField(
          controller: emailController,
          label: l.email,
          icon: Icons.email_rounded,
          keyboardType: TextInputType.emailAddress,
          validator: Validators.validateEmail,
        ),
        const SizedBox(height: AppSpacing.xl),

        RegisterStyledTextField(
          controller: reasonController,
          label: l.reasonForBooking,
          icon: Icons.description_rounded,
          maxLines: 4,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l.pleaseEnterReason;
            }
            return null;
          },
        ),
      ],
    );
  }
}
