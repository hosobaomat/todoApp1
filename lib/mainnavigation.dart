import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp1/bottomnavcubit.dart';
import 'package:todoapp1/News/NewsPage.dart';
import 'package:todoapp1/Setting_Screen.dart';
import 'package:todoapp1/Theme/themecubit.dart';
import 'package:todoapp1/todo/view/stats_page.dart';
import 'package:todoapp1/todo/view/todo_page.dart';

class Mainnavigation extends StatelessWidget {
  final String username;
  const Mainnavigation({super.key, required this.username});

  List<Widget> get _screens => [
        TodoPage(us: username),
        SettingsScreen(),
        NewsPage(),
        StatsPage(), // Placeholder for StatsPage
      ];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomNavCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<BottomNavCubit, int>(builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blue,
                title:
                    const Text('Menu', style: TextStyle(color: Colors.white)),
                iconTheme: const IconThemeData(color: Colors.white),
                elevation: 2,
              ),
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    const DrawerHeader(
                      decoration: BoxDecoration(color: Colors.blue),
                      child: Text(
                        'Menu',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.note),
                      title: const Text('Todo'),
                      onTap: () {
                        Navigator.pop(context); // Đóng Drawer
                        context.read<BottomNavCubit>().changeTab(0);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Settings'),
                      onTap: () {
                        Navigator.pop(context);
                        context.read<BottomNavCubit>().changeTab(1);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.newspaper),
                      title: const Text('News'),
                      onTap: () {
                        Navigator.pop(context);
                        context.read<BottomNavCubit>().changeTab(2);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.pie_chart),
                      title: const Text('Statistics'),
                      onTap: () {
                        Navigator.pop(context);
                        context.read<BottomNavCubit>().changeTab(3);
                      },
                    ),
                  ],
                ),
              ),
              body: _screens[state],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: state,
                onTap: (index) =>
                    context.read<BottomNavCubit>().changeTab(index),
                selectedItemColor: Colors.blue, // Màu icon/label khi được chọn
                unselectedItemColor: Colors.grey, // Màu khi không chọn
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.note), label: 'Todo'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings), label: 'setting'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.newspaper), label: 'News'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.pie_chart), label: 'Statistics'),
                ],
              ),
            );
          });
        },
      ),
    );
  }
}
