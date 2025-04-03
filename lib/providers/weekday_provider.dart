import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../database/database.dart' as database;
import '../models/weekday.dart';

class WeekdayProvider extends ChangeNotifier {
  final database.AppDatabase db;
  List<Weekday> _weekdays = [];

  WeekdayProvider(this.db);

  /// Load all weekdays from the database
  Future<void> loadWeekdays() async {
    final weekdayData = await db.getAllWeekdays();
    _weekdays = weekdayData.map((w) {
      return Weekday.fromJson({
        'id': w.id,
        'day': w.day,
        'workoutIds': jsonDecode(w.workoutIds),
        'exercises': w.exercises != null
            ? Map<String, List<String>>.from(
                (jsonDecode(w.exercises) as Map<String, dynamic>).map(
                  (key, value) =>
                      MapEntry(key as String, List<String>.from(value)),
                ),
              )
            : <String, List<String>>{},
      });
    }).toList();
    notifyListeners();
  }

  List<Weekday> get weekdays => _weekdays;

  /// Add a workout to a specific weekday
  Future<void> addWorkoutToWeekday(String day, String workoutId) async {
    int existingIndex = _weekdays.indexWhere((w) => w.day == day);
    Weekday updatedWeekday;

    if (existingIndex != -1) {
      final existing = _weekdays[existingIndex];
      final updatedWorkoutIds = [...existing.workoutIds, workoutId];
      final updatedExercises =
          Map<String, List<String>>.from(existing.exercises);
      updatedExercises[workoutId] = []; // Initialize exercises for new workout

      updatedWeekday = Weekday(
        id: existing.id,
        day: existing.day,
        workoutIds: updatedWorkoutIds,
        exercises: updatedExercises,
      );
      _weekdays[existingIndex] = updatedWeekday;
    } else {
      updatedWeekday = Weekday(
        id: const Uuid().v4(),
        day: day,
        workoutIds: [workoutId],
        exercises: {workoutId: []}, // Initialize with empty exercises
      );
      _weekdays.add(updatedWeekday);
    }

    await db.upsertWeekday(updatedWeekday);
    notifyListeners();
  }

  /// Remove a workout from a specific weekday
  Future<void> removeWorkoutFromWeekday(String day, String workoutId) async {
    final existingIndex = _weekdays.indexWhere((w) => w.day == day);
    if (existingIndex == -1) return;

    final existing = _weekdays[existingIndex];
    final updatedWorkoutIds = List<String>.from(existing.workoutIds)
      ..remove(workoutId);
    final updatedExercises = Map<String, List<String>>.from(existing.exercises);
    updatedExercises
        .remove(workoutId); // Remove exercises linked to the workout

    final updatedWeekday = Weekday(
      id: existing.id,
      day: existing.day,
      workoutIds: updatedWorkoutIds,
      exercises: updatedExercises,
    );

    await db.upsertWeekday(updatedWeekday);
    _weekdays[existingIndex] = updatedWeekday;
    notifyListeners();
  }

  /// Add an exercise to a specific workout in a weekday
  Future<void> addExerciseToWorkout(
      String day, String workoutId, String exerciseId) async {
    final existingIndex = _weekdays.indexWhere((w) => w.day == day);
    if (existingIndex == -1) return;

    final existing = _weekdays[existingIndex];
    final updatedExercises = Map<String, List<String>>.from(existing.exercises);

    if (!updatedExercises.containsKey(workoutId)) {
      updatedExercises[workoutId] = [];
    }

    if (!updatedExercises[workoutId]!.contains(exerciseId)) {
      updatedExercises[workoutId]!.add(exerciseId);
    }

    final updatedWeekday = Weekday(
      id: existing.id,
      day: existing.day,
      workoutIds: existing.workoutIds,
      exercises: updatedExercises,
    );

    await db.upsertWeekday(updatedWeekday);
    _weekdays[existingIndex] = updatedWeekday;
    notifyListeners();
  }

  /// Remove an exercise from a specific workout in a weekday
  Future<void> removeExerciseFromWorkout(
      String day, String workoutId, String exerciseId) async {
    final existingIndex = _weekdays.indexWhere((w) => w.day == day);
    if (existingIndex == -1) return;

    final existing = _weekdays[existingIndex];
    final updatedExercises = Map<String, List<String>>.from(existing.exercises);

    if (updatedExercises.containsKey(workoutId)) {
      updatedExercises[workoutId]!.remove(exerciseId);
    }

    final updatedWeekday = Weekday(
      id: existing.id,
      day: existing.day,
      workoutIds: existing.workoutIds,
      exercises: updatedExercises,
    );

    await db.upsertWeekday(updatedWeekday);
    _weekdays[existingIndex] = updatedWeekday;
    notifyListeners();
  }

  /// Get full details of a particular weekday including workouts and exercises
  Future<Map<String, dynamic>?> getWeekdayData(String day) async {
    final weekday = _weekdays.firstWhere(
      (w) => w.day == day,
      orElse: () => Weekday(id: '', day: '', workoutIds: [], exercises: {}),
    );

    // Return null if no data found
    if (weekday.id.isEmpty) return null;

    // Fetch workouts from database
    final workouts = await db.getWorkoutsByIds(weekday.workoutIds);
    final workoutDetails = workouts
        .map((w) => {
              'id': w.id,
              'title': w.title,
              'description': w.description,
              'exercises':
                  weekday.exercises[w.id] ?? [], // Exercises for this workout
            })
        .toList();

    return {
      'id': weekday.id,
      'day': weekday.day,
      'workouts': workoutDetails,
    };
  }
}
