import 'package:flutter/material.dart';
import 'package:untitled/services/app_settings.dart';

class UserTypeBottom extends StatelessWidget {
  const UserTypeBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppSettings.instance,
      builder: (context, _) {
        final text = AppSettings.instance.footerLeft;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text.isEmpty ? 'SECURE ACCESS' : text,
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 2,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }
}
