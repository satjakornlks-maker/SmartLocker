import 'package:flutter/material.dart';
import 'package:untitled/screens/home_page/homepage_component/homepage_mian_content.dart';
import 'homepage_header.dart';

class HomepageBody extends StatelessWidget{
  const HomepageBody({super.key});

  @override
  Widget build(BuildContext context) {
      return SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const HomepageHeader(),
                const HomepageMianContent(),
              ],
            ),
          ),
        ),
      );
  }

}