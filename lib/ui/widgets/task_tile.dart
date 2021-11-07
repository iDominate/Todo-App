import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/models/task.dart';
import 'package:todo/ui/size_config.dart';
import 'package:todo/ui/theme.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  const TaskTile({required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(SizeConfig.orientation == Orientation.landscape ? 4 : 20,), vertical: 20) ,
      width: SizeConfig.orientation == Orientation.landscape ? SizeConfig.screenHeight/1.25: SizeConfig.screenWidth,
      margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _getBGColor(task.color),
        ),
        child: Row(
          
          children: [
            Expanded(child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(task.title!,style: GoogleFonts.lato(
    textStyle: TextStyle(color:Colors.grey[100],
    fontWeight: FontWeight.bold,
     fontSize: 16,  
    
    
    )
    ),),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  Icon(Icons.access_alarm_rounded, color: Colors.grey, size: 18,),
                 const SizedBox(width: 12,),
                 Text('${task.startTime} - ${task.endTime}', style: GoogleFonts.lato(
    textStyle: TextStyle(color:Colors.grey[100],
     fontSize: 13, 
    
    
    )
    ),)
                ],),
                const SizedBox(height: 10,),
                Text(task.note!, style: GoogleFonts.lato(
    textStyle: TextStyle(color:Colors.grey[100],
     fontSize: 15, 
    
    
    )
    ),)
              ],),
            )),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              width: .5,
              color: Colors.grey[200]!.withOpacity(.7),
            ),
            RotatedBox(quarterTurns: 3, child: Text(task.isCompleted == 0 ? "TODO": "Completed", 
            style:  GoogleFonts.lato(
    textStyle: TextStyle(color:Colors.white,
     fontSize: 18, fontWeight: FontWeight.bold,
    
    
    )
    ),
            ),)
          ],
        ),
      ),
    );
  }

  Color _getBGColor(int? color) {
    switch(color){
      case 0:
       return bluishClr;
      case 1:
       return pinkClr;
      case 2:
       return orangeClr;
      default:
       return bluishClr;
    }
  }
}
