import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp1/Theme/themecubit.dart';
import 'package:todoapp1/auth/view/login_page.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final themMode = context.watch<ThemeCubit>().state;
    final isDarkmode = themMode == ThemeMode.dark;
    return Scaffold(
        appBar: AppBar(title: const Text('Cài đặt', style: TextStyle(fontWeight: FontWeight.bold)), centerTitle: true),
        body: ListView(
          children: [
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: isDarkmode,
              onChanged: (_) {
                context.read<ThemeCubit>().toggleTheme();
              },
            ),
            const SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                icon: const Icon(Icons.logout),
                label: Text(
                  'Đăng xuất',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
