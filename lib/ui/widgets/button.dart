import 'package:flutter/material.dart';
import 'package:todo/ui/theme.dart';

class MyButton extends StatelessWidget {


  final String label;
  final Function() onTap;
  const MyButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,

        
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: primaryClr),
        width: 100,
        height: 45,
        child: Text(label, style: const TextStyle(color: Colors.white,),
        textAlign: TextAlign.center,
      )),
    );
  }
}
