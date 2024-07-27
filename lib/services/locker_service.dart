import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:lockerz/models/locker_model.dart';
import '../utils/shared_prefs.dart';

class LockerService {
  var baseUrl = 'http://localhost:5001/api/locker';

  Future<List<Locker>> getLockers() async {
    Uri url = Uri.parse("$baseUrl/");
    //try {
      final response = await http.get(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await SharedPrefs.getAuthToken()}'
          });
      if (response.statusCode != 200) {
        debugPrint(response.body);
      }
      debugPrint(response.body);

      List<dynamic> body = jsonDecode(response.body);
      List<Locker> lockers = body.map((dynamic item) => Locker.fromJson(item)).toList();
      return lockers;
    /**} catch (e) {
      throw Exception(e.toString());
    }*/
  }

  Future<bool> valideToRefuseReservation(String reservationId, String status) async {
    Uri url = Uri.parse("$baseUrl/validateOrRefuse");
    try {
      final response = await http.patch(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await SharedPrefs.getAuthToken()}'
        },
        body: jsonEncode({
          'reservationId': reservationId,
          'status': status,
        }),
      );
      if (response.statusCode != 200) {
        debugPrint(response.body);
        return false;
      }
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
