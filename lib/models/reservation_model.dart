class Reservation {
  String id;
  String locker;
  String owner;
  List<String> members;
  String status;

  Reservation({
    required this.id,
    required this.members,
    required this.owner,
    required this.locker,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'members': members,
      'owner': owner,
      'locker': locker,
      'status': status,
    };
  }

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['_id'],
      members: List<String>.from(json['members']),
      owner: json['owner'],
      locker: json['locker'],
      status: json['status'],
    );
  }
}