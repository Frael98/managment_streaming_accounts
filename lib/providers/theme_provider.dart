import 'package:f_managment_stream_accounts/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  // ignore: constant_identifier_names
  static const String THEMEKEY = "theme";
  bool isDarkMode = false;

  ThemeProvider() {
    themechange();
  }

  void themechange() async {
    var sharedPref = await SharedPreferences.getInstance();
    var theme = sharedPref.getBool(THEMEKEY);
    if (theme != null) {
      isDarkMode = theme;
      notifyListeners();
    }
  }

  void toggleTheme() async {
    isDarkMode = !isDarkMode;
    notifyListeners();
    await _saveTheme();
  }

  _saveTheme() async {
    var sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool(THEMEKEY, isDarkMode);
  }
 
  ThemeData getTheme() {
    return isDarkMode ? CustomTheme.lightTheme : CustomTheme.darkTheme;
  }

  IconData getThemeIcon() {
    return isDarkMode ? Icons.dark_mode_outlined : Icons.wb_sunny_outlined;
  }
}
