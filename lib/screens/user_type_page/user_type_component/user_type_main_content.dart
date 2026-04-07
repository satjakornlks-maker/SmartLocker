import 'package:flutter/material.dart';
import 'package:untitled/screens/user_type_page/user_type_component/user_type_bottom.dart';
import 'package:untitled/screens/user_type_page/user_type_component/user_type_menu.dart';
import '../../../l10n/app_localizations.dart';

class UserTypeMainContent extends StatelessWidget {
  final String systemMode;

  const UserTypeMainContent({super.key, required this.systemMode});

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 980),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: isDark
              ? Colors.white.withOpacity(0.04)
              : Colors.white.withOpacity(0.35),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.black.withOpacity(0.05),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.userType,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 20),
            UserTypeMenu(systemMode: systemMode),
            const SizedBox(height: 28),
            const UserTypeBottom(),
          ],
        ),
      ),
    );
  }
}
