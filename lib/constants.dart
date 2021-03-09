import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constants {

  static Size size = Size.fromHeight(300);

  static ThemeData lightTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: Color.fromRGBO(0, 212, 170, 1),
    backgroundColor: Color.fromRGBO(236, 239, 241, 1),
    toggleableActiveColor: Color.fromRGBO(0, 212, 170, 1),
    scaffoldBackgroundColor: Color.fromRGBO(236, 239, 241, 1),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      unselectedItemColor: Colors.grey,
    ),
    brightness: Brightness.light,
    textTheme: TextTheme(bodyText2: TextStyle(color: Color.fromRGBO(40, 45, 45, 1)))
  );

  static ThemeData darkTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    backgroundColor: Color.fromRGBO(40, 45, 45, 1),
    primaryColor: Color.fromRGBO(0, 212, 170, 1),
    toggleableActiveColor: Color.fromRGBO(0, 212, 170, 1),
    scaffoldBackgroundColor: Color.fromRGBO(40, 45, 45, 1),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color.fromRGBO(1, 0, 23, 1),
      unselectedItemColor: Color.fromRGBO(219, 255, 247, 1),
    ),
    brightness: Brightness.dark,
    textTheme: TextTheme(bodyText2: TextStyle(color: Color.fromRGBO(236, 239, 241, 1)),)
  );

  static Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  static void saveTheme(bool dark) async {
    SharedPreferences pref = await prefs;
    pref.setBool('theme', dark);
  }

  static void saveUnits(String units) async {
    SharedPreferences pref = await prefs;
    pref.setString('units', units);
  }
}
