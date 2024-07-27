import 'package:lockerz/models/user_model.dart';

import 'locker_model.dart';

class Reservation {
  String id;
  Locker locker;
  User owner;
  List<User> members;
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
      'members': members.map((u) => u.toJson()).toList(),
      'owner': owner.toJson(),
      'locker': locker.toJson(),
      'status': status,
    };
  }

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['_id'] ?? '',
      members: (json['members'] as List).map((i) => User.fromJson(i)).toList(),
      owner: User.fromJson(json['owner']),
      locker: Locker.fromJson(json['locker']),
      status: json['status'] ?? '',
    );
  }
}
