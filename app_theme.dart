import 'package:flutter/material.dart';
import 'service_locator.dart';

import 'model/services/preferences_service.dart';

class AppTheme {

  ThemeData light = ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.light, 
      primary: Color(0xFF056676), 
      onPrimary: Colors.white, 
      secondary: Color(0xffADF1E6), 
      onSecondary: Color(0xFF056676), 
      error: Color(0xffFF7283), 
      onError: Colors.white, 
      background: Colors.white, 
      onBackground: Colors.black, 
      surface: Color(0xffF5F5F5), 
      onSurface: Color(0xffB4B4B4),
    ),
    textTheme: const TextTheme(
      labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500), 
      labelMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      labelSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      headlineSmall: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
      displaySmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      displayMedium: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
    ),
    splashColor: Colors.white24,
    useMaterial3: true
  );
  
  ThemeData dark = ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.dark, 
      primary: Color.fromARGB(255, 7, 121, 139), 
      onPrimary: Colors.white, 
      secondary: Color.fromARGB(255, 132, 186, 177), 
      onSecondary: Color(0xFF056676), 
      error: Color(0xffFF7283), 
      onError: Colors.white, 
      background: Colors.black, 
      onBackground: Colors.white, 
      surface: Color.fromARGB(255, 31, 31, 31), 
      onSurface: Color.fromARGB(255, 109, 109, 109)
    ),
    textTheme: const TextTheme(
      labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500), 
      labelMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      headlineSmall: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
      displaySmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      displayMedium: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
    ),
    useMaterial3: true
  );

}

class GlobalAppThemeConfig extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  String get themeModeString {
    return {
      ThemeMode.system: 'system',
      ThemeMode.light: 'light',
      ThemeMode.dark: 'dark'
    }[themeMode] ?? 'system';
  }

  final PreferencesService _preferencesService = sl();

  GlobalAppThemeConfig() {
    final themeModeString = _preferencesService.getItem('themeMode');
    if (themeModeString != null) {
      themeMode = {
        'system': ThemeMode.system,
        'light': ThemeMode.light,
        'dark': ThemeMode.dark
      }[themeModeString] ?? ThemeMode.system;
    }
  }

  void setThemeMode(String themeMode) {
    this.themeMode = {
        'system': ThemeMode.system,
        'light': ThemeMode.light,
        'dark': ThemeMode.dark
      }[themeMode] ?? ThemeMode.system;
    _preferencesService.saveItem('themeMode', themeMode);
    notifyListeners();
  }

}