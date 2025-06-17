import 'package:dribbble_todo/feature/home/data/database/drift_database.dart';
import 'package:dribbble_todo/feature/home/domain/model/todo.dart';
import 'package:dribbble_todo/feature/home/domain/repos/todo_repo.dart';
import 'package:dribbble_todo/main.dart';
import 'package:drift/drift.dart';

class DriftTodoHelper extends TodoRepo{
  
  @override
  Stream<List<Todo>> fetchTodo(){
    try{
      return db.managers.todoItem.watch().map(
        (row)=>row.map((item){
          return Todo(
            id: item.id, 
            title: item.title, 
            isCompleted: item.isCompleted, 
            createdAt: item.createdAt
          );
        }).toList()
      );
    }
    catch(e){
      throw Exception("Failed to fetch Todos: $e");
    }
  }
  
  @override
  Future<void> addTodo(String title)async{
    try{
      final TodoItemCompanion todo = TodoItemCompanion(
        title: Value(title)
      );
      await db.into(db.todoItem).insert(todo);
    }
    catch(e){
      throw Exception("Failed to add Todo: $e");
    }
  }
  
  @override
  Future<void> editTodo(int id, String title)async{
    try{
      await db.managers.todoItem.
      filter((f)=>f.id(id)).update((u)=>u(
        title:Value(title)
      ));
    }
    catch(e){
      throw Exception("Failed to edit Todo: $e");
    }
  }

  @override
  Future<void> deleteTodo(int id)async{
    try{
      await db.managers.todoItem.filter((f)=>f.id(id)).delete();
    }
    catch(e){
      throw Exception("Failed to delete Todo: $e");
    }
  }

  @override
  Future<void> toggleTodo(Todo todo)async{
    try{
      await db.managers.todoItem.filter((f)=>f.id(todo.id)).update((u)=>u(isCompleted: Value(!todo.isCompleted)));
    }
    catch(e){
      throw Exception("Failed to Toggle Completition: $e");
    }
  }

  @override
  Stream<int> completedCount() {
    final completedCount = db.todoItem.id.count();
    final stmt = db.selectOnly(db.todoItem)
    ..addColumns([completedCount])
    ..where(db.todoItem.isCompleted.equals(false));
    return stmt.watchSingle().map((row)=>row.read(completedCount)!);
  }
}