import 'dart:convert';

import 'package:http/http.dart' as http;

var baseUrl = 'http://localhost:5001/api/user/';

Future<String> editUserInformations(String firstname, String lastname) async {
  Uri url = Uri.parse("${baseUrl}edit");
  try {
    var response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ await SharedPrefsManager.getToken()}'
      },
      body: jsonEncode({
        'firstname': firstname,
        'lastname': lastname
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
    return response.body;
  } catch (e) {
    throw Exception(e.toString());
  }
}

Future<String> editUserPassword(String oldPassword, String newPassword) async {
  Uri url = Uri.parse("${baseUrl}editPassword");
  try {
    var response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ await SharedPrefsManager.getToken()}'
      },
      body: jsonEncode({
        'oldPassword': oldPassword,
        'newPassword': newPassword
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
    return response.body;
  } catch (e) {
    throw Exception(e.toString());
  }
}

Future<String> deleteUser() async {
  Uri url = Uri.parse("${baseUrl}delete/");
  try {
    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ await SharedPrefsManager.getToken()}'
      },
    );
    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
    return response.body;
  } catch (e) {
    throw Exception(e.toString());
  }
}
