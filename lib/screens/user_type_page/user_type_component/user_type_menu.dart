import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../widgets/grid/HoverMenuCard.dart';
import '../../chose_size_page/chose_size_page.dart';
import '../../deposit_type_page/deposit_type_page.dart';
import '../../input_type_page/input_type_page/input_type_page.dart';
import '../../register_page/register_page.dart';

class UserTypeMenu extends StatelessWidget {
  final String systemMode;

  const UserTypeMenu({super.key, required this.systemMode});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: HoverMenuCard(
                titleTh: Text(l10n.employee),
                icon: Icons.home_work,
                color: Colors.blue,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DepositTypePage(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: HoverMenuCard(
                titleTh: Text(l10n.visitor),
                icon: Icons.person,
                color: Colors.blue,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChoseSizePage(from: FromPage.visitor),
                  ),
                )
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Periodic Register button — goes directly to RegisterPage, no locker selection needed
        // SizedBox(
        //   width: double.infinity,
        //   child: HoverMenuCard(
        //     titleTh: Text(l10n.register),
        //     icon: Icons.app_registration,
        //     color: Colors.deepPurple,
        //     onPressed: () => Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => const RegisterPage(),
        //       ),
        //     ),
        //   ),
        // ),
        const SizedBox(height: 20),
        // Drop Box button
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade700.withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChoseSizePage(from: FromPage.dropBox),
                ),
              ),
              borderRadius: BorderRadius.circular(20),
              child: Ink(
                decoration: BoxDecoration(
                  color: Colors.blue.shade600,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.inbox_rounded,
                          color: Colors.black87,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        l10n.dropBox,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
