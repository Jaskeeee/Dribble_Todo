import 'package:dribbble_todo/feature/home/domain/model/todo.dart';

sealed class TodoStates {}
class TodoInitial extends TodoStates{}
class TodoLoaded extends TodoStates{
  final Stream<List<Todo>> todos;
  TodoLoaded(this.todos);
}
class TodoLoading extends TodoStates{}
class TodoError extends TodoStates{
  final String message;
  TodoError(this.message);
}