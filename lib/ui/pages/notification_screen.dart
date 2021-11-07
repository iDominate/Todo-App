import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:todo/ui/theme.dart';

class NotificationScreen extends StatefulWidget {

   final String payload;
   NotificationScreen({ required this.payload});

 

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _payload = '';

  @override
  void initState() {
   
    super.initState();
    _payload = widget.payload;

  }
  @override
  Widget build(BuildContext context) {
    var payloadText = _payload.split('|');
    
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light),

        centerTitle: true,
        title: Text(_payload.split('|')[0], style: TextStyle(color: Get.isDarkMode ? Colors.white : darkGreyClr),),
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        leading: IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back_ios)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(height: 20,),
                Text('Hello Jake', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color:Get.isDarkMode ? Colors.white : darkGreyClr),),
                 SizedBox(height: 10,),
                 Text(
                   'you have a new reminder',
                   style:  TextStyle(
                     fontSize: 18,
                     fontWeight: FontWeight.w300,
                     color: Get.isDarkMode ? Colors.grey[100] : Colors.white,
                   ),
                 )
              ],
            ),
            SizedBox(height: 10,),
            Expanded(child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),  
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: primaryClr
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    
                    Row(
                      children: [
                         Icon(Icons.description,size: 30,color: Colors.white,),
                    SizedBox(width: 30,),
                        Text("Title", style: TextStyle(color: Colors.white, fontSize: 30),),
                      ],
                    ),
                    SizedBox(height: 20,),
                    
                    SizedBox(
                      height: 20,
                    ),
                    Text(payloadText[0], style: TextStyle(color: Colors.white),),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                         Icon(Icons.description,size: 30,color: Colors.white,),
                    SizedBox(width: 30,),
                        Text("Description", style: TextStyle(color: Colors.white, fontSize: 30),),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Text(payloadText[1], style: TextStyle(color:Colors.white), textAlign: TextAlign.justify,),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                         Icon(Icons.description,size: 30,color: Colors.white,),
                    SizedBox(width: 30,),
                        Text("Date", style: TextStyle(color: Colors.white, fontSize: 30),),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Text(payloadText[2], style: TextStyle(color:Colors.white),),
                  ],
                ),
              ),




            )),
            SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }
}
