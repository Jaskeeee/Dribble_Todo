import 'package:dribbble_todo/core/cubit/theme_cubit.dart';
import 'package:dribbble_todo/feature/home/data/repository/drift_todo_helper.dart';
import 'package:dribbble_todo/feature/home/presentation/cubit/todo_cubit.dart';
import 'package:dribbble_todo/feature/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  final DriftTodoHelper driftTodoHelper=DriftTodoHelper();
  App({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TodoCubit>(create:(context)=>TodoCubit(driftTodoHelper: driftTodoHelper)),
        BlocProvider<ThemeCubit>(create:(context)=>ThemeCubit(),)
      ],
      child: BlocBuilder<ThemeCubit,ThemeData>(
        builder: (context,themestate){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Dribble Todo",
            theme: themestate,
            home: HomePage(),
          );
        }
      ),
    );
  }
}