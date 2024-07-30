import 'dart:convert';

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../views/auth/verification_view.dart';

class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void login(BuildContext context) async {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez saisir un email valide')),
      );
      return;
    }

    if (RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$').hasMatch(password) == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Le mot de passe doit contenir au moins 8 caractères, une majuscule et un chiffre')),
      );
      return;
    }

    if (!email.endsWith("@myges.fr")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Veuillez saisir un email de l\'école finissant par "myges.fr"')),
      );
      return;
    }

    try {
      final response = await _authService.login(email, password);

      if (context.mounted) {
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Connexion réussie')),
          );
          Navigator.of(context).pushReplacementNamed('/home');
        } else if (response.statusCode == 403) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Email non vérifié. Veuillez vérifier votre email.')),
          );
          await _authService.sendCode(email);
          if (context.mounted) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => VerificationView(
                      email: email,
                    )));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonDecode(response.body)["error"])),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Une erreur est survenue lors de la connexion')),
        );
      }
    }
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
