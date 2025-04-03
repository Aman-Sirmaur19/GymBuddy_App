import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../database/database.dart' as database;
import '../models/exercise.dart' as model;
import 'package:drift/drift.dart';

class ExerciseProvider extends ChangeNotifier {
  final database.AppDatabase db;
  List<model.Exercise> _exercises = [];

  ExerciseProvider(this.db);

  Future<void> loadExercisesFromAssets() async {
    final String jsonString =
        await rootBundle.loadString('assets/exercises.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);

    for (var entry in jsonData.entries) {
      try {
        _exercises.add(model.Exercise.fromJson(entry.key, entry.value));
      } catch (e) {
        print("Error parsing exercise with ID: ${entry.key}, Error: $e");
      }
    }
  }

  Future<void> loadCustomExercises() async {
    final customExercises = await db.getAllExercises();
    _exercises.addAll(customExercises
        .map((e) => model.Exercise.fromJson(e.id, e.toJson(), isCustom: true)));
  }

  Future<void> loadAllExercises() async {
    await loadExercisesFromAssets();
    await loadCustomExercises();
  }

  List<model.Exercise> get exercises => _exercises;

  Future<void> addCustomExercise(model.Exercise exercise) async {
    final exerciseCompanion = database.ExercisesCompanion(
      id: Value(exercise.id),
      // Ensure an ID is assigned before insertion
      name: Value(exercise.name),
      force: Value(exercise.force),
      level: Value(exercise.level),
      mechanic: Value(exercise.mechanic),
      equipment: Value(exercise.equipment),
      primaryMuscles: Value(jsonEncode(exercise.primaryMuscles)),
      secondaryMuscles: Value(jsonEncode(exercise.secondaryMuscles)),
      instructions: Value(jsonEncode(exercise.instructions)),
      category: Value(exercise.category),
      isCustom: Value(exercise.isCustom),
    );

    final id = await db.addExercise(exerciseCompanion); // Now returns String
    _exercises.add(exercise.copyWith(id: id, isCustom: true));
    notifyListeners();
  }

  Future<void> updateCustomExercise(model.Exercise exercise) async {
    final exerciseCompanion = database.ExercisesCompanion(
      id: Value(exercise.id),
      name: Value(exercise.name),
      force: Value(exercise.force),
      level: Value(exercise.level),
      mechanic: Value(exercise.mechanic),
      equipment: Value(exercise.equipment),
      primaryMuscles: Value(jsonEncode(exercise.primaryMuscles)),
      secondaryMuscles: Value(jsonEncode(exercise.secondaryMuscles)),
      instructions: Value(jsonEncode(exercise.instructions)),
      category: Value(exercise.category),
      isCustom: Value(exercise.isCustom),
    );

    await db.updateExercise(exerciseCompanion);
    final index = _exercises.indexWhere((e) => e.id == exercise.id);
    if (index != -1) _exercises[index] = exercise;
    notifyListeners();
  }

  Future<void> deleteCustomExercise(String id) async {
    await db.deleteExercise(id);
    _exercises.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  model.Exercise? getExerciseById(String id) {
    return _exercises.firstWhere((e) => e.id == id,
        orElse: () => model.Exercise(
            id: '',
            name: '',
            force: '',
            level: '',
            mechanic: '',
            equipment: '',
            primaryMuscles: [],
            secondaryMuscles: [],
            instructions: [],
            category: '',
            isCustom: false));
  }
}
