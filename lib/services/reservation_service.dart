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
      final token = await SharedPrefs.getAuthToken();
      debugPrint('Authorization Token: Bearer $token'); // Affichage du jeton
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (response.statusCode != 200) {
        debugPrint(response.body);
      }
      List<dynamic> body = jsonDecode(response.body);
      List<Reservation> reservations =
          body.map((dynamic item) => Reservation.fromJson(item)).toList();
      return reservations;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> valideToRefuseReservation(
      String reservationId, String status) async {
    Uri url = Uri.parse("$baseUrl/validateOrRefuse");
    try {
      final token = await SharedPrefs.getAuthToken();
      debugPrint('Authorization Token: Bearer $token'); // Affichage du jeton
      final response = await http.patch(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
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

  Future<bool> createReservation(
      String lockerId, List<String> membersId) async {
    Uri url = Uri.parse("$baseUrl/create");
    try {
      final token = await SharedPrefs.getAuthToken();
      debugPrint('Authorization Token: Bearer $token'); // Affichage du jeton
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
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

  Future<Reservation?> getCurrentReservation() async {
    Uri url = Uri.parse("$baseUrl/getCurrentReservation");
    try {
      final token = await SharedPrefs.getAuthToken();
      debugPrint('Authorization Token: Bearer $token');  // Affichage du jeton
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (response.statusCode != 200) {
        debugPrint(response.body);
        return null;
      }
      List<dynamic> body = jsonDecode(response.body);
      if (body.isNotEmpty) {
        List<Reservation> reservations = body.map((dynamic item) => Reservation.fromJson(item)).toList();
        return reservations[0];
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<String>> getLockerHistory(String lockerId) async {
    Uri url = Uri.parse("$baseUrl/getLockerReservations/$lockerId");
    try {
      final token = await SharedPrefs.getAuthToken();
      debugPrint('Authorization Token: Bearer $token');
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (response.statusCode != 200) {
        debugPrint(response.body);
        return [];
      }
      List<dynamic> body = jsonDecode(response.body);
      List<String> history = body.map((dynamic item) {
        final owner =
            item['owner']['firstname'] + ' ' + item['owner']['lastname'];
        final members = (item['members'] as List)
            .map((member) => member['firstname'] + ' ' + member['lastname'])
            .join(', ');
        return 'Owner: $owner, Members: $members';
      }).toList();
      return history;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> terminateReservation(String reservationId) async {
    Uri url = Uri.parse("$baseUrl/terminateReservation");
    try {
      final response = await http.patch(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await SharedPrefs.getAuthToken()}'
        },
        body: jsonEncode({
          'reservationId': reservationId,
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

  Future<bool> leaveReservation(String reservationId) async {
    Uri url = Uri.parse("$baseUrl/leaveReservation");
    try {
      final token = await SharedPrefs.getAuthToken();
      debugPrint('Authorization Token: Bearer $token'); // Affichage du jeton
      final response = await http.patch(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'reservationId': reservationId,
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
