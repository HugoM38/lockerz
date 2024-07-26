import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/shared_prefs.dart';

class AuthService {
  static const String baseUrl =
      'http://localhost:5001/api/auth';

  Future<http.Response> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final token = responseData['token'];

      final user = responseData['user'];

      await SharedPrefs.saveAuthToken(token);
      await SharedPrefs.saveUserInformation(jsonEncode(user));
    }
    return response;
  }

  Future<http.Response> register(
      String firstname, String lastname, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'password': password
      }),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      final token = responseData['token'];

      await SharedPrefs.saveAuthToken(token);
      await SharedPrefs.saveUserInformation(jsonEncode(responseData['user']));
    }

    return response;
  }

  Future<void> logout() async {
    await SharedPrefs.removeAuthToken();
  }

  Future<String?> getAuthToken() async {
    return await SharedPrefs.getAuthToken();
  }
}
