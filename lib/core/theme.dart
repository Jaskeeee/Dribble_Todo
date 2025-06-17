
import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.light(
    primary: Colors.grey,
    secondary: Colors.grey.shade800,
    inversePrimary: Colors.black
  )
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  colorScheme:ColorScheme.dark(
    primary: Colors.grey,
    secondary: Colors.grey.shade700,
    inversePrimary: Colors.white
  ) 
);