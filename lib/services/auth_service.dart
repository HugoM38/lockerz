import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/shared_prefs.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:5001/api/auth'; // Remplacez par l'URL de votre API

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final token = responseData['token'];

      await SharedPrefs.saveAuthToken(token);

      return true;
    } else {
      return false;
    }
  }

  Future<bool> register(String firstname, String lastname, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'firstname': firstname, 'lastname': lastname, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      final token = responseData['token'];

      // Store token in SharedPreferences
      await SharedPrefs.saveAuthToken(token);

      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    await SharedPrefs.removeAuthToken();
  }

  Future<String?> getAuthToken() async {
    return await SharedPrefs.getAuthToken();
  }
}
