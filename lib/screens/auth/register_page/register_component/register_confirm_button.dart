import 'package:flutter/material.dart';

class RegisterConfirmButton extends StatelessWidget{
  final GlobalKey<FormState> formKey;
  final Function handleUnlockMember;
  const RegisterConfirmButton({super.key, required this.handleUnlockMember, required this.formKey});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: double.infinity),
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            handleUnlockMember();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 3,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.check_circle_rounded, size: 24),
            SizedBox(width: 10),
            Text(
              'ส่งคำร้อง',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}