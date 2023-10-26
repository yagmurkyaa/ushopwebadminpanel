import 'package:flutter/material.dart';
import 'package:ushop_admin_panel/services/dark_them_preferences.dart';

class DarkThemeProvider with ChangeNotifier { //changleri takip eder
  DarkThemePrefs darkThemePrefs = DarkThemePrefs();
  bool _darkTheme = false;
  bool get getDarkTheme => _darkTheme;

  set setDarkTheme(bool value) {
    _darkTheme = value;
    darkThemePrefs.setDarkTheme(value);
    notifyListeners(); //ChangeNotifier'a değişiklik olduğunu iletiyor
  }

}