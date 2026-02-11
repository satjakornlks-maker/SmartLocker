import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final Locale currentLocale;
  final VoidCallback? onBackPressed;
  final VoidCallback onLanguageSwitch;

  const Header({
    super.key,
    required this.currentLocale,
    required this.onLanguageSwitch,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Determine button text based on current locale
    final displayText = currentLocale.languageCode == 'th' ? 'ไทย' : 'English';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Back button
            Container(
              margin: const EdgeInsets.fromLTRB(50, 0, 0, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () {
                  if (onBackPressed != null) {
                    onBackPressed!();
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            const Text(
              'SMART LOCKER',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),

        // Language switch button
        Container(
          margin: const EdgeInsets.only(right: 50),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onLanguageSwitch,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.language, size: 20, color: Colors.black87),
                    const SizedBox(width: 8),
                    Text(
                      displayText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
