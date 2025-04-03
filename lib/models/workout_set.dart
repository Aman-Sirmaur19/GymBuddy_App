class WorkoutSet {
  final String id;
  final String workoutId;
  final String exerciseId;
  final int set;
  final int reps;
  final double weight;
  final List<String> isCompleted; // Store completed dates

  WorkoutSet({
    required this.id,
    required this.workoutId,
    required this.exerciseId,
    required this.set,
    required this.reps,
    required this.weight,
    required this.isCompleted,
  });

  factory WorkoutSet.fromJson(String id, Map<String, dynamic> json) {
    return WorkoutSet(
      id: id,
      workoutId: json['workoutId'],
      exerciseId: json['exerciseId'],
      set: json['set'],
      reps: json['reps'],
      weight: json['weight'].toDouble(),
      isCompleted: (json['isCompleted'] as String).isNotEmpty
          ? (json['isCompleted'] as String).split(',')
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workoutId': workoutId,
      'exerciseId': exerciseId,
      'set': set,
      'reps': reps,
      'weight': weight,
      'isCompleted': isCompleted.join(','),
    };
  }

  WorkoutSet copyWith({
    String? id,
    String? workoutId,
    String? exerciseId,
    int? set,
    int? reps,
    double? weight,
    List<String>? isCompleted,
  }) {
    return WorkoutSet(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      exerciseId: exerciseId ?? this.exerciseId,
      set: set ?? this.set,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      isCompleted: isCompleted ??
          List.from(this.isCompleted), // Ensure a new list instance
    );
  }

  /// Add current date to isCompleted list
  WorkoutSet markCompleted() {
    final today =
        DateTime.now().toIso8601String().split('T').first; // Get YYYY-MM-DD
    if (!isCompleted.contains(today)) {
      return copyWith(isCompleted: [...isCompleted, today]); // Add date
    }
    return this;
  }

  /// Remove current date from isCompleted list
  WorkoutSet unmarkCompleted() {
    final today = DateTime.now().toIso8601String().split('T').first;
    return copyWith(
        isCompleted:
            isCompleted.where((date) => date != today).toList()); // Remove date
  }

  /// Check if today's date is in the isCompleted list
  bool isCompletedToday() {
    final today = DateTime.now().toIso8601String().split('T').first;
    return isCompleted.contains(today);
  }
}
