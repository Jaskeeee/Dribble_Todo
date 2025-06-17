import 'package:dribbble_todo/feature/home/data/repository/drift_todo_helper.dart';
import 'package:flutter/material.dart';

class CompletedCounter extends StatefulWidget {
  const CompletedCounter({super.key});

  @override
  State<CompletedCounter> createState() => _CompletedCounterState();
}

class _CompletedCounterState extends State<CompletedCounter> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DriftTodoHelper().completedCount(), 
      builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return Text(
            "Your remaining todo: Loading...",
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          );
        }
        return Text(
          "Your remaining todos: ${snapshot.data}",
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        );
      }
    );     
  }
}