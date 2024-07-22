import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/shared_prefs.dart';

class UserService {
  var baseUrl = 'http://localhost:5001/api/user';

  Future<bool> editUserInformations(String firstname, String lastname) async {
    Uri url = Uri.parse("$baseUrl/edit");
    //try {
      final response = await http.patch(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ await SharedPrefs.getAuthToken()}'
        },
        body: jsonEncode({
          'firstname': firstname,
          'lastname': lastname
        }),
      );

      if (response.statusCode != 201) {
        throw Exception(response.body);
      }
      return true;
      /**
    } catch (e) {
      throw Exception(e.toString());
    }*/
  }

  Future<bool> editUserPassword(String oldPassword, String newPassword) async {
    Uri url = Uri.parse("${baseUrl}editPassword");
    try {
      var response = await http.patch(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ await SharedPrefs.getAuthToken()}'
        },
        body: jsonEncode({
          'oldPassword': oldPassword,
          'newPassword': newPassword
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(response.body);
      }
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> deleteUser() async {
    Uri url = Uri.parse("${baseUrl}delete/");
    try {
      var response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ await SharedPrefs.getAuthToken()}'
        },
      );
      if (response.statusCode != 200) {
        throw Exception(response.body);
      }
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}