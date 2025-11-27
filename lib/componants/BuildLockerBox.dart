import 'package:flutter/material.dart';

class BuildLockerBox extends StatelessWidget{

  final Map<String,dynamic> lockerStatus;
  final String? selectedLocker;
  final Function(String, bool) onTap;
  const BuildLockerBox({
    super.key,
    required this.selectedLocker,
    required this.lockerStatus,
    required this.onTap
  });
  @override
  Widget build(BuildContext context){

    bool isAvailable = !lockerStatus['status'];
    bool isSelected = selectedLocker == lockerStatus['id'].toString();
    return GestureDetector(
      onTap: ()=> onTap(lockerStatus['id'].toString(), isAvailable),
      child: Material(

          color: _getColor(isAvailable, isSelected),
          borderRadius: BorderRadius.circular(10),
          clipBehavior: Clip.antiAlias,
          //border: isSelected ? Border.all(color: Colors.lime,width: 4):null,
        child: InkWell(
          child: Center(child: Text(lockerStatus['name'],style: const TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),)),
        ),
      ),
    );
  }

  Color _getColor(bool isAvailable, bool isSelect){
    if(isSelect) return const Color(0xFF2196F3);
    if(isAvailable) return const Color( 0xFF4CAF50);
    return const Color(0xFFF44336);
  }

}