import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lockerz/views/auth/verification_view.dart';
import '../services/auth_service.dart';
import '../views/shared/snackbar.dart';

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

    if (firstname.isEmpty ||
        lastname.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
        showCustomSnackBar(context, 'Veuillez remplir tous les champs');
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
      final response =
          await _authService.register(firstname, lastname, email, password);

      if (response.statusCode == 201) {
        await _authService.sendCode(email);
        if (context.mounted) {
          showCustomSnackBar(context,'Inscription réussie. Code de vérification envoyé.');
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => VerificationView(
                    email: email,
                  )));
        }
      } else {
        if (context.mounted) {
          showCustomSnackBar(context, jsonDecode(response.body)["error"]);
        }
      }
    } catch (e) {
      if (context.mounted) {
        showCustomSnackBar(context, 'Une erreur est survenue lors de l\'inscription');
      }
    }
  }

  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
