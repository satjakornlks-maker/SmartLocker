import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/theme/theme.dart';

class EmailInputZone extends StatelessWidget {
  final bool isLoading;
  final FocusNode focusNode;
  final TextEditingController emailController;
  final VoidCallback onChanged;
  const EmailInputZone({
    super.key,
    required this.isLoading,
    required this.emailController,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: Opacity(
        opacity: isLoading ? 0.5 : 1.0,
        child: Semantics(
          label: AppLocalizations.of(context)!.emailAddressLabel,
          textField: true,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.lgRadius,
              border: Border.all(color: AppColors.border),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: emailController,
              focusNode: focusNode,
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppText.family,
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.emailPlaceholder,
                hintStyle: TextStyle(
                  fontFamily: AppText.family,
                  fontSize: 22,
                  color: AppColors.textDisabled,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: AppSpacing.xl,
                  horizontal: AppSpacing.xxxl,
                ),
              ),
              onChanged: (value) {
                onChanged.call();
              },
            ),
          ),
        ),
      ),
    );
  }
}
