// ThemeProvider class to manage theme switching
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light; // Default theme mode

  ThemeMode get themeMode => _themeMode;
  bool get isDarkModeOn => _themeMode == ThemeMode.dark;

  setTheme(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
