import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SharedPrefs {
  static const String _authTokenKey = 'authToken';

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
}
