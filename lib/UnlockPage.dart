import 'package:flutter/material.dart';
import 'FillPINPage.dart';
import 'componants/BuildLegend.dart';
import 'componants/BuildLockerBox.dart';

class UnlockPage extends StatefulWidget{
  @override
  State<UnlockPage> createState()=>_UnlockPage();
}

class _UnlockPage extends State<UnlockPage> {
  String? selectedLocker;
  final Map<String, bool> lockerStatus = {
    'A1': true, 'A2': true, 'A3': false,
    'A4': true, 'A5': true, 'A6': true,
    'A7': true, 'A8': true, 'A9': false,
  };

  @override
  Widget build(BuildContext context) {
    double fontsize = 32;
    return Scaffold(
      appBar: AppBar(
        title: Text('หน้าปลดล็อคตู้ล็อคเกอร์'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: .start,
              crossAxisAlignment: .center,
              children: [
                SizedBox(height: 100),
                Text('เลือกตู้ล็อคเกอร์', style: TextStyle(fontSize: fontsize)),
                SizedBox(height: 50),

                BuildLegend(),
                SizedBox(height: 30,),

                Container(
                  child: GridView.builder(
                      padding: EdgeInsets.all(100),

                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1,
                      ),
                      shrinkWrap: true,
                      itemCount: lockerStatus.length,
                      itemBuilder: (context, index) {
                        String lockerId = 'A${index + 1}';
                        return BuildLockerBox(lockerId: lockerId,
                            selectedLocker: selectedLocker,
                            lockerStatus: lockerStatus,
                            onTap: _onLockerTap);
                      }),
                ),
                SizedBox(height: 30,),

                if(selectedLocker != null)
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('เลือกตู้: $selectedLocker',
                      style: TextStyle(fontSize: 20),),
                  ),
                SizedBox(
                  height: 50,
                ),


                Container(
                  child: TextButton(
                    onPressed: () {
                      _handleUnlock();
                    },
                    child: Text('จอง', style: TextStyle(fontSize: fontsize)),
                  ),
                ),
                SizedBox(height: 40,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onLockerTap(String lockerId, bool isAvailable) {
    if (isAvailable) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        onVisible: (){
        setState(() => selectedLocker = lockerId);
      },
        content: Text('เลือกตู้ $lockerId '),
      //   action: SnackBarAction(label: 'ยกเลิก', onPressed: (){
      //   setState(()=>selectedLocker = null);
      // }),
        duration: Duration(seconds: 3),
      )
      );
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ตู้ $lockerId ไม่ว่าง'),
          duration: Duration(seconds: 3),)
      );
    }
  }

  void _handleUnlock() {
    if (selectedLocker != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FillPinPage(lockerId: selectedLocker!)),
      );
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('โปรดเลือกตู้ล็อคเกอร์'),
          duration: Duration(seconds: 3),),

      );
    }
  }
}
