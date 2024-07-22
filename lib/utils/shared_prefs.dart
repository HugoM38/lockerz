import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SharedPrefs {
  static const String _authTokenKey = 'authToken';
  static const String _firstName = 'firstName';
  static const String _lastName = 'lastName';

  static Future<void> saveAuthToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token);
    Fluttertoast.showToast(msg: "Token enregistré dans SharedPreferences");
  }

  static Future<String?> getAuthToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }

  static Future<void> removeAuthToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
    Fluttertoast.showToast(msg: "Token supprimé de SharedPreferences");
  }

  static Future<void> saveUserInformation(String firstName, String lastName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_firstName, firstName);
    await prefs.setString(_lastName, lastName);
    debugPrint("SAVED");
    Fluttertoast.showToast(msg: "Token enregistré dans SharedPreferences");
  }

  static Future<String?> getFirstName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_firstName);
  }

  static Future<String?> getLastName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastName);
  }

  static Future<void> removeUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_firstName);
    await prefs.remove(_lastName);
    Fluttertoast.showToast(msg: "Informations de l'utilisateur supprimées de SharedPreferences");
  }

}
