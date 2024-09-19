import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier{
  ThemeMode selectedTheme=ThemeMode.light;


  void changeTheme(ThemeMode newTheme){
    selectedTheme=newTheme;
    notifyListeners();
  }
  bool isDarkEnabled(){
    return selectedTheme==ThemeMode.dark;

  }
}