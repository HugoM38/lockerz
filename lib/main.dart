import 'package:flutter/material.dart';
import 'package:lockerz/views/admin/administration_page.dart';
import 'package:lockerz/views/edit_account_page.dart';
import 'package:lockerz/views/user/home_page.dart';
import 'views/login_view.dart';
import 'views/signup_view.dart';
import 'views/verification_view.dart';

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
        colorScheme: const ColorScheme(
          primary: Color(0xFF406E8E),
          primaryContainer: Color(0xFF406E8E),
          secondary: Color(0xFF42113C),
          secondaryContainer: Color(0xFF42113C),
          surface: Color(0xFF1C0118),
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.white,
          onError: Colors.white,
          brightness: Brightness.dark,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
        ),
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
