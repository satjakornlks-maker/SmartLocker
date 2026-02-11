import 'package:flutter/material.dart';
import 'notice_confirm_button.dart';

class NoticeBody extends StatelessWidget{
  final BuildContext mainContext;
  const NoticeBody({super.key, required this.mainContext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // Success Icon
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle_rounded,
                      size: 80,
                      color: Colors.green.shade600,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Success Title
                const Center(
                  child: Text(
                    'ลงทะเบียนสำเร็จ!',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 10),

                Center(
                  child: Text(
                    'รอการตอบกลับจากผู้ดูแล',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 50),
                const SizedBox(height: 40),
                NoticeConfirmButton(mainContext: mainContext,),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}