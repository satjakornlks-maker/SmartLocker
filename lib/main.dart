import 'package:flutter/material.dart';
import 'OTPPage.dart';
import 'UnlockPage.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Flutter',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .start,
          children: [
            SizedBox(
              height: 100,
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => OPTPage()));
              }, child: Text('ลงทะเบียน',style: TextStyle(fontSize: 32),)),
            ),
            SizedBox(

            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => UnlockPage()));
              }, child: Text('ปลดล็อค',style: TextStyle(fontSize: 32),)),
            ),



          ],
        ),
      ),

    );
  }
}
