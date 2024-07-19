import 'package:flutter/material.dart';
import '../models/user_model.dart';

class SignupController {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void signUp(BuildContext context) {
    final firstname = firstnameController.text;
    final lastname = lastnameController.text;
    final email = emailController.text;
    final password = passwordController.text;

    User user = User(
      firstname: firstname,
      lastname: lastname,
      email: email,
      password: password,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Inscription réussie')),
    );

  }

  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
