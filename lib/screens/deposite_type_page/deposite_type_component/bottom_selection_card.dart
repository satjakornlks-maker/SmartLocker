import 'package:flutter/material.dart';
import 'package:untitled/l10n/app_localizations.dart';

import '../../common/chose_size_page/chose_size_page.dart';
import '../../locker_page/locker_selection_page.dart';

class BottomSelectionCard extends StatelessWidget{
  final String systemMode;
  const BottomSelectionCard({super.key, required this.systemMode});


  @override
  Widget build(BuildContext context) {
    return Container(
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
          onTap: () => systemMode == 'B2C'
              ? Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ChoseSizePage(mode: LockerSelectionMode.memberSelect),
            ),
          )
              : Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LockerSelectionPage(
                mode: LockerSelectionMode.memberSelect,
              ),
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
                      Icons.person_add_rounded,
                      color: Colors.black87,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.register,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}