import 'dart:async';

import 'package:awesome_quotes/awesome_quotes.dart';
import 'package:dribbble_todo/feature/home/domain/model/todo.dart';
import 'package:dribbble_todo/feature/home/presentation/cubit/todo_cubit.dart';
import 'package:dribbble_todo/feature/home/presentation/cubit/todo_states.dart';
import 'package:dribbble_todo/feature/presentation/common/add_todo_button.dart';
import 'package:dribbble_todo/feature/presentation/common/todo_text_field.dart';
import 'package:dribbble_todo/feature/presentation/common/todo_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController();
  Quote? quote;
  int completedCount=0;

  Future<int> _countTodos()async{
    completedCount = await context.read<TodoCubit>().count();
    return completedCount;
  }


  @override
  void initState() {
    super.initState();
    context.read<TodoCubit>().fetchTodos();
    quote = randomQuote();
    _countTodos();
  }

  @override
  void dispose() {
    super.dispose();
    controller.clear();
    controller.dispose();
  }

  void _addTodo() {
    final String title = controller.text;
    final todoCubit = context.read<TodoCubit>();
    if (title.isNotEmpty) {
      todoCubit.addTodo(title);
      controller.clear();
    } else {
      final messenger = ScaffoldMessenger.of(context);
      messenger.showMaterialBanner(
        MaterialBanner(
          dividerColor: Colors.red,
          backgroundColor: Colors.red,
          leading: Icon(Icons.error_outline, color: Colors.white, size: 20),
          content: Text(
            "A Title is required for the Todo.",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () => messenger.hideCurrentMaterialBanner(),
              icon: Icon(Icons.close, color: Colors.white, size: 20),
            ),
          ],
        ),
      );
      Future.delayed(Duration(seconds: 3), () {
        messenger.hideCurrentMaterialBanner();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.dark_mode_outlined,
              color: Theme.of(context).colorScheme.inversePrimary,
              size: 30,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Text(
                "Your To Do",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                children: [
                  Expanded(child: TodoTextField(controller: controller)),
                  SizedBox(width: 15),
                  AddTodoButton(onTap: () => _addTodo()),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<TodoCubit, TodoStates>(
                builder: (context, state) {
                  if (state is TodoLoaded) {
                    return StreamBuilder(
                      stream: state.todos,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              snapshot.error.toString(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 16,
                              ),
                            ),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.secondary,
                              strokeWidth: 3,
                              strokeCap: StrokeCap.round,
                            ),
                          );
                        }
                        List<Todo> todos = snapshot.data ?? [];
                        if (todos.isEmpty) {
                          return Center(
                            child: Text(
                              "You don't have any Todos yet.",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 18,
                              ),
                            ),
                          );
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: todos.length,
                            itemBuilder: (context, index) {
                              final todo = todos[index];
                              return TodoTile(
                                todo: todo,
                                deleteFunction: () => context
                                    .read<TodoCubit>()
                                    .deleteTodo(todo.id),
                                onCheck: () =>
                                    context.read<TodoCubit>().toggleTodo(todo),
                              );
                            },
                          );
                        }
                      },
                    );
                  } else if (state is TodoError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 18,
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.secondary,
                        strokeWidth: 3,
                        strokeCap: StrokeCap.round,
                      ),
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 40),
            Text(
              "Your remaining todos: $completedCount",
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 20,),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Text(
                '"${quote!.text}~${quote!.author}"',
                style: TextStyle(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            SizedBox(height: 80,),
          ],
        ),
      ),
    );
  }
}
