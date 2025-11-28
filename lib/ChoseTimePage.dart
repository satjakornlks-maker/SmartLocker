import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled/componants/BuildConfirmButton.dart';
import 'services/api_service.dart';

class ChoseTimePage extends StatefulWidget {
  final String lockerId;
  final String TelOrEmail;
  final String OTP;
  const ChoseTimePage({
    super.key,
    required this.lockerId,
    required this.TelOrEmail,
    required this.OTP,
  });
  @override
  State<ChoseTimePage> createState() => _ChoseTimePage();
}

class _ChoseTimePage extends State<ChoseTimePage> {
  bool _isLoading = false;
  final ApiService _apiService = ApiService();
  double fontsize = 32;
  int hour = 0;
  int minute = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('หน้าเลือกเวลาการจอง'),
        backgroundColor: Colors.blue,
      ),
      body: body(),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          margin: EdgeInsets.all(60),
          child: _isLoading ? CircularProgressIndicator() : chooseTimeZone(),
        ),
      ),
    );
  }

  Widget chooseTimeZone() {
    return Column(
      children: [
        const SizedBox(height: 50),
        Text('เลือกเวลาการจอง', style: TextStyle(fontSize: fontsize)),
        const SizedBox(height: 20),
        Container(
          alignment: AlignmentDirectional.topStart,
          child: Text('เลือกชั่วโมง', style: TextStyle(fontSize: fontsize)),
        ),
        const SizedBox(height: 20),
        Container(
          height: 200,
          padding: EdgeInsets.all(10),
          child: CupertinoPicker(
            itemExtent: 40,
            scrollController: FixedExtentScrollController(initialItem: hour),
            onSelectedItemChanged: (int index) {
              setState(() => hour = index);
            },
            children: List.generate(
              25,
              (index) => Center(child: Text('$index ชม.')),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          alignment: AlignmentDirectional.topStart,
          child: Text('เลือกนาที', style: TextStyle(fontSize: fontsize)),
        ),
        const SizedBox(height: 20),
        Container(
          height: 200,
          padding: EdgeInsets.all(10),
          child: CupertinoPicker(
            itemExtent: 61,
            scrollController: FixedExtentScrollController(initialItem: minute),
            onSelectedItemChanged: (int index) {
              setState(() => minute = index);
            },
            children: List.generate(
              61,
              (index) => Center(child: Text('$index นาที')),
            ),
          ),
        ),

        SizedBox(height: 20),
        confirmButton(),
      ],
    );
  }

  Widget confirmButton() {
    return BuildConfirmButton(
      onPressed: () {
        if (hour == 0 && minute == 0) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('โปรดเลือกเวลาที่จะใช้ Locker'),
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          _handleSubmitTime();
        }
      },
      fontsize: fontsize,
      lable: 'ยืนยัน',
      alignment: AlignmentGeometry.center,
    );
  }

  Future<void> _handleSubmitTime() async {
    DateTime now = DateTime.now();
    DateTime futureTime = now.add(Duration(hours: hour, minutes: minute));
    setState(() => _isLoading = true);
    String cleanValue = widget.TelOrEmail.replaceAll(' ', '');
    try {
      final result = await _apiService.bookLocker(cleanValue.contains('@'),cleanValue,widget.lockerId, widget.OTP, futureTime);
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (result['success']) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("เปิดใช้ตู้สำเร็จ")));
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด : ${result['error']}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
    }
  }
}
