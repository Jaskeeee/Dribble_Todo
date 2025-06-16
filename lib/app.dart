import 'package:dribbble_todo/core/theme.dart';
import 'package:dribbble_todo/feature/home/data/database/repository/drift_todo_helper.dart';
import 'package:dribbble_todo/feature/home/presentation/cubit/todo_cubit.dart';
import 'package:dribbble_todo/feature/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  final DriftTodoHelper driftTodoHelper=DriftTodoHelper();
  App({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:(context)=>TodoCubit(driftTodoHelper: driftTodoHelper),
      child: MaterialApp(
        theme: lightMode,
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}