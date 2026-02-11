import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class PhoneConfirmButton extends StatelessWidget {
  final bool isLoading;
  final bool isComplete;
  final VoidCallback onConfirm;
  const PhoneConfirmButton({
    super.key,
    required this.isLoading,
    required this.isComplete,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 300),
      child: ElevatedButton(
        onPressed: (isComplete && !isLoading)
            ? onConfirm
            : null, // Disable when loading
        style: ElevatedButton.styleFrom(
          backgroundColor: (isComplete && !isLoading)
              ? Colors.green
              : Colors.grey.shade300,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: (isComplete && !isLoading) ? 3 : 0,
          disabledBackgroundColor: Colors.grey.shade300,
          disabledForegroundColor: Colors.grey.shade500,
        ),
        child: isLoading
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
                    color: (isComplete && !isLoading)
                        ? Colors.white
                        : Colors.grey.shade500,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.confirm,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: (isComplete && !isLoading)
                          ? Colors.white
                          : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
