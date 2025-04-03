class Exercise {
  final String id;
  final String name;
  final String force;
  final String level;
  final String mechanic;
  final String equipment;
  final List<String> primaryMuscles;
  final List<String> secondaryMuscles;
  final List<String> instructions;
  final String category;
  final bool isCustom;

  Exercise({
    required this.id,
    required this.name,
    required this.force,
    required this.level,
    required this.mechanic,
    required this.equipment,
    required this.primaryMuscles,
    required this.secondaryMuscles,
    required this.instructions,
    required this.category,
    this.isCustom = false,
  });

  factory Exercise.fromJson(String id, Map<String, dynamic> json,
      {bool isCustom = false}) {
    return Exercise(
      id: id,
      name: json['name'] ?? 'Unknown',
      force: json['force'] ?? 'Unknown',
      level: json['level'] ?? 'Unknown',
      mechanic: json['mechanic'] ?? 'Unknown',
      equipment: json['equipment'] ?? 'Unknown',
      primaryMuscles: (json['primaryMuscles'] as List?)?.map((e) => e as String).toList() ?? [],
      secondaryMuscles: (json['secondaryMuscles'] as List?)?.map((e) => e as String).toList() ?? [],
      instructions: (json['instructions'] as List?)?.map((e) => e as String).toList() ?? [],
      category: json['category'] ?? 'Unknown',
      isCustom: isCustom,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'force': force,
      'level': level,
      'mechanic': mechanic,
      'equipment': equipment,
      'primaryMuscles': primaryMuscles,
      'secondaryMuscles': secondaryMuscles,
      'instructions': instructions,
      'category': category,
      'isCustom': isCustom,
    };
  }

  // Fix: Implement copyWith method
  Exercise copyWith({
    String? id,
    String? name,
    String? force,
    String? level,
    String? mechanic,
    String? equipment,
    List<String>? primaryMuscles,
    List<String>? secondaryMuscles,
    List<String>? instructions,
    String? category,
    bool? isCustom,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      force: force ?? this.force,
      level: level ?? this.level,
      mechanic: mechanic ?? this.mechanic,
      equipment: equipment ?? this.equipment,
      primaryMuscles: primaryMuscles ?? this.primaryMuscles,
      secondaryMuscles: secondaryMuscles ?? this.secondaryMuscles,
      instructions: instructions ?? this.instructions,
      category: category ?? this.category,
      isCustom: isCustom ?? this.isCustom,
    );
  }
}
