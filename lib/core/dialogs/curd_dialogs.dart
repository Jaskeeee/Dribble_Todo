import 'package:dribbble_todo/feature/home/domain/model/todo.dart';
import 'package:dribbble_todo/feature/home/presentation/common/todo_text_field.dart';
import 'package:dribbble_todo/feature/home/presentation/cubit/todo_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurdDialogs {
  void editFunction(
    BuildContext context,
    Todo todo,
    TextEditingController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) {
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
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: TodoTextField(controller: controller, hintText: todo.title),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.grey),
                padding: WidgetStateProperty.all(
                  EdgeInsets.fromLTRB(15, 10, 15, 10),
                ),
              ),
              onPressed: () {
                final String newTitle = controller.text;
                final todoCubit = context.read<TodoCubit>();
                if (newTitle.isNotEmpty) {
                  todoCubit.editTodo(todo.id, newTitle);
                  Navigator.of(context).pop();
                }
                Navigator.of(context).pop();
              },
              child: Text(
                "Save",
                style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).colorScheme.inversePrimary,
                ),
                padding: WidgetStateProperty.all(
                  EdgeInsets.fromLTRB(15, 10, 15, 10),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void addTodo(BuildContext context, TextEditingController controller) {
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

  void deleteTodo(BuildContext context, Todo todo) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.delete_forever_outlined,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              SizedBox(width: 10),
              Text(
                "Delete Todo",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to delete this Todo?",
            style: TextStyle(fontSize: 18),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.grey),
                padding: WidgetStateProperty.all(
                  EdgeInsets.fromLTRB(15, 10, 15, 10),
                ),
              ),
              onPressed: () {
                context.read<TodoCubit>().deleteTodo(todo.id);
                Navigator.of(context).pop();
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).colorScheme.inversePrimary,
                ),
                padding: WidgetStateProperty.all(
                  EdgeInsets.fromLTRB(15, 10, 15, 10),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "No",
                style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
