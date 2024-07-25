import 'package:flutter/material.dart';
import 'package:lockerz/views/admin/administration_page.dart';
import 'package:lockerz/views/edit_account_page.dart';
import 'package:lockerz/views/user/home_page.dart';
import 'views/login_view.dart';
import 'views/signup_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        '/login': (context) => LoginView(),
        '/signup': (context) => SignupView(),
        '/account': (context)=> EditAccountPage(),
        '/home': (context)=> HomePage(),
        '/admin': (context)=> AdministrationPage(),
      },
    );
  }
}
