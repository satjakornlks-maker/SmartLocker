import 'package:flutter/material.dart';

class EmailInputZone extends StatelessWidget{
  final bool isLoading;
  final FocusNode focusNode;
  final TextEditingController emailController;
  final VoidCallback onChanged;
  const EmailInputZone({super.key, required this.isLoading, required this.emailController, required this.focusNode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading, // Disable input when loading
      child: Opacity(
        opacity: isLoading ? 0.5 : 1.0, // Reduce opacity when loading
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
            controller: emailController,
            focusNode: focusNode,
            keyboardType: TextInputType.emailAddress,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: 'example@email.com',
              hintStyle: TextStyle(fontSize: 24, color: Colors.grey.shade400),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 30,
              ),
            ),
            onChanged: (value) {
              onChanged.call(); // Rebuild to update button state
            },
          ),
        ),
      ),
    );
  }
}