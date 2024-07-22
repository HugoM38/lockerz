import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthController {
  final AuthService _authService = AuthService();

  Future<void> signIn(String email, String password, BuildContext context) async {
    try {
      final success = await _authService.login(email, password);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connexion réussie')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec de la connexion')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de connexion: ${e.toString()}')),
      );
    }
  }

  Future<void> signUp(User user, BuildContext context) async {
    try {
      final success = await _authService.register(user.firstname, user.lastname, user.email, user.password);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Inscription réussie')),
        );
        // Naviguer vers la page d'accueil ou autre
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec de l\'inscription')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur d\'inscription: ${e.toString()}')),
      );
    }
  }

  Future<void> logout(BuildContext context) async {
    await _authService.logout();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Déconnexion réussie')),
    );
    // Naviguer vers la page de connexion ou autre
  }

  Future<bool> isLoggedIn() async {
    final token = await _authService.getAuthToken();
    return token != null;
  }
}
