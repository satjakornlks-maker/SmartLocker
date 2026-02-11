import 'dart:async';
import 'package:flutter/material.dart';
import 'homepage_component/homepage_body.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer? _emergencyTimer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Colors.grey.shade300),
        child: const HomepageBody(),
      ),
    );
  }
  @override
  void dispose() {
    _emergencyTimer?.cancel();
    super.dispose();
  }
}