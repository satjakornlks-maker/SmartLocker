import 'package:flutter/material.dart';

class PhoneDisplay extends StatelessWidget{
  final String phoneNumber;
  const PhoneDisplay({super.key, required this.phoneNumber});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400, minHeight: 80),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Text(
          phoneNumber.isEmpty ? '' : phoneNumber,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w500,
            letterSpacing: 3,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}