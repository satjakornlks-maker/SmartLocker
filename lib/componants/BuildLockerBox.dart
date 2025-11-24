import 'package:flutter/material.dart';

class BuildLockerBox extends StatefulWidget{
  final String lockerId;
  final Map<String,bool> lockerStatus;
  final String? selectedLocker;
  final Function(String, bool) onTap;
  const BuildLockerBox({
    Key? key,
    required this.lockerId,
    required this.selectedLocker,
    required this.lockerStatus,
    required this.onTap
  }) : super(key: key);
  @override
  State<BuildLockerBox> createState()=>_BuildLockerBox();
}

class _BuildLockerBox extends State<BuildLockerBox>{


  @override
  Widget build(BuildContext context){
    bool isAvailable = widget.lockerStatus[widget.lockerId]??false;
    bool isSelected = widget.selectedLocker == widget.lockerId;
    return GestureDetector(
      onTap: ()=> widget.onTap(widget.lockerId, isAvailable),
      child: Container(

        decoration: BoxDecoration(
          color: isSelected? Colors.blue : (isAvailable?Colors.green:Colors.red),
          borderRadius: BorderRadius.circular(10),
          //border: isSelected ? Border.all(color: Colors.lime,width: 4):null,
        ),
        child: Center(
          child: Text(widget.lockerId,style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }



}