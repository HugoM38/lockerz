import 'dart:ffi';
import 'package:lockerz/models/localisation_model.dart';
import 'package:lockerz/models/reservation_model.dart';

class Locker {
  Int number;
  Localisation localisation;
  String status;
  List<Reservation> reservations;

  Locker({
    required this.number,
    required this.localisation,
    required this.status,
    required this.reservations,
  });

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'localisation': localisation,
      'status': status,
      'reservations': reservations,
    };
  }

  factory Locker.fromJson(Map<String, dynamic> json) {
    return Locker(
      number: json['number'],
      localisation: json['localisation'],
      status: json['status'],
      reservations: json['reservations'],
    );
  }
}
