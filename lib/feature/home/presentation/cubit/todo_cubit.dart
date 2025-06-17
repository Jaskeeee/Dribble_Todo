import 'package:dribbble_todo/feature/home/data/repository/drift_todo_helper.dart';
import 'package:dribbble_todo/feature/home/domain/model/todo.dart';
import 'package:dribbble_todo/feature/home/presentation/cubit/todo_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoCubit extends Cubit<TodoStates>{
  final DriftTodoHelper driftTodoHelper;
  TodoCubit({
    required this.driftTodoHelper
  }):super(TodoInitial());


  void fetchTodos()async{
    try{
      final Stream<List<Todo>> todos = driftTodoHelper.fetchTodo();
      emit(TodoLoaded(todos));
    }
    catch(e){
      emit(TodoError(e.toString()));
    }
  }

  void addTodo(String title)async{
    emit(TodoLoading());
    try{
      await driftTodoHelper.addTodo(title);
      fetchTodos();
    }
    catch(e){
      emit(TodoError(e.toString()));
    }
  }

  void editTodo(int id,String title)async{
    try{
      await driftTodoHelper.editTodo(id, title);
      fetchTodos();
    }
    catch(e){
      emit(TodoError(e.toString()));
    }
  }

  void deleteTodo(int id)async{
    emit(TodoLoading());
    try{
      await driftTodoHelper.deleteTodo(id);
      fetchTodos();
    }
    catch(e){
      emit(TodoError(e.toString()));
    }
  }

  void toggleTodo(Todo todo)async{
    try{
      await driftTodoHelper.toggleTodo(todo);
      fetchTodos();
    }
    catch(e){
      emit(TodoError(e.toString()));
    }
  }

} 