import 'package:todoapp1/todo/models/todo.dart';

class BlocState {
  final List<Todo> todos;
  BlocState({this.todos = const []});
  BlocState copyWith({List<Todo>? todos}) {
    return BlocState(todos: todos ?? this.todos);
  }
}
