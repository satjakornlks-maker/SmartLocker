import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';

import 'email_confirm_button.dart';
import 'email_input_zone.dart';

class EmailBody extends StatelessWidget{
  final bool isLoading;
  final bool isValidEmail;
  final FocusNode focusNode;
  final TextEditingController emailController;
  final VoidCallback onConfirm;
  final VoidCallback onChanged;
  const EmailBody({super.key, required this.isLoading, required this.isValidEmail, required this.focusNode, required this.emailController, required this.onConfirm, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                  Text(
                    AppLocalizations.of(context)!.emailInstruct,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Email input field
                  EmailInputZone(
                    isLoading: isLoading,
                    emailController: emailController,
                    focusNode: focusNode,
                    onChanged: onChanged,
                  ),

                  const SizedBox(height: 40),

                  // Confirm button
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