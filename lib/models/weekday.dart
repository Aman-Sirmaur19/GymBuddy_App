class Weekday {
  final String id;
  final String day;
  final List<String> workoutIds;
  final Map<String, List<String>> exercises;
  final String activeWorkout;

  Weekday({
    required this.id,
    required this.day,
    required this.workoutIds,
    required this.exercises,
    required this.activeWorkout,
  });

  factory Weekday.fromJson(Map<String, dynamic> json) {
    return Weekday(
      id: json['id'],
      day: json['day'],
      workoutIds: List<String>.from(json['workoutIds']),
      exercises: (json['exercises'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, List<String>.from(value)),
      ),
      activeWorkout: json['activeWorkout'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day': day,
      'workoutIds': workoutIds,
      'exercises': exercises.map((key, value) => MapEntry(key, value)),
      'activeWorkout': activeWorkout,
    };
  }
}
