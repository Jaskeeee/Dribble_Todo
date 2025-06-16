import 'dart:io';

import 'package:dribbble_todo/app.dart';
import 'package:dribbble_todo/feature/home/data/database/drift_database.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


String sqliteFileName = "todo";
late AppDatabase db;

Future<void> initDatabase()async{
  final Directory appDocDir = await getApplicationDocumentsDirectory();
  final Directory dbDir = Directory("${appDocDir.path}/$sqliteFileName.sql");
  final Directory tempFolder = Directory("${appDocDir.path}/temp/");
  if(!await dbDir.exists()){
    await dbDir.create();
  }
  if(!await tempFolder.exists()){
    await tempFolder.create();
  }
  db = AppDatabase(
    dbDir: dbDir, 
    sqliteFileName: sqliteFileName, 
    tempFolder: tempFolder
  );
}


void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await initDatabase();
  runApp(App());
}