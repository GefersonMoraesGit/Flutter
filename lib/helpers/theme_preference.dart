import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePreference {
  static const THEME_STATUS = "THEMESTATUS";
  static const TEXT_SIZE = "TEXTSIZE";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
  }

  Future<bool?> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? null;
  }

  setTextSize(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(TEXT_SIZE, value);
  }

  Future<int?> getTextSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(TEXT_SIZE) ?? null;
  }
}

var lightTheme = ThemeData(
    accentColor: Colors.black,
    primaryColor: Colors.white,
    hintColor: Colors.grey,
    scaffoldBackgroundColor: Color(0xfffffbf7),
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
      color: Color(0xfffffbf7),
    )
    // fontFamily: 'DINCondensed',
    );
var darkTheme = ThemeData(
  accentColor: Colors.white,
  primaryColor: Colors.black,
  hintColor: Colors.grey,
  scaffoldBackgroundColor: Colors.black,
  brightness: Brightness.dark,
  // fontFamily: 'DINCondensed',
);

class ThemeNotifier with ChangeNotifier {
  final String key = "theme";
  bool? _darkTheme;
  int? _textSize;
  ThemePreference themePreference = ThemePreference();

  ThemeNotifier() {
    _loadFromPrefs();
  }

  getTheme(bool defaultThemeIsLight) {
    if (_darkTheme == null) {
      _darkTheme = !defaultThemeIsLight;
    }
    return _darkTheme == true ? darkTheme : lightTheme;
  }

  getOppositeTheme() {
    return _darkTheme == false ? darkTheme : lightTheme;
  }

  setTheme(ThemeData themeData) async {
    _darkTheme = themeData == darkTheme;
    themePreference.setDarkTheme(_darkTheme!);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: themeData.primaryColor));
    notifyListeners();
  }

  getTextSize() {
    if (_textSize == null) {
      _textSize = 0;
    }
    return _textSize;
  }

  setTextSize(int textSize) async {
    _textSize = textSize;
    themePreference.setTextSize(_textSize!);

    notifyListeners();
  }

  _loadFromPrefs() async {
    _darkTheme = await themePreference.getTheme();
    _textSize = await themePreference.getTextSize();
    notifyListeners();
  }
}
