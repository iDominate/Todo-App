import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {

  final GetStorage _box = GetStorage();
  final _key = "isDarkMode";

  saveThemeToBox(bool isDarkMode){
    _box.write(_key, isDarkMode);
  }

  ThemeMode get theme => loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  bool loadThemeFromBox(){
   return _box.read<bool>(_key) ?? false;
  }
 switchTheme(){
   Get.changeThemeMode(loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
   saveThemeToBox(!loadThemeFromBox());
   
 }

}


