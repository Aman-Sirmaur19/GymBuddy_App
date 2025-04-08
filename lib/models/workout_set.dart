class WorkoutSet {
  final String id;
  final String workoutId;
  final String exerciseId;
  final String sessionId;
  final int set;
  final int reps;
  final double weight;
  final bool isCompleted;

  WorkoutSet({
    required this.id,
    required this.workoutId,
    required this.exerciseId,
    required this.sessionId,
    required this.set,
    required this.reps,
    required this.weight,
    this.isCompleted = false,
  });

  factory WorkoutSet.fromJson(String id, Map<String, dynamic> json) {
    return WorkoutSet(
      id: id,
      workoutId: json['workoutId'],
      exerciseId: json['exerciseId'],
      sessionId: json['sessionId'],
      set: json['set'],
      reps: json['reps'],
      weight: (json['weight'] as num).toDouble(),
      isCompleted: json['isCompleted'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workoutId': workoutId,
      'exerciseId': exerciseId,
      'sessionId': sessionId,
      'set': set,
      'reps': reps,
      'weight': weight,
      'isCompleted': isCompleted,
    };
  }

  WorkoutSet copyWith({
    String? id,
    String? workoutId,
    String? exerciseId,
    String? sessionId,
    int? set,
    int? reps,
    double? weight,
    bool? isCompleted,
  }) {
    return WorkoutSet(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      exerciseId: exerciseId ?? this.exerciseId,
      sessionId: sessionId ?? this.sessionId,
      set: set ?? this.set,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
