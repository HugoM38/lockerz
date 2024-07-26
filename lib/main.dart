import 'package:flutter/material.dart';
import 'package:lockerz/views/admin/administration_page.dart';
import 'package:lockerz/views/edit_account_page.dart';
import 'package:lockerz/views/user/home_page.dart';
import 'views/login_view.dart';
import 'views/signup_view.dart';

void main() {
  runApp(const Lockerz());
}

class Lockerz extends StatelessWidget {
  const Lockerz({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginView(),
        '/signup': (context) => const SignupView(),
        '/account': (context) => const EditAccountPage(),
        '/home': (context) => const HomePage(),
        '/admin': (context) => const AdministrationPage(),
      },
    );
  }
}
