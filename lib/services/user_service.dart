import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';
import '../utils/shared_prefs.dart';

class UserService {
  var baseUrl = 'http://localhost:5001/api/user';

  Future<bool> editUserInformations(String firstname, String lastname) async {
    Uri url = Uri.parse("$baseUrl/edit");
    try {
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
        debugPrint(response.body);
        return false;
      }
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> editUserPassword(String oldPassword, String newPassword) async {
    Uri url = Uri.parse("$baseUrl/editPassword");
    try {
      debugPrint(await SharedPrefs.getAuthToken());
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

      if (response.statusCode != 201) {
        debugPrint(response.body);
        return false;
      }
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> deleteUser() async {
    Uri url = Uri.parse("$baseUrl/delete");
    try {
      var response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ await SharedPrefs.getAuthToken()}'
        },
      );
      debugPrint(response.body);
      if (response.statusCode != 204) {
        debugPrint(response.body);
        return false;
      }
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<User>> getUsers() async{
    Uri url = Uri.parse("$baseUrl/");
    try {
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ await SharedPrefs.getAuthToken()}'
        },
      );
      if (response.statusCode != 200) {
        debugPrint(response.body);
      }
      List<dynamic> body = jsonDecode(response.body);
      List<User> users = body.map((dynamic item) => User.fromJson(item)).toList();
      return users;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<User> getUser(String id) async{
    Uri url = Uri.parse("$baseUrl/$id");
    try {
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ await SharedPrefs.getAuthToken()}'
        },
      );
      if (response.statusCode != 200) {
        debugPrint(response.body);
      }
      dynamic body = jsonDecode(response.body);
      User user = User.fromJson(body);
      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<http.Response> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/forgotPassword'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return response;
  }

  Future<http.Response> resetPassword(String email, String code, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/resetPassword'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'code': code,
        'newPassword': newPassword,
      }),
    );
    return response;
  }
}