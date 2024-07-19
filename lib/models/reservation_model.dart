import 'dart:ffi';

class Reservation {
  List<String> memberList;
  String owner;
  String lockerId;
  Int lockerNumber;

  Reservation({
    required this.memberList,
    required this.owner,
    required this.lockerId,
    required this.lockerNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'memberList': memberList,
      'owner': owner,
      'lockerId': lockerId,
      'lockerNumber': lockerNumber,
    };
  }

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      memberList: json['memberList'],
      owner: json['owner'],
      lockerId: json['lockerId'],
      lockerNumber: json['lockerNumber'],
    );
  }
}
