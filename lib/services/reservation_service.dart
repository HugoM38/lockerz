import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lockerz/models/reservation_model.dart';
import '../utils/shared_prefs.dart';

class ReservationService {
  var baseUrl = 'http://localhost:5001/api/reservation';

  Future<List<Reservation>> getReservation() async {
    Uri url = Uri.parse("$baseUrl/pendingReservation");
    try {
      final token = await SharedPrefs.getAuthToken();
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

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
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode != 200) {
        return null;
      }
      List<dynamic> body = jsonDecode(response.body);

      if (body.isNotEmpty) {
        List<Reservation> reservations =
            body.map((dynamic item) => Reservation.fromJson(item)).toList();
        return reservations[0];
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Reservation>> getLockerHistory(String lockerId) async {
    Uri url = Uri.parse("$baseUrl/getLockerReservations/$lockerId");
    try {
      final token = await SharedPrefs.getAuthToken();
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode != 200) {
        return [];
      }
      List<dynamic> body = jsonDecode(response.body);
      List<Reservation> history = body.map((dynamic reservation) {
        return Reservation.fromJson(reservation);
      }).toList();
      return history;
    } catch (e) {
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

      final response = await http.patch(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: bodyData,
      );

      if (response.statusCode != 200) {
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
        return false;
      }
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
