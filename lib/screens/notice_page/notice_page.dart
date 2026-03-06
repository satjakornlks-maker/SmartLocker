import 'package:flutter/material.dart';

import 'notice_component/notice_body.dart';
import 'notice_component/notice_header.dart';

class NoticePage extends StatelessWidget {
  const NoticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            NoticeHeader(mainContext: context),
            Expanded(child: NoticeBody(mainContext: context,)),
          ],
        ),
      ),
    );
  }


}