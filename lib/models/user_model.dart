class User {
  String id;
  String firstname;
  String lastname;
  String email;
  String role;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.role,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstname': firstname,
      'lastname': lastname,
      'role': role,
      'email': email,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      role: json['role'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
