import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:lockerz/models/localisation_model.dart';
import 'package:http/http.dart' as http;

import '../utils/shared_prefs.dart';

class LocalisationService {
  var baseUrl = 'http://localhost:5001/api/localisation';

  Future<List<Localisation>> getLocalisation() async {
    Uri url = Uri.parse("$baseUrl/");
    try {
      final response = await http.get(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await SharedPrefs.getAuthToken()}'
          });
      if (response.statusCode != 200) {
        debugPrint(response.body);
      }
      List<dynamic> body = jsonDecode(response.body);
      List<Localisation> lockers = body.map((dynamic item) => Localisation.fromJson(item))
          .toList();
      return lockers;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}