import 'package:flutter/material.dart';
import 'package:untitled/theme/theme.dart';

class DepositTypeBottom extends StatelessWidget {
  const DepositTypeBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'SECURE ACCESS',
          style: TextStyle(
            fontFamily: AppText.family,
            fontSize: 12,
            letterSpacing: 2,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
