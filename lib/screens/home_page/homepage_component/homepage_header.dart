import "package:flutter/material.dart";
import 'package:untitled/main.dart';
class HomepageHeader extends StatelessWidget{
  const HomepageHeader({super.key});
  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final displayText = currentLocale.languageCode == 'th' ? 'ไทย' : 'English';
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 940;
    final appState = MyApp.of(context);
    // Adjust sizes based on device
    final logoSize = isTablet ? 150.0 : 150.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image(
          image: AssetImage('assets/images/Logo.png'),
          width: logoSize,
          height: logoSize,
        ),
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
              onTap: () => appState?.toggleLocale(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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


