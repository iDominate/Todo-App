import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/db/db_helper.dart';
import 'package:todo/models/task.dart';
import 'package:todo/services/notification_services.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/ui/pages/add_task_page.dart';
import 'package:todo/ui/size_config.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/input_field.dart';
import 'package:intl/intl.dart';
import 'package:todo/ui/widgets/task_tile.dart';

import '../theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());
  final _notifyHelper = NotifyHelper();

  @override
  void initState() {
    super.initState();
    NotifyHelper().initializeNotification();
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
        actions: [
          IconButton(
            onPressed: (){
              NotifyHelper().cancelAllNotifications();
              _taskController.deleteAllTasks();
              
            },
              icon: Icon(Icons.cleaning_services_outlined,size: 24,
              color: Get.isDarkMode ? Colors.white : darkGreyClr,)
              ),
            
          CircleAvatar(
            backgroundImage: AssetImage('images/person.jpeg'),
            radius: 18,
          ),
          SizedBox(
            width: 20,
          )
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        leading: IconButton(
            onPressed: () {
              ThemeServices().switchTheme();
              // _notifyHelper.displayNotification(
              //     title: "title", body: "This is a text");
              // _notifyHelper.displayScheduledNotification();
            },
            icon: Icon(
              Get.isDarkMode
                  ? Icons.wb_sunny_outlined
                  : Icons.nightlight_round_outlined,
              size: 24,
              color: Get.isDarkMode ? Colors.orange : Colors.purpleAccent,
            )),
      ),
      body: Column(
        children: [
          _addTaskBar(),
          const SizedBox(
            height: 6,
          ),
          _addDateBar(),
          _showTasks()
        ],
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('MMMM dd, yyyy').format(DateTime.now()).toString(),
                style: subHeadingStyle,
              ),
              Text(
                "Today",
                style: headingStyle,
              )
            ],
          ),
          MyButton(
              label: "+ Add Task",
              onTap: () async {
                await Get.to(AddTaskPage());
               
              }),
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 6, left: 20),
      child: DatePicker(
        DateTime.now(),
        initialSelectedDate: DateTime.now(),
        width: 80,
        height: 100,
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        onDateChange: (newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
        dayTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        )),
        dateTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
          color: Colors.grey,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        )),
        monthTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        )),
      ),
    );
  }

 Future<void> _onRrefresh() async{
  _taskController.getTasks();
  }

  _showTasks() {


    return Expanded(
      child: Obx(

        (){
          if(_taskController.taskList.isEmpty){
           return  _noTaskMsg();
          } else {
            
            return RefreshIndicator(
              onRefresh: _onRrefresh,
              child: ListView.builder(
                      scrollDirection: SizeConfig.orientation == Orientation.landscape ? Axis.horizontal : Axis.vertical,
                  
                      itemCount: _taskController.taskList.length,
                      itemBuilder: (_, index){
                      
                       Task task = _taskController.taskList[index];
                       List<String> _taskTime = task.startTime!.split(" ")[0].split(":");
                       print('Printing item $index with color: ${task.color}');
                       var hour = int.parse(_taskTime[0]);
                       var minutes = int.parse(_taskTime[1]);
                       NotifyHelper().scheduledNotification(hour, minutes, task);
                       if(task.date == DateFormat.yMd().format(_selectedDate) || task.repeat == "Daily"
                       || (task.repeat == 'Weekly' && _selectedDate.difference(DateFormat.yMd().parse(task.date!)).inDays % 7 == 0)
                       || (task.repeat == 'Monthly' && _selectedDate.day == DateFormat.yMd().parse(task.date!).day))
                      
                       {
                         print("Date: ${task.date!.split('/')[0]}");
                         return AnimationConfiguration.staggeredList(
              duration: const Duration(milliseconds: 1375),
              position: index,
              child: SlideAnimation(
                horizontalOffset: 300,
                child: FadeInAnimation(
                  
                  child: GestureDetector(
                     onTap:() => showBottomSheet(context, task),
                     child: TaskTile(
                         task: task),
                   ),
                ),
              ),
                      );
                       }else if(_selectedDate.day - int.parse(task.date!.split('/')[1]).abs() == 7 && task.repeat == "Weekly"){
                          return AnimationConfiguration.staggeredList(
              duration: const Duration(milliseconds: 1375),
              position: index,
              child: SlideAnimation(
                horizontalOffset: 300,
                child: FadeInAnimation(
                  
                  child: GestureDetector(
                     onTap:() => showBottomSheet(context, task),
                     child: TaskTile(
                         task: task),
                   ),
                ),
              ),
                      );



                       } else {
                         return SizedBox(height: 0, width: 0,);
                       }
                      
                  
                      }
                     
                    //  return Expanded(child:
                    //  Obx((){
                    //   if(_taskController.taskList.isEmpty)
                    //    {
                      
                    //    } else
                    //    {
                    //     return Container(height: 0,);
                    //    }
                    //  })
                    ),
            );
          }
        }
      ),
    );





    // return Expanded(
    //   child: GestureDetector(
    //     onTap:() => showBottomSheet(context, Task(
    //             title: "Title 1",
    //             note: "note Something",
    //             isCompleted: 1,
    //             startTime: "2:18",
    //             endTime: "2:30",
    //             color: 0)),
    //     child: TaskTile(
    //         task: Task(
    //             title: "Title 1",
    //             note: "note Something",
    //             isCompleted: 1,
    //             startTime: "2:18",
    //             endTime: "2:30",
    //             color: 0)),
    //   ),
    // );
    // return Expanded(child:
    // Obx((){
    //   if(_taskController.taskList.isEmpty)
    //   {

    //   } else
    //   {
    //    return Container(height: 0,);
    //   }
    // })
    // );
  }

  _noTaskMsg() {
    return RefreshIndicator(
      onRefresh: _onRrefresh,
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(seconds: 2),
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                children: [
                  SizeConfig.orientation == Orientation.landscape
                      ? SizedBox(
                          height: 6,
                        )
                      : SizedBox(
                          height: 220,
                        ),
                  SvgPicture.asset(
                    'images/task.svg',
                    height: 90,
                    semanticsLabel: "Task",
                    color: primaryClr.withOpacity(.5),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Text(
                      "You do not have any tasks yet",
                      style: subHeadingStyle.copyWith(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizeConfig.orientation == Orientation.landscape
                      ? SizedBox(
                          height: 120,
                        )
                      : SizedBox(
                          height: 180,
                        )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 4),
        width: SizeConfig.screenWidth,
        height: (SizeConfig.orientation == Orientation.landscape)
            ? (task.isCompleted == 1
                ? SizeConfig.screenHeight * .6
                : SizeConfig.screenHeight * .8)
            : (task.isCompleted == 1
                ? SizeConfig.screenHeight * .30
                : SizeConfig.screenHeight * .39),
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(
          children: [
            Flexible(
                child: Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
            )),
            const SizedBox(
              height: 20,
            ),
            task.isCompleted == 1
                ? SizedBox(
                    height: 0,
                    width: 0,
                  )
                : _buildBottomSheet(
                    label: "Task Completed", onTap: (){
                        _taskController.markAsCompletedr(task);
                         NotifyHelper().cancelNotification(task);
                        Get.back();



                     }, clr: primaryClr),
                    _buildBottomSheet(
                      
                    label: "Delete Task", onTap: (){
                      _taskController.deleteTask(task);
                      NotifyHelper().cancelNotification(task);
                      Get.back();


                     }, clr: Colors.red),
                    Divider(color: Get.isDarkMode ? Colors.grey : darkHeaderClr,),
                    _buildBottomSheet(
                    label: "Cancel", onTap: (){Get.back();}, clr: primaryClr),
                    SizedBox(height: 20,)
          ],
        ),
      ),
    ));
  }

  _buildBottomSheet({
    required String label,
    required Function() onTap,
    required Color clr,
    bool isClose = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * .9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
