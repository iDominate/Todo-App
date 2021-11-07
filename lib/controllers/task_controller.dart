import 'package:get/get.dart';
import 'package:todo/db/db_helper.dart';
import 'package:todo/models/task.dart';

class TaskController extends GetxController{
  RxList<Task> taskList = <Task> [
   ].obs;
  
  

  addTask(Task task) async{
    await DBHelper.insertTask(task);
    getTasks();
  }

  Future<void> getTasks() async{
    final tasks = await DBHelper.retrieveAllTasks();
    
    taskList.assignAll(tasks.map((e) => Task.fromMap(e)));
  }
  deleteTask(Task task) async{
    DBHelper.deleteTask(task);
    getTasks();
  }

  markAsCompletedr(Task task) async{
    DBHelper.updateTask(task.copyWith(isCompleted: 1));
    
  }

  deleteAllTasks(){
    DBHelper.deleteAllTasks();
    getTasks();
  }
}
