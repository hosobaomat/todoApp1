import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);//mac dinh de sang

  void toggleTheme() {//chuyen tu sang thanh toi hoac nguoc lai
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }
}
