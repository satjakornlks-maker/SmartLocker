import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/screens/register_page/register_component/register_confirm_button.dart';
import 'package:untitled/screens/register_page/register_component/register_form_card.dart';
import 'package:untitled/theme/theme.dart';

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
    final l = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.xl),

                  // Title
                  Text(
                    l.registerTitle,
                    style: AppText.displayMediumR(context).copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l.registerSubtitle,
                    style: AppText.bodyLargeR(context).copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxxl),

                  RegisterFormCard(
                    nameController: nameController,
                    telController: telController,
                    emailController: emailController,
                    reasonController: reasonController,
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  RegisterConfirmButton(
                    handleUnlockMember: handleUnlockMember,
                    formKey: formKey,
                  ),

                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
