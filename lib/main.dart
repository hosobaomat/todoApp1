import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp1/Theme/themecubit.dart';
import 'package:todoapp1/app.dart';
import 'package:todoapp1/auth/bloc/auth_bloc.dart';
import 'package:todoapp1/bottomnavcubit.dart';
import 'package:todoapp1/counter/counter_observer.dart';
import 'package:todoapp1/auth/models/user.dart';
import 'package:todoapp1/todo/bloc/bloc_Bloc.dart';
import 'package:todoapp1/todo/models/todo.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  Hive.registerAdapter(TaskCategoryAdapter());
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<Todo>('todos'); // mo hop luu tru todo
  await Hive.openBox<User>('users'); // mo hop luu tru user
  Bloc.observer =
      const CounterObserver(); //dang ki 1 couterObserver de quan sat thay doi
  runApp(MultiBlocProvider(
    //khai bao nhieu bloc cung luc
    providers: [
      //khai bao nhung bloc can su dung
      BlocProvider(create: (_) => BottomNavCubit()),
      BlocProvider(create: (_) => ThemeCubit()),
      BlocProvider(create: (_) => BlocBloc()),
      BlocProvider(create: (_) => AuthBloc()),
    ],
    child: const App(),
  ));
}
