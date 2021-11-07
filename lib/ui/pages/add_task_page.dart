import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/db/db_helper.dart';
import 'package:todo/models/task.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(Duration(minutes: 15)))
      .toString();
  int _selectdRemind = 5;
  List<int> _remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> _repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int? _selectedColor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
        actions: [
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
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios,
              size: 24,
              color: primaryClr,
            )),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Add Task",
                style: headingStyle.copyWith(color: Colors.black),
              ),
              InputField(
                  title: "Title",
                  hint: "Enter title here",
                  controller: _titleController,
                  child: null),
              InputField(
                  title: "Note",
                  hint: "Enter note here",
                  controller: _noteController,
                  child: null),
              InputField(
                  title: "Date",
                  hint: DateFormat.yMd().format(_selectedDate).toString(),
                  controller: null,
                  child: IconButton(
                      onPressed: () {
                        _getDateFromUser();
                      },
                      icon: Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.grey,
                      ))),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                        title: "Start Time",
                        hint: _startTime,
                        controller: null,
                        child: IconButton(
                            onPressed: () {
                               _getTimeFromUser(startTime: true);
                            },
                            icon: Icon(
                              Icons.timer_rounded,
                              color: Colors.grey,
                            ))),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: InputField(
                        title: "End Time",
                        hint: _endTime,
                        controller: null,
                        child: IconButton(
                            onPressed: () {
                              _getTimeFromUser();
                            },
                            icon: Icon(
                              Icons.timer_rounded,
                              color: Colors.grey,
                            ))),
                  ),
                ],
              ),
              InputField(
                  title: "Remind",
                  hint: '$_selectdRemind mintues early',
                  controller: null,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: DropdownButton<String>(
                      items: _remindList
                          .map<DropdownMenuItem<String>>((e) =>
                              DropdownMenuItem<String>(
                                child: Text(
                                  '$e minutes early',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                value: e.toString(),
                              ))
                          .toList(),
                      value: _selectdRemind.toString(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectdRemind = int.parse(newValue!);
                        });
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      iconSize: 32,
                      elevation: 4,
                      underline: Container(
                        height: 0,
                      ),
                      dropdownColor: Colors.blueGrey,
                    ),
                  )),
              InputField(
                  title: "Repeat",
                  hint: _selectedRepeat,
                  controller: null,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: DropdownButton<String>(
                      dropdownColor: Colors.blueGrey,
                      underline: Container(height: 0),
                      elevation: 4,
                      items: _repeatList
                          .map<DropdownMenuItem<String>>(
                              (e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ))
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _selectedRepeat = value!;
                        });
                      },
                      value: _selectedRepeat,
                    ),
                  )),
              SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
      children: [
        Text(
          'Color',
          style: titleStyle,
        ),
        SizedBox(
          height: 8,
        ),
        Wrap(
          children: List.generate(
              3,
              (index) => InkWell(
                onTap: () {
                  setState(() {
                    _selectedColor = index;
                    print("index Changed to $index");
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: CircleAvatar(
                    radius: 14,
                    child: _selectedColor == index
                        ? Icon(
                            Icons.done,
                            color: Colors.white,
                          )
                        : null,
                    backgroundColor: index == 0
                        ? primaryClr
                        : index == 1
                            ? pinkClr
                            : orangeClr,
                  ),
                ),
              )),
        )
      ],
    ),
                  MyButton(label: 'Create Task', onTap: () => _validateDate())
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _validateDate() {
    if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        'required',
        'Fields cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: Icon(
          Icons.warning_amber_outlined,
          color: Colors.red,
        ),
      );
      return;
    }
    _addTaskstoDb();
    Get.back();
  }

  _addTaskstoDb() async {
    print("Color: $_selectedColor");
    int value = await _taskController.addTask(Task(
      title: _titleController.text,
      note: _noteController.text,
      isCompleted: 0,
      date: DateFormat.yMd().format(_selectedDate),
      repeat: _selectedRepeat,
      color: _selectedColor,
      remind: _selectdRemind,
      endTime: _endTime,
      startTime: _startTime,
    ));
    print(value);
  }

  _getTimeFromUser({bool startTime = false}) async{
   TimeOfDay? _pickedTime = await showTimePicker(context: context, initialTime: startTime ? TimeOfDay.now() : TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: 15))));
   if(_pickedTime == null){
     print('');
     return;
   }
   String _formattedTime = _pickedTime.format(context);
   if(startTime){
     setState(() => _startTime = _formattedTime);
   }else if(!startTime){
      setState(() => _endTime = _formattedTime);
   }else {
     print("The dialog was closed or something went wrong");
   }
  }

  _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
        _pickedDate == null ? print('') : setState(() => _selectedDate = _pickedDate);
  }
}




