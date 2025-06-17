import 'package:dribbble_todo/feature/home/domain/model/todo.dart';
import 'package:flutter/material.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;
  final void Function() deleteFunction;
  final void Function() onCheck;
  final void Function() editFunction;
  const TodoTile({
    super.key,
    required this.deleteFunction,
    required this.todo,
    required this.onCheck,
    required this.editFunction
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top:5,bottom:5),
      child: ListTile(
        onLongPress:editFunction,
        contentPadding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(15),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            style: BorderStyle.solid,
            width: 1
          )
        ),
        leading: Checkbox(
          value: todo.isCompleted, 
          checkColor: Theme.of(context).scaffoldBackgroundColor,
          focusColor: Theme.of(context).colorScheme.secondary,
          activeColor: Theme.of(context).colorScheme.secondary,
          onChanged:(p0)=>onCheck(),
        ),
        title: Text(todo.title),
        titleTextStyle: TextStyle(
          color: todo.isCompleted 
          ?Theme.of(context).colorScheme.primary
          :Theme.of(context).colorScheme.inversePrimary,
          fontSize:18,
          decoration:todo.isCompleted 
          ?TextDecoration.lineThrough
          :TextDecoration.none
        ),
        trailing: IconButton(
          onPressed: deleteFunction, 
          icon:Icon(
            Icons.close_outlined,
            color: Theme.of(context).colorScheme.inversePrimary,
            size: 25,
          )
        ),         
      ),
    );
  }
}