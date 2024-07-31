import 'dart:convert';

import 'package:lockerz/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String _authTokenKey = 'authToken';
  static const String _user = 'user';

  static Future<void> saveAuthToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token);
  }

  static Future<String?> getAuthToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }

  static Future<void> removeAuthToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
  }

  static Future<void> saveUserInformation(String user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_user, user);
  }

  static Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return User.fromJson(jsonDecode(prefs.getString(_user)!));
  }

  static Future<void> removeUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_user);
  }

}
