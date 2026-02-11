import 'package:flutter/material.dart';

class PhoneBackspace extends StatelessWidget{
  final VoidCallback onBackspace;

  const PhoneBackspace({super.key, required this.onBackspace});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onBackspace,
          borderRadius: BorderRadius.circular(35),
          child: const Center(
            child: Icon(
              Icons.backspace_outlined,
              size: 28,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}