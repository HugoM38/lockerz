class Localisation {
  String name;
  bool accessibility;

  Localisation({
    required this.name,
    required this.accessibility,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'accessibility': accessibility,
    };
  }

  factory Localisation.fromJson(Map<String, dynamic> json) {
    return Localisation(
      name: json['name'],
      accessibility: json['localisation'],
    );
  }
}