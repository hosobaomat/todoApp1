import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp1/auth/bloc/auth_bloc.dart';
import 'package:todoapp1/auth/bloc/auth_event.dart';
import 'package:todoapp1/auth/bloc/auth_state.dart';
import 'package:todoapp1/counter/view/counter_page.dart';
import 'package:todoapp1/todo/bloc/bloc_Bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final username = TextEditingController();
  final password = TextEditingController();
  bool isLogin = true;
  final _formKey =
      GlobalKey<FormState>(); // Thêm dòng này trong _LoginPageState

  void switchMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(isLogin ? 'Đăng nhập' : 'Đăng ký'),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(30, 142, 233, 1),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: BlocConsumer<AuthBloc, AuthState>(builder: (context, state) {
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isLogin ? Icons.login : Icons.person_add,
                          size: 56,
                          color: Color(Colors.blue[800]!.value),
                        ),
                        Text('Chào mừng bạn đến với ứng dụng',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: username,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập tên đăng nhập';
                              }
                              if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                                return 'Tên đăng nhập chỉ chứa chữ cái, số và dấu gạch dưới';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: password,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập mật khẩu';
                              }
                              if (value.length < 6) {
                                return 'Mật khẩu phải có ít nhất 6 ký tự';
                              }
                              if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                return 'Mật khẩu phải có chữ in hoa';
                              }
                              if (!RegExp(r'[a-z]').hasMatch(value)) {
                                return 'Mật khẩu phải có chữ thường';
                              }
                              if (!RegExp(r'[0-9]').hasMatch(value)) {
                                return 'Mật khẩu phải có chữ số';
                              }
                              return null;
                            },
                            obscureText: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(height: 24),
                    state is AuthLoading
                        ? const CircularProgressIndicator()
                        : Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 36, 160, 255),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (!_formKey.currentState!.validate()) {
                                      return; // Nếu form không hợp lệ, không làm gì cả
                                    } else {
                                      final user = username.text;
                                      final pass = password.text;
                                      if (isLogin) {
                                        context.read<AuthBloc>().add(LoginPage1(
                                            username: user, password: pass));
                                      } else {
                                        context.read<AuthBloc>().add(
                                            RegisterUser(
                                                username: user,
                                                password: pass));
                                      }
                                    }
                                  },
                                  child: Text(
                                    isLogin ? 'Đăng nhập' : 'Đăng ký',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 168, 167, 167)),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: switchMode,
                                child: Text(
                                  isLogin
                                      ? 'Chưa có tài khoản? Đăng ký'
                                      : 'Đã có tài khoản? Đăng nhập',
                                  style:
                                      const TextStyle(color: Colors.deepPurple),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              );
            }, listener: (context, state) {
              if (state is AuthSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      isLogin ? 'Đăng nhập thành công' : 'Đăng ký thành công'),
                  duration: const Duration(milliseconds: 300),
                ));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                              value: context.read<BlocBloc>(),
                              child: CounterPage(
                                username: username.text,
                              ),
                            )));
              } else if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                  duration: const Duration(milliseconds: 500),
                ));
              }
            }),
          ),
        ),
      ),
    );
  }
}
