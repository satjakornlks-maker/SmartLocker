import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ChoseTimePage extends StatefulWidget {
  const ChoseTimePage({super.key});
  @override
  State<ChoseTimePage> createState() => _ChoseTimePage();
}

class _ChoseTimePage extends State<ChoseTimePage> {
  @override
  double fontsize = 32;
  int hour = 0;
  int minute = 0;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('หน้าเลือกเวลาการจอง'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.all(60),
            child: Column(
              children: [
                SizedBox(height: 50),

                Container(
                  child: Text(
                    'เลือกเวลาการจอง',
                    style: TextStyle(fontSize: fontsize),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  alignment: AlignmentDirectional.topStart,
                  child: Text(
                    'เลือกชั่วโมง',
                    style: TextStyle(fontSize: fontsize),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 200,
                  padding: EdgeInsets.all(10),
                  child: CupertinoPicker(
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(
                      initialItem: hour,
                    ),
                    onSelectedItemChanged: (int index) {
                      setState(() => hour = index);
                    },
                    children: List.generate(
                      25,
                      (index) => Center(child: Text('$index ชม.')),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  alignment: AlignmentDirectional.topStart,
                  child: Text(
                    'เลือกนาที',
                    style: TextStyle(fontSize: fontsize),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 200,
                  padding: EdgeInsets.all(10),
                  child: CupertinoPicker(
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(
                      initialItem: minute,
                    ),
                    onSelectedItemChanged: (int index) {
                      setState(() => minute = index);
                    },
                    children: List.generate(
                      25,
                      (index) => Center(child: Text('$index นาที')),
                    ),
                  ),
                ),

                SizedBox(height: 20),
                Container(
                  child: TextButton(
                    onPressed: () {
                      if (hour == null || hour == 0 && minute == 0) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('โปรดเลือกเวลาที่จะใช้ Locker'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      } else {
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      }
                    },
                    child: Text('ยืนยัน', style: TextStyle(fontSize: fontsize)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
