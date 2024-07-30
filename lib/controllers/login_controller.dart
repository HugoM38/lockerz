import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lockerz/models/user_model.dart';
import 'package:lockerz/utils/shared_prefs.dart';
import '../services/auth_service.dart';
import '../views/auth/verification_view.dart';
import '../views/shared/snackbar.dart';

class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void login(BuildContext context) async {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showCustomSnackBar(context, 'Veuillez remplir tous les champs');
      return;
    }

    if (!email.contains('@')) {
      showCustomSnackBar(context, 'Veuillez saisir un email valide');
      return;
    }

    if (RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$').hasMatch(password) == false) {
      showCustomSnackBar(context, 'Le mot de passe doit contenir au moins 8 caractères, une majuscule et un chiffre');
      return;
    }

    if (!email.endsWith("@myges.fr")) {
      showCustomSnackBar(context, 'Veuillez saisir un email de l\'école finissant par "myges.fr"');
      return;
    }

    try {
      final response = await _authService.login(email, password);

      if (context.mounted) {
        if (response.statusCode == 200) {
          showCustomSnackBar(context, 'Connexion réussie');

          User user = await SharedPrefs.getUser();
          if (context.mounted) {
            if (user.role == 'admin') {
              Navigator.of(context).pushReplacementNamed('/admin-home');
            } else {
              Navigator.of(context).pushReplacementNamed('/home');
            }
          }
        } else if (response.statusCode == 403) {
          showCustomSnackBar(context, 'Email non vérifié. Veuillez vérifier votre email');
          await _authService.sendCode(email);
          if (context.mounted) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => VerificationView(
                      email: email,
                    )));
          }
        } else {
          showCustomSnackBar(context, jsonDecode(response.body)["error"]);
        }
      }
    } catch (e) {
      if (context.mounted) {
        showCustomSnackBar(context, 'Une erreur est survenue lors de la connexion');
      }
    }
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
