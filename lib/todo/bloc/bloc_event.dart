import 'package:todoapp1/todo/models/todo.dart';

abstract class BlocEvent {}

class AddtoDo extends BlocEvent {
  final String title;
  final TaskCategory category;
  final DateTime expectedEndtime;
  final String username;
  AddtoDo(this.title, this.category, this.expectedEndtime, this.username);
}

class ToggletoDo extends BlocEvent {
  final int id;
  ToggletoDo(this.id);
}

class DeletetoDo extends BlocEvent {
  final int id;
  DeletetoDo(this.id);
}

class LoadTodos extends BlocEvent {
  final String username;

  LoadTodos(this.username);

  List<Object> get props => [username];
}

class EdittoDo extends BlocEvent {
  final int id;
  final String title;
  final TaskCategory category;
  final DateTime expectedEndtime;
  final String username;

  EdittoDo(this.id, this.title, this.category, this.expectedEndtime, this.username);
}

class FilterTodos extends BlocEvent {
  final String username;
  final FliterType filterType; 

  FilterTodos({required this.username, required this.filterType});
}
enum FliterType{
  byDate,
  byTitle,
  byCategory,
}