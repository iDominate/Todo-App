

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/ui/size_config.dart';

import '../theme.dart';

class InputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? child;
  







  const InputField({required this.title, required this.hint, required this.controller, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      
               
              margin: const EdgeInsets.only(top: 16),
              
              child: Column(
                
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Text(title, style: titleStyle.copyWith(color: Colors.black),),
                  Container(
                     padding: const EdgeInsets.only(left: 14),  
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20),
                    
                  ),
                  child: TextFormField(
                    
                    
                    style: subTitleStyle,
                    controller: controller,
                    cursorColor: Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                    autofocus: false,
                    readOnly: child == null ? false : true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 30, top: 16),
                      
                      
                      suffixIcon: child ?? Container(width: 0, height: 0,),
                      
                      
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).backgroundColor,
                        )
                      ),
                      hintText: hint,
                      hintStyle: subTitleStyle,
                    ),
                  ),
                  )
                  
                  
                ],
              ));
  }
}
