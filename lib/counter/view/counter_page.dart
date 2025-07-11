import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp1/Theme/themecubit.dart';
import 'package:todoapp1/mainnavigation.dart';

class CounterPage extends StatelessWidget {
  final String username; // Thêm vào model
  // Constructor để nhận username từ LoginPage
  const CounterPage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(builder: (context, themeMode) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: themeMode,
        home: Mainnavigation(username: username,),//tra ve mainavigation
      );
    });
  }
}
