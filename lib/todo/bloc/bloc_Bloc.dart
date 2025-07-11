import 'package:bloc/bloc.dart';
import 'package:todoapp1/todo/bloc/bloc_event.dart';
import 'package:todoapp1/todo/bloc/bloc_state.dart';
import 'package:todoapp1/todo/models/todo.dart';
import 'package:hive/hive.dart';

class BlocBloc extends Bloc<BlocEvent, BlocState> {
  BlocBloc() : super(BlocState()) {
    on<AddtoDo>((event, emit) async {
      final box = await Hive.openBox<Todo>('todos');
      final newTodo = Todo(
        id: DateTime.now().millisecondsSinceEpoch,
        title: event.title,
        isCompleted: false,
        category: event.category,
        startTime: DateTime.now(),
        endTime: event.expectedEndtime,
        username: event.username,
      );
      await box.add(newTodo);
      final userTodos =
          box.values.where((t) => t.username == event.username).toList();
      emit(BlocState(todos: userTodos));
    });

    on<ToggletoDo>((event, emit) async {
      final box = await Hive.openBox<Todo>('todos');
      final todoItem = box.values.firstWhere((t) => t.id == event.id);
      todoItem.isCompleted = !todoItem.isCompleted;
      await todoItem.save();
      final userTodos =
          box.values.where((t) => t.username == todoItem.username).toList();
      emit(BlocState(todos: userTodos));
    });

    on<DeletetoDo>((event, emit) async {
      final box = await Hive.openBox<Todo>('todos');
      final todoItem = box.values.firstWhere((t) => t.id == event.id);
      final username = todoItem.username;
      await todoItem.delete();
      final userTodos =
          box.values.where((t) => t.username == username).toList();
      emit(BlocState(todos: userTodos));
    });

    on<LoadTodos>((event, emit) async {
      final box = await Hive.openBox<Todo>('todos');
      final userTodos =
          box.values.where((t) => t.username == event.username).toList();
      emit(BlocState(todos: userTodos));
    });

    on<EdittoDo>((event, emit) async {
      final box = await Hive.openBox<Todo>('todos');
      final todoItem = box.values.firstWhere((t) => t.id == event.id);
      todoItem.title = event.title;
      todoItem.category = event.category;
      todoItem.endTime = event.expectedEndtime;
      todoItem.username = event.username;
      await todoItem.save();
      final userTodos =
          box.values.where((t) => t.username == event.username).toList();
      emit(BlocState(todos: userTodos));
    });

    on<FilterTodos>((event, emit) async {
      final box = await Hive.openBox<Todo>('todos');
      List<Todo> todos =
      box.values.where((t) => t.username == event.username).toList();
      if (event.filterType == FliterType.byDate) {
        todos.sort((a, b) => a.endTime.compareTo(b.endTime));
      } else if (event.filterType == FliterType.byTitle) {
        todos.sort((a, b) => a.title.compareTo(b.title));
      } else if (event.filterType == FliterType.byCategory) {
        todos.sort((a, b) => a.category.index.compareTo(b.category.index));
      }
      emit(BlocState(todos: todos));
    });
  }
}
