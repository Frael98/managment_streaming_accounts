import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  static late SharedPreferences prefs;
  // ignore: constant_identifier_names
  static const String LOGGED = 'Logged';

  static Future initPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  static bool getIsLogged() {
    if (prefs.getBool(LOGGED) != null) {
      return prefs.getBool(LOGGED)!;
    }
    return false;
  }

  static String getSharedData(String key){
    return prefs.getString(key) ?? "";
  }

  static setIsLogged(bool value) {
    prefs.setBool(LOGGED, value);
  }
}
