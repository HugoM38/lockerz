class Localisation {
  String id;
  String name;
  bool accessibility;

  Localisation({
    required this.id,
    required this.name,
    required this.accessibility,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'accessibility': accessibility,
    };
  }

  factory Localisation.fromJson(Map<String, dynamic> json) {
    return Localisation(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      accessibility: json['accessibility'] as bool? ?? false,
    );
  }
}
