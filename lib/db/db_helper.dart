import 'package:flutter/material.dart';

import 'package:sqflite/sqflite.dart';
import '/models/task.dart';



class DBHelper {
  static Database? _db;
  static final int _version = 1;
  static final String table_name = "tasks";
  static Future<void> initDb() async {
    if(_db != null){
      return;
    }else {
      String path = await getDatabasesPath() + "tasks.db";
      _db = await openDatabase(path, version: _version,
    onCreate: (Database db, int version) async {
  // When creating the db, create the table
  await db.execute(
      'CREATE TABLE $table_name (id INTEGER PRIMARY KEY AUTOINCREMENT,'
       'title STRING, note TEXT,' 
       'date STRING, startTime STRING, endTime STRING,'
       ' remind INTEGER, repeat STRING,'
       ' color INTEGER, isCompleted INTEGER)');
});
      
    }
  }

  static closeDb(){
    if(_db == null){
      return;
    }else {
      _db!.close();
    }
  }

  static Future<int> insertTask(Task task) async{
    return await _db!.insert(table_name, task.toMap());
  }

  static Future<int> deleteTask(Task task) async{
    return await _db!.delete(table_name,where: "id = ?", whereArgs: [task.id]);
  }

  static Future<int> updateTask(Task task) async{
    return await _db!.update(table_name, task.toMap(), where: "id = ?", whereArgs: [task.id]);
  }
  static Future<List<Map<String, dynamic>>> retrieveAllTasks() async{
    return await _db!.query(table_name);
  }

  static Future<int> deleteAllTasks() async{
    return await _db!.delete(table_name);
  }



}
