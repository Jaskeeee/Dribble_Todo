import 'package:dribbble_todo/feature/home/domain/model/todo.dart';

abstract class TodoRepo {
  Stream<List<Todo>> fetchTodo();
  Future<void> addTodo(String title);
  Future<void> editTodo(int id,String title);
  Future<void> deleteTodo(int id);
  Future<void> toggleTodo(Todo todo);
  Stream<int> completedCount();
}