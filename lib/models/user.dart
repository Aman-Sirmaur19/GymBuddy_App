class User {
  final String id;
  final String name;
  final String gender;
  final double weight;
  final double height;
  final List<String> weekDays;

  User({
    required this.id,
    required this.name,
    required this.gender,
    required this.weight,
    required this.height,
    required this.weekDays,
  });

  factory User.fromJson(String id, Map<String, dynamic> json) {
    return User(
      id: id,
      name: json['name'],
      gender: json['gender'],
      weight: json['weight'].toDouble(),
      height: json['height'].toDouble(),
      weekDays: List<String>.from(json['weekDays']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'weight': weight,
      'height': height,
      'weekDays': weekDays,
    };
  }
}
