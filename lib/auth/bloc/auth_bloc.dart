import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../models/user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<Authevent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginPage1>(onLoginSubmitted);
    on<RegisterUser>(onRegisterUser);
  }
  Future<void> onLoginSubmitted(
      LoginPage1 event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    final box = await Hive.openBox<User>('users');
    final user = box.values.where(
      (u) => u.username == event.username && u.password == event.password,
    );
    if (user.isNotEmpty) {
      emit(AuthSuccess());
    } else {
      emit(AuthFailure("Sai email hoặc mật khẩu"));
    }
  }

  Future<void> onRegisterUser(
      RegisterUser event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    final box = await Hive.openBox<User>('users');
    final exists = box.values.any((u) => u.username == event.username);
    if (exists) {
      emit(AuthFailure("Tài khoản đã tồn tại"));
      return;
    }
    final user = User(username: event.username, password: event.password);
    await box.add(user);
    emit(AuthSuccess());
  }
}
