import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lockerz/services/auth_service.dart';

class VerificationController {
  final TextEditingController codeController = TextEditingController();
  final AuthService _authService = AuthService();
  ValueNotifier<bool> isResendDisabled = ValueNotifier<bool>(false);
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  ValueNotifier<int> resendCooldown = ValueNotifier<int>(60);
  Timer? timer;

  void verifyCode(BuildContext context, String email) async {
    final code = codeController.text;

    if (code.isEmpty || code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez saisir un code de 6 chiffres')),
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await _authService.checkCode(email, code);

      if (context.mounted) {
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vérification réussie')),
          );
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Code incorrect')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Une erreur est survenue lors de la vérification')),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void resendCode(BuildContext context, String email) async {
    isResendDisabled.value = true;
    resendCooldown.value = 60;

    try {
      await _authService.sendCode(email);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Code renvoyé. Veuillez vérifier votre email.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Une erreur est survenue lors de l\'envoi du code')),
        );
      }
    }

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCooldown.value > 0) {
        resendCooldown.value--;
      } else {
        isResendDisabled.value = false;
        timer.cancel();
      }
    });
  }

  void dispose() {
    codeController.dispose();
    timer?.cancel();
    isResendDisabled.dispose();
    isLoading.dispose();
    resendCooldown.dispose();
  }
}
