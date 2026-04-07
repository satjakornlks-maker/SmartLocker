import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/grid/HoverMenuCard.dart';
import '../../chose_size_page/chose_size_page.dart';
import '../../deposite_type_page/deposit_type_page.dart';
import '../../input_type_page/input_type_page/input_type_page.dart';

class UserTypeMenu extends StatelessWidget {
  final String systemMode;

  const UserTypeMenu({super.key, required this.systemMode});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final useColumn = screenWidth < 900;

    final employeeCard = HoverMenuCard(
      titleTh: Text(l10n.employee),
      icon: Icons.home_work,
      color: Colors.blue,
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DepositTypePage()),
      ),
    );

    final visitorCard = HoverMenuCard(
      titleTh: Text(l10n.visitor),
      icon: Icons.person,
      color: Colors.blue,
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChoseSizePage(from: FromPage.visitor),
        ),
      ),
    );

    return Column(
      children: [
        if (useColumn) ...[
          SizedBox(width: double.infinity, child: employeeCard),
          const SizedBox(height: 14),
          SizedBox(width: double.infinity, child: visitorCard),
        ] else ...[
          Row(
            children: [
              Expanded(child: employeeCard),
              const SizedBox(width: 16),
              Expanded(child: visitorCard),
            ],
          ),
        ],
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade700.withValues(alpha: 0.22),
                blurRadius: 14,
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 24,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.10),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.inbox_rounded,
                          color: Colors.black87,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Flexible(
                        child: Text(
                          l10n.dropBox,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
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
