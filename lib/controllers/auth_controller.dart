import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthController {
  final AuthService _authService = AuthService();

  Future<void> signIn(User user) async {
    final response = await _authService.login(user);
    if (response) {
    } else {
    }
  }

  Future<void> signUp(User user) async {
    final response = await _authService.register(user);
    if (response) {
    } else {
    }
  }
}
