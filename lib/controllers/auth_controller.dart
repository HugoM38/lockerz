import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../views/shared/snackbar.dart';

class AuthController {
  final AuthService _authService = AuthService();

  Future<void> logout(BuildContext context) async {
    await _authService.logout();
    if (context.mounted) {
      showCustomSnackBar(context, 'Déconnexion réussie');
    }
    if (context.mounted) {
      await Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _authService.getAuthToken();
    return token != null;
  }
}
