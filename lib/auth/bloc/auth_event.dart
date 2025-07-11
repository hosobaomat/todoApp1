abstract class Authevent {}

class LoginPage1 extends Authevent {
  final String username;
  final String password;

  LoginPage1({required this.username, required this.password});
}

class RegisterUser extends Authevent {
  final String username;
  final String password;

  RegisterUser({required this.username, required this.password});
}

