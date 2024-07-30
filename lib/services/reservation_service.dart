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
      debugPrint('getReservation - Response status: ${response.statusCode}');
      debugPrint('getReservation - Response body: ${response.body}');
      if (response.statusCode != 200) {
        debugPrint(response.body);
      }
      List<dynamic> body = jsonDecode(response.body);
      List<Reservation> reservations =
          body.map((dynamic item) => Reservation.fromJson(item)).toList();
      debugPrint('getReservation - Reservations: $reservations');
      return reservations;
    } catch (e) {
      debugPrint('getReservation - Exception: ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<bool> valideToRefuseReservation(
      String reservationId, String status) async {
    Uri url = Uri.parse("$baseUrl/validateOrRefuse");
    try {
      final token = await SharedPrefs.getAuthToken();
      debugPrint('Authorization Token: Bearer $token');
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
      debugPrint('valideToRefuseReservation - Response status: ${response.statusCode}');
      debugPrint('valideToRefuseReservation - Response body: ${response.body}');
      if (response.statusCode != 200) {
        debugPrint(response.body);
        return false;
      }
      return true;
    } catch (e) {
      debugPrint('valideToRefuseReservation - Exception: ${e.toString()}');
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
      debugPrint('createReservation - Response status: ${response.statusCode}');
      debugPrint('createReservation - Response body: ${response.body}');
      if (response.statusCode != 201) {
        debugPrint(response.body);
        return false;
      }
      return true;
    } catch (e) {
      debugPrint('createReservation - Exception: ${e.toString()}');
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
      debugPrint('getCurrentReservation - Response status: ${response.statusCode}');
      debugPrint('getCurrentReservation - Response body: ${response.body}');
      if (response.statusCode != 200) {
        debugPrint(response.body);
        return null;
      }
      List<dynamic> body = jsonDecode(response.body);
      debugPrint('getCurrentReservation - Body: $body');
      if (body.isNotEmpty) {
        List<Reservation> reservations = body.map((dynamic item) => Reservation.fromJson(item)).toList();
        debugPrint('getCurrentReservation - Reservations: $reservations');
        return reservations[0];
      }
      return null;
    } catch (e) {
      debugPrint('getCurrentReservation - Exception: ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<List<Reservation>> getLockerHistory(String lockerId) async {
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
      debugPrint('getLockerHistory - Response status: ${response.statusCode}');
      debugPrint('getLockerHistory - Response body: ${response.body}');
      if (response.statusCode != 200) {
        debugPrint(response.body);
        return [];
      }
      List<dynamic> body = jsonDecode(response.body);
      List<Reservation> history = body.map((dynamic reservation) {
        
        return Reservation.fromJson(reservation);
      }).toList();
      debugPrint('getLockerHistory - History: $history');
      return history;
    } catch (e) {
      debugPrint('getLockerHistory - Exception: ${e.toString()}');
      throw Exception(e.toString());
    }
  }

 Future<bool> terminateReservation(String reservationId) async {
  Uri url = Uri.parse("$baseUrl/terminateReservation");
  try {
    final token = await SharedPrefs.getAuthToken();
    final bodyData = jsonEncode({
      'reservationId': reservationId,
    });

    debugPrint('Authorization Token: Bearer $token'); 
    debugPrint('reservationId $reservationId'); 
    debugPrint('terminateReservation - Request URL: $url');
    debugPrint('terminateReservation - Request Headers: ${{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    }}');
    debugPrint('terminateReservation - Request Body: $bodyData');

    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: bodyData,
    );

    debugPrint('terminateReservation - Response status: ${response.statusCode}');
    debugPrint('terminateReservation - Response body: ${response.body}');
    if (response.statusCode != 200) {
      debugPrint('terminateReservation - Error: ${response.body}');
      return false;
    }
    return true;
  } catch (e) {
    debugPrint('terminateReservation - Exception: ${e.toString()}');
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
      debugPrint('leaveReservation - Response status: ${response.statusCode}');
      debugPrint('leaveReservation - Response body: ${response.body}');
      if (response.statusCode != 200) {
        debugPrint(response.body);
        return false;
      }
      return true;
    } catch (e) {
      debugPrint('leaveReservation - Exception: ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
