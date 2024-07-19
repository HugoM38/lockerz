import 'package:flutter/material.dart';

class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login(BuildContext context) {
    final email = emailController.text;
    final password = passwordController.text;

    if (email == "test@test.com" && password == "password") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connexion réussie')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de la connexion')),
      );
    }
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
