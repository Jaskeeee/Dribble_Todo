import 'package:dribbble_todo/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeData>{
  ThemeCubit():super(lightMode){
    _getThemeFromPrefs();
  }

  Future<void> _getThemeFromPrefs()async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final savedThemeIndex = sharedPreferences.getInt("theme")??0;
    final savedTheme = savedThemeIndex == 0? lightMode:darkMode;
    emit(savedTheme);
  }

  Future<void> _saveThemeToPrefs({required Brightness brightness})async{
    final themeIndex = brightness == Brightness.light ?0:1;
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt("theme",themeIndex);   
  }

  void toggleTheme(){    
    emit(state.brightness == Brightness.light? darkMode : lightMode);
    _saveThemeToPrefs(brightness: state.brightness);  
  }
}