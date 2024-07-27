import 'package:lockerz/models/localisation_model.dart';
import 'package:lockerz/models/reservation_model.dart';

class Locker {
  String id;
  int number;
  Localisation localisation;
  String status;
  List<Reservation> reservations;

  Locker({
    required this.id,
    required this.number,
    required this.localisation,
    required this.status,
    required this.reservations,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'number': number,
      'localisation': localisation.toJson(),
      'status': status,
      'reservations': reservations.map((u) => u.toJson()).toList(),
    };
  }

  factory Locker.fromJson(Map<String, dynamic> json) {
    return Locker(
      id: json['_id'] as String? ?? '',
      number: json['number'] as int? ?? 0,
      localisation: Localisation.fromJson(json['localisation'] as Map<String, dynamic>),
      status: json['status'] as String? ?? '',
      reservations: (json['reservations'] as List<dynamic>? ?? [])
          .map((i) => Reservation.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }
}
