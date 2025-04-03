import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:drift/drift.dart';

import '../database/database.dart' as database;
import '../models/workout.dart' as model;

class WorkoutProvider extends ChangeNotifier {
  final database.AppDatabase db;
  List<model.Workout> _workouts = [];

  WorkoutProvider(this.db);

  /// Load all workouts from the database
  Future<void> loadWorkouts() async {
    final workoutData = await db.getAllWorkouts();
    _workouts = workoutData
        .map((w) => model.Workout.fromJson(w.id.toString(), w.toJson()))
        .toList();
  }

  List<model.Workout> get workouts => _workouts;

  /// Add a new workout
  Future<void> addWorkout(model.Workout workout) async {
    final workoutCompanion = database.WorkoutsCompanion(
      id: Value(workout.id),
      // Ensure ID is assigned before insertion
      title: Value(workout.title),
      description: Value(workout.description),
      metadata: Value(jsonEncode(workout.metadata)),
    );

    final id = await db.addWorkout(workoutCompanion);
    _workouts.add(workout.copyWith(id: id));
    notifyListeners();
  }

  /// Update an existing workout
  Future<void> updateWorkout(model.Workout workout) async {
    final workoutCompanion = database.WorkoutsCompanion(
      id: Value(workout.id),
      title: Value(workout.title),
      description: Value(workout.description),
      metadata: Value(jsonEncode(workout.metadata)),
    );

    await db.updateWorkout(workoutCompanion);

    final index = _workouts.indexWhere((w) => w.id == workout.id);
    if (index != -1) _workouts[index] = workout;
    notifyListeners();
  }

  /// Delete a workout
  Future<void> deleteWorkout(String id) async {
    await db.deleteWorkout(id);
    _workouts.removeWhere((w) => w.id == id);
    notifyListeners();
  }

  /// Get a workout by ID
  model.Workout? getWorkoutById(String id) {
    return _workouts.firstWhere(
      (w) => w.id == id,
      orElse: () => model.Workout(
        id: '',
        title: '',
        description: '',
        metadata: {},
      ),
    );
  }
}
