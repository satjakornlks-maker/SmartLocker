import 'package:flutter/material.dart';
import 'package:untitled/theme/theme.dart';

import 'notice_component/notice_body.dart';
import 'notice_component/notice_header.dart';

class NoticePage extends StatelessWidget {
  const NoticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            NoticeHeader(mainContext: context),
            Expanded(child: NoticeBody(mainContext: context)),
          ],
        ),
      ),
    );
  }
}
