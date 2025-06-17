import 'dart:async';
import 'package:awesome_quotes/awesome_quotes.dart';
import 'package:dribbble_todo/core/cubit/theme_cubit.dart';
import 'package:dribbble_todo/feature/home/domain/model/todo.dart';
import 'package:dribbble_todo/feature/home/presentation/common/completed_counter.dart';
import 'package:dribbble_todo/feature/home/presentation/cubit/todo_cubit.dart';
import 'package:dribbble_todo/feature/home/presentation/cubit/todo_states.dart';
import 'package:dribbble_todo/feature/home/presentation/common/add_todo_button.dart';
import 'package:dribbble_todo/feature/home/presentation/common/todo_text_field.dart';
import 'package:dribbble_todo/feature/home/presentation/common/todo_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController editingController = TextEditingController();
  Quote? quote;
  int completedCount=0;

  Future<int> _countTodos()async{
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
    controller.clear();
    controller.dispose();
    super.dispose();
  }
  
  void _editFunction(Todo todo){
    showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.edit_outlined,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              SizedBox(width: 10),
              Text(
                "Edit Todo",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
          content: TodoTextField(
            controller: editingController,
            hintText: todo.title,
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [TextButton(
              style:ButtonStyle(
                backgroundColor:WidgetStateProperty.all(Colors.grey),
                padding: WidgetStateProperty.all(EdgeInsets.fromLTRB(15,10,15,10))
              ),
              onPressed: (){
                final String newTitle = editingController.text;
                final todoCubit = context.read<TodoCubit>();
                if(newTitle.isNotEmpty){
                  todoCubit.editTodo(todo.id,newTitle);
                  Navigator.of(context).pop();
                }
                Navigator.of(context).pop();
              }, 
              child:Text(
                "Save",
                style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              )
            ),
            TextButton(
              style:ButtonStyle(
                backgroundColor:WidgetStateProperty.all(Theme.of(context).colorScheme.inversePrimary),
                padding: WidgetStateProperty.all(EdgeInsets.fromLTRB(15,10,15,10))
              ),
              onPressed:()=>Navigator.of(context).pop(), 
              child:Text(
                "Cancel",
                style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              )
            ),],
        );
      }
    );
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


  void _deleteTodo(Todo todo){
    showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.delete_forever_outlined,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              SizedBox(width: 10,),
              Text("Delete Todo",style:TextStyle(
                fontWeight: FontWeight.bold
              ),)
            ],
          ),
          content:Text(
            "Are you sure you want to delete this Todo?",
            style: TextStyle(
              fontSize: 18
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              style:ButtonStyle(
                backgroundColor:WidgetStateProperty.all(Colors.grey),
                padding: WidgetStateProperty.all(EdgeInsets.fromLTRB(15,10,15,10))
              ),
              onPressed:(){
                context.read<TodoCubit>().deleteTodo(todo.id);
                Navigator.of(context).pop();
              }, 
              child:Text(
                "Yes",
                style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              )
            ),
            TextButton(
              style:ButtonStyle(
                backgroundColor:WidgetStateProperty.all(Theme.of(context).colorScheme.inversePrimary),
                padding: WidgetStateProperty.all(EdgeInsets.fromLTRB(15,10,15,10))
              ),
              onPressed:()=>Navigator.of(context).pop(), 
              child:Text(
                "No",
                style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              )
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          BlocBuilder<ThemeCubit,ThemeData>(
            builder: (context,themestate){
              final IconData icon = themestate.brightness == Brightness.dark
              ?Icons.light_mode_outlined
              :Icons.dark_mode_outlined;
              return IconButton(
                onPressed:()=>context.read<ThemeCubit>().toggleTheme(),
                icon:Icon(
                  icon,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  size: 30,
                ),
              );
            }
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                    Expanded(child: TodoTextField(
                      controller: controller,
                      hintText: "Add new Task",
                    )),
                    SizedBox(width: 15),
                    AddTodoButton(onTap: () => _addTodo()),
                  ],
                ),
              ),
              SizedBox(height: 10),
              BlocBuilder<TodoCubit, TodoStates>(
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
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: todos.length,
                            itemBuilder: (context, index) {
                              final todo = todos[index];
                              return TodoTile(
                                todo: todo,
                                deleteFunction:()=>_deleteTodo(todo),
                                onCheck: () =>context.read<TodoCubit>().toggleTodo(todo),
                                editFunction:()=>_editFunction(todo),
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
              SizedBox(height: 40),
              CompletedCounter(),
              SizedBox(height: 10,),
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Text(
                  '"${quote!.text}"~${quote!.author}',
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}
