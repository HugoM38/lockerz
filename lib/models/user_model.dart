class User {
  String id;
  String firstname;
  String lastname;
  String? email;
  String? password;
  String role;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.role,
    this.email,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstname': firstname,
      'lastname': lastname,
      'role': role,
      'email': email,
      'password': password,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      role: json['role'] ?? '',
      email: json['email'],
      password: json['password'],
    );
  }
}
