class Locker {
  String id;
  int number;
  String localisation;
  String status;
  List<String> reservations;

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
      'localisation': localisation,
      'status': status,
      'reservations': reservations,
    };
  }

  factory Locker.fromJson(Map<String, dynamic> json) {
    return Locker(
      id: json['_id'] ?? '',
      number: json['number'] ?? 0,
      localisation: json['localisation'] ?? '',
      status: json['status'] ?? '',
      reservations: List<String>.from(json['reservations'] ?? []),
    );
  }
}
