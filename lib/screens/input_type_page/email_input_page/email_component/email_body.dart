import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/theme/theme.dart';

import 'email_confirm_button.dart';
import 'email_input_zone.dart';

class EmailBody extends StatelessWidget {
  final bool isLoading;
  final bool isValidEmail;
  final FocusNode focusNode;
  final TextEditingController emailController;
  final VoidCallback onConfirm;
  final VoidCallback onChanged;
  const EmailBody({
    super.key,
    required this.isLoading,
    required this.isValidEmail,
    required this.focusNode,
    required this.emailController,
    required this.onConfirm,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    AppLocalizations.of(context)!.emailInstruct,
                    textAlign: TextAlign.center,
                    style: AppText.headingLargeR(context),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  EmailInputZone(
                    isLoading: isLoading,
                    emailController: emailController,
                    focusNode: focusNode,
                    onChanged: onChanged,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  EmailConfirmButton(
                    isValidEmail: isValidEmail,
                    isLoading: isLoading,
                    onConfirm: onConfirm,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
