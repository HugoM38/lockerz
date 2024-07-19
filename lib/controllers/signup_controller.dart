import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SignupController {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void signUp(BuildContext context) async {
    final firstname = firstnameController.text;
    final lastname = lastnameController.text;
    final email = emailController.text;
    final password = passwordController.text;

    final success = await _authService.register(firstname, lastname, email, password);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? 'Inscription réussie' : 'Échec de l\'inscription')),
    );
  }

  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
