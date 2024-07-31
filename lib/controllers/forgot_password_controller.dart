import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lockerz/services/user_service.dart';
import 'package:lockerz/utils/shared_prefs.dart';
import 'package:lockerz/views/shared/snackbar.dart';

class ForgotPasswordController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isCodeSent = ValueNotifier<bool>(false);
  final ValueNotifier<int> resendCooldown = ValueNotifier<int>(0);
  final ValueNotifier<bool> isResendDisabled = ValueNotifier<bool>(false);

  final UserService _userService = UserService();
  Timer? _timer;

  void dispose() {
    emailController.dispose();
    codeController.dispose();
    passwordController.dispose();
    isLoading.dispose();
    isCodeSent.dispose();
    resendCooldown.dispose();
    isResendDisabled.dispose();
    _timer?.cancel();
  }

  Future<void> sendCode(BuildContext context) async {
    final email = emailController.text;

    if (email.isEmpty) {
      showCustomSnackBar(context, 'Veuillez saisir votre email');
      return;
    }

    if (!email.contains('@') || !email.endsWith("@myges.fr")) {
      showCustomSnackBar(context, 'Veuillez saisir un email valide de l\'école finissant par "myges.fr"');
      return;
    }

    isLoading.value = true;
    final response = await _userService.forgotPassword(email);
    isLoading.value = false;

    if (response.statusCode == 200) {
      isCodeSent.value = true;
      startResendCooldown();
      showCustomSnackBar(context, 'Code de vérification envoyé.');
    } else {
      showCustomSnackBar(context, 'Erreur lors de l\'envoi du code.');
    }
  }

  Future<void> resetPassword(BuildContext context) async {
    final email = emailController.text;
    final code = codeController.text;
    final newPassword = passwordController.text;

    if (code.isEmpty || newPassword.isEmpty) {
      showCustomSnackBar(context, 'Veuillez remplir tous les champs');
      return;
    }

    if (RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$').hasMatch(newPassword) == false) {
      showCustomSnackBar(context, 'Le mot de passe doit contenir au moins 8 caractères, une majuscule et un chiffre');
      return;
    }

    isLoading.value = true;
    final response = await _userService.resetPassword(email, code, newPassword);
    isLoading.value = false;

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final token = responseData['token'];
      final user = responseData['user'];

      await SharedPrefs.saveAuthToken(token);
      await SharedPrefs.saveUserInformation(jsonEncode(user));

      showCustomSnackBar(context, 'Mot de passe réinitialisé avec succès.');

      if (context.mounted) {
        if (user['role'] == 'admin') {
          Navigator.of(context).pushReplacementNamed('/admin-home');
        } else {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      }
    } else {
      showCustomSnackBar(context, 'Erreur lors de la réinitialisation du mot de passe.');
    }
  }

  void startResendCooldown() {
    resendCooldown.value = 60;
    isResendDisabled.value = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      resendCooldown.value -= 1;
      if (resendCooldown.value == 0) {
        timer.cancel();
        isResendDisabled.value = false;
      }
    });
  }
}
