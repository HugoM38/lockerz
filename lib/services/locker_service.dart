import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lockerz/models/locker_model.dart';
import '../utils/shared_prefs.dart';

class LockerService {
  var baseUrl = 'http://localhost:5001/api/locker';

  Future<List<Locker>> getLockers() async {
    Uri url = Uri.parse("$baseUrl/");
    try {
      final response = await http.get(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await SharedPrefs.getAuthToken()}'
          });
      List<dynamic> body = jsonDecode(response.body);
      List<Locker> lockers = body.map((dynamic item) => Locker.fromJson(item)).toList();
      return lockers;
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
        return false;
      }
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> createLocker(Map<String, dynamic> lockerData) async {
    Uri url = Uri.parse("$baseUrl/create");
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await SharedPrefs.getAuthToken()}'
        },
        body: jsonEncode(lockerData),
      );
      if (response.statusCode != 201) {
        return false;
      }
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> changeLockerStatus(String lockerId, String status) async {
    Uri url = Uri.parse("$baseUrl/changeStatus");
    try {
      final response = await http.patch(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await SharedPrefs.getAuthToken()}'
        },
        body: jsonEncode({
          'id': lockerId,
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
}
