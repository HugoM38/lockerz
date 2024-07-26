import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void login(BuildContext context) async {
    final email = emailController.text;
    final password = passwordController.text;

    final success = await _authService.login(email, password);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(success ? 'Connexion réussie' : 'Échec de la connexion')),
      );
    }
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
