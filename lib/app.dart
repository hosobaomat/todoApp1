import 'package:flutter/material.dart';
import 'package:todoapp1/auth/view/login_page.dart';
class App extends MaterialApp {
  //ke thua truc tiep materialApp do phai su dung statelessWidget
  const App({super.key})
      : super(home: const LoginPage(), debugShowCheckedModeBanner: false);
  Widget build(BuildContext context) {
    return const LoginPage();
  }
}
