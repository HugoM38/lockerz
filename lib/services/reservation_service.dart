import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:lockerz/models/reservation_model.dart';
import '../utils/shared_prefs.dart';

class ReservationService {
  var baseUrl = 'http://localhost:5001/api/reservation';

  Future<List<Reservation>> getReservation() async {
    Uri url = Uri.parse("$baseUrl/pendingReservation");
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
      List<Reservation> reservations = body.map((dynamic item) => Reservation.fromJson(item)).toList();
      return reservations;
    } catch (e) {
      throw Exception(e.toString());
    }
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

  Future<bool> createReservation(String lockerId, List<String> membersId) async {
    print(await SharedPrefs.getAuthToken());
    Uri url = Uri.parse("$baseUrl/create");
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await SharedPrefs.getAuthToken()}'
        },
        body: jsonEncode({
          'lockerId': lockerId,
          'members': membersId,
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
}
