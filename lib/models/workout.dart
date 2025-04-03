import 'dart:convert';

class Workout {
  final String id;
  final String title;
  final String description;
  final Map<String, dynamic> metadata;

  Workout({
    required this.id,
    required this.title,
    required this.description,
    required this.metadata,
  });

  /// Factory constructor to create a `Workout` from JSON
  factory Workout.fromJson(String id, Map<String, dynamic> json) {
    return Workout(
      id: id,
      title: json['title'],
      description: json['description'] ?? '',
      metadata: (json['metadata'] is String)
          ? jsonDecode(json['metadata'])
          : json['metadata'] ?? {},
    );
  }

  /// Converts `Workout` object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'metadata': metadata,
    };
  }

  /// Creates a copy of `Workout` with optional modifications
  Workout copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? exerciseIds,
    Map<String, dynamic>? metadata,
  }) {
    return Workout(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      metadata: metadata ?? this.metadata,
    );
  }
}
