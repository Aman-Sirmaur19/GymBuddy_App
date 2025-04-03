import 'package:flutter/material.dart';
import 'package:drift/drift.dart';

import '../database/database.dart' as database;
import '../models/workout_set.dart' as model;

class WorkoutSetProvider extends ChangeNotifier {
  final database.AppDatabase db;
  List<model.WorkoutSet> _workoutSets = [];

  WorkoutSetProvider(this.db);

  /// Load all workout sets from the database
  Future<void> loadWorkoutSets() async {
    final workoutSetData = await db.getAllWorkoutSets();
    _workoutSets = workoutSetData
        .map((ws) => model.WorkoutSet.fromJson(ws.id.toString(), ws.toJson()))
        .toList();
    notifyListeners();
  }

  List<model.WorkoutSet> get workoutSets => _workoutSets;

  /// Add a new workout set
  Future<void> addWorkoutSet(model.WorkoutSet workoutSet) async {
    final workoutSetCompanion = database.WorkoutSetsCompanion(
      id: Value(workoutSet.id),
      workoutId: Value(workoutSet.workoutId),
      exerciseId: Value(workoutSet.exerciseId),
      set: Value(workoutSet.set),
      reps: Value(workoutSet.reps),
      weight: Value(workoutSet.weight),
      isCompleted: Value(workoutSet.isCompleted.join(',')), // Store as comma-separated string
    );

    final id = await db.addWorkoutSet(workoutSetCompanion);
    _workoutSets.add(workoutSet.copyWith(id: id));
    notifyListeners();
  }

  /// Update an existing workout set
  Future<void> updateWorkoutSet(model.WorkoutSet workoutSet) async {
    final workoutSetCompanion = database.WorkoutSetsCompanion(
      id: Value(workoutSet.id),
      workoutId: Value(workoutSet.workoutId),
      exerciseId: Value(workoutSet.exerciseId),
      set: Value(workoutSet.set),
      reps: Value(workoutSet.reps),
      weight: Value(workoutSet.weight),
      isCompleted: Value(workoutSet.isCompleted.join(',')), // Convert list to string
    );

    await db.updateWorkoutSet(workoutSetCompanion);

    final index = _workoutSets.indexWhere((ws) => ws.id == workoutSet.id);
    if (index != -1) _workoutSets[index] = workoutSet;
    notifyListeners();
  }

  /// Delete a workout set
  Future<void> deleteWorkoutSet(String id) async {
    await db.deleteWorkoutSet(id);
    _workoutSets.removeWhere((ws) => ws.id == id);
    notifyListeners();
  }

  /// Get all workout sets for a specific workout
  List<model.WorkoutSet> getAllWorkoutSetsForWorkout(String workoutId) {
    return _workoutSets.where((ws) => ws.workoutId == workoutId).toList();
  }

  /// Get all workout sets for a specific workout and exercise
  List<model.WorkoutSet> getWorkoutSetsForExercise(String workoutId, String exerciseId) {
    return _workoutSets.where((ws) => ws.workoutId == workoutId && ws.exerciseId == exerciseId).toList();
  }

  /// Mark a workout set as completed for today
  Future<void> markSetCompleted(String workoutId, String exerciseId) async {
    final today = DateTime.now().toIso8601String().split('T').first;
    final index = _workoutSets.indexWhere((ws) => ws.workoutId == workoutId && ws.exerciseId == exerciseId);

    if (index != -1) {
      final updatedSet = _workoutSets[index];
      if (!updatedSet.isCompleted.contains(today)) {
        final newCompletedList = [...updatedSet.isCompleted, today];
        final newSet = updatedSet.copyWith(isCompleted: newCompletedList);
        await updateWorkoutSet(newSet);
      }
    }
  }

  /// Unmark a workout set for today
  Future<void> unmarkSetCompleted(String workoutId, String exerciseId) async {
    final today = DateTime.now().toIso8601String().split('T').first;
    final index = _workoutSets.indexWhere((ws) => ws.workoutId == workoutId && ws.exerciseId == exerciseId);

    if (index != -1) {
      final updatedSet = _workoutSets[index];
      final newCompletedList = updatedSet.isCompleted.where((date) => date != today).toList();
      final newSet = updatedSet.copyWith(isCompleted: newCompletedList);
      await updateWorkoutSet(newSet);
    }
  }

  /// Check if a workout set is completed today
  bool isSetCompletedToday(String workoutId, String exerciseId) {
    final today = DateTime.now().toIso8601String().split('T').first;
    final workoutSet = _workoutSets.firstWhere(
          (ws) => ws.workoutId == workoutId && ws.exerciseId == exerciseId,
      orElse: () => model.WorkoutSet(
        id: '',
        workoutId: workoutId,
        exerciseId: exerciseId,
        set: 0,
        reps: 0,
        weight: 0.0,
        isCompleted: [],
      ),
    );

    return workoutSet.isCompleted.contains(today);
  }
}
