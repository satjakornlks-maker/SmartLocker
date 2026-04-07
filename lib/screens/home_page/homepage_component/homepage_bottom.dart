import 'package:flutter/material.dart';
import 'package:untitled/services/app_settings.dart';

class HomepageBottom extends StatelessWidget {
  const HomepageBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppSettings.instance,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppSettings.instance.footerLeft,
              style: const TextStyle(color: Colors.grey),
            ),
            Flexible(
              child: Text(
                AppSettings.instance.contactInfo,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ],
        );
      },
    );
  }
}