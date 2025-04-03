// import 'dart:convert';
// import 'package:drift/drift.dart';
//
// import '../models/workout.dart';
//
// class WorkoutMapConverter
//     extends TypeConverter<Map<String, List<Workout>>, String> {
//   const WorkoutMapConverter();
//
//   @override
//   Map<String, List<Workout>> fromSql(String fromDb) {
//     if (fromDb.isEmpty) return {};
//     final decoded = jsonDecode(fromDb) as Map<String, dynamic>;
//     return decoded.map((key, value) {
//       return MapEntry(
//           key, (value as List).map((e) => Workout.fromJson(e)).toList());
//     });
//   }
//
//   @override
//   String toSql(Map<String, List<Workout>> value) {
//     return jsonEncode(value.map((key, workouts) {
//       return MapEntry(key, workouts.map((w) => w.toJson()).toList());
//     }));
//   }
// }
