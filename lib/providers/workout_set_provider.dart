import 'package:flutter/material.dart';
import 'package:drift/drift.dart';

import '../database/database.dart' as database;
import '../models/workout_set.dart' as model;

class WorkoutSetProvider extends ChangeNotifier {
  final database.AppDatabase db;
  List<model.WorkoutSet> _workoutSets = [];

  WorkoutSetProvider(this.db);

  Future<void> loadWorkoutSets() async {
    final workoutSetData = await db.getAllWorkoutSets();
    _workoutSets = workoutSetData
        .map((ws) => model.WorkoutSet.fromJson(ws.id.toString(), ws.toJson()))
        .toList();
    notifyListeners();
  }

  List<model.WorkoutSet> get workoutSets => _workoutSets;

  Future<void> addWorkoutSet(model.WorkoutSet workoutSet) async {
    final workoutSetCompanion = database.WorkoutSetsCompanion(
      id: Value(workoutSet.id),
      workoutId: Value(workoutSet.workoutId),
      exerciseId: Value(workoutSet.exerciseId),
      sessionId: Value(workoutSet.sessionId),
      set: Value(workoutSet.set),
      reps: Value(workoutSet.reps),
      weight: Value(workoutSet.weight),
      isCompleted: Value(workoutSet.isCompleted),
    );

    final id = await db.addWorkoutSet(workoutSetCompanion);
    _workoutSets.add(workoutSet.copyWith(id: id));
    notifyListeners();
  }

  Future<void> updateWorkoutSet(model.WorkoutSet workoutSet) async {
    final workoutSetCompanion = database.WorkoutSetsCompanion(
      id: Value(workoutSet.id),
      workoutId: Value(workoutSet.workoutId),
      exerciseId: Value(workoutSet.exerciseId),
      sessionId: Value(workoutSet.sessionId),
      set: Value(workoutSet.set),
      reps: Value(workoutSet.reps),
      weight: Value(workoutSet.weight),
      isCompleted: Value(workoutSet.isCompleted),
    );

    await db.updateWorkoutSet(workoutSetCompanion);

    final index = _workoutSets.indexWhere((ws) => ws.id == workoutSet.id);
    if (index != -1) _workoutSets[index] = workoutSet;
    notifyListeners();
  }

  Future<void> deleteWorkoutSet(String id) async {
    await db.deleteWorkoutSet(id);
    _workoutSets.removeWhere((ws) => ws.id == id);
    notifyListeners();
  }

  List<model.WorkoutSet> getAllWorkoutSetsForWorkout(String workoutId) {
    return _workoutSets.where((ws) => ws.workoutId == workoutId).toList();
  }

  List<model.WorkoutSet> getWorkoutSetsForExercise(String workoutId, String exerciseId) {
    return _workoutSets.where((ws) =>
    ws.workoutId == workoutId && ws.exerciseId == exerciseId).toList();
  }

  List<model.WorkoutSet> getWorkoutSetsForSession(String sessionId) {
    return _workoutSets.where((ws) => ws.sessionId == sessionId).toList();
  }

  Future<void> markSetCompleted(String id) async {
    final index = _workoutSets.indexWhere((ws) => ws.id == id);
    if (index != -1) {
      final updatedSet = _workoutSets[index].copyWith(isCompleted: true);
      await updateWorkoutSet(updatedSet);
    }
  }

  Future<void> unmarkSetCompleted(String id) async {
    final index = _workoutSets.indexWhere((ws) => ws.id == id);
    if (index != -1) {
      final updatedSet = _workoutSets[index].copyWith(isCompleted: false);
      await updateWorkoutSet(updatedSet);
    }
  }

  bool isSetCompleted(String id) {
    final set = _workoutSets.firstWhere(
          (ws) => ws.id == id,
      orElse: () => model.WorkoutSet(
        id: '',
        workoutId: '',
        exerciseId: '',
        sessionId: '',
        set: 0,
        reps: 0,
        weight: 0,
        isCompleted: false,
      ),
    );
    return set.isCompleted;
  }
}
