import 'dart:convert';
import 'package:drift/drift.dart';

import '../models/weekday.dart';

part 'database.g.dart';

@DataClassName('User')
class Users extends Table {
  TextColumn get id =>
      text().withDefault(const Constant('1'))(); // Single user entry
  TextColumn get name => text()();

  TextColumn get gender => text()();

  RealColumn get weight => real()();

  RealColumn get height => real()();

  TextColumn get weekDays => text()(); // JSON encoded list of weekdays

  @override
  Set<Column> get primaryKey => {id}; // Define primary key
}

@DataClassName('Exercise')
class Exercises extends Table {
  TextColumn get id => text().withLength(min: 1, max: 36)(); // UUID
  TextColumn get name => text()();

  TextColumn get force => text()();

  TextColumn get level => text()();

  TextColumn get mechanic => text()();

  TextColumn get equipment => text()();

  TextColumn get primaryMuscles => text()(); // JSON encoded list
  TextColumn get secondaryMuscles => text()(); // JSON encoded list
  TextColumn get instructions => text()(); // JSON encoded list
  TextColumn get category => text()();

  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id}; // Primary key
}

@DataClassName('Workout')
class Workouts extends Table {
  TextColumn get id => text().withLength(min: 1, max: 36)(); // UUID
  TextColumn get title => text()();

  TextColumn get description => text().nullable()();

  TextColumn get metadata => text()(); // JSON encoded metadata

  @override
  Set<Column> get primaryKey => {id}; // Primary key
}

@DataClassName('WorkoutSet')
class WorkoutSets extends Table {
  TextColumn get id => text().withLength(min: 1, max: 36)(); // UUID

  TextColumn get workoutId => text()
      .customConstraint('NOT NULL REFERENCES Workouts(id)')(); // Foreign Key

  TextColumn get exerciseId => text()
      .customConstraint('NOT NULL REFERENCES Exercises(id)')(); // Foreign Key

  TextColumn get sessionId => text().withLength(
      min: 1, max: 36)(); // Unique session identifier (date or UUID)

  IntColumn get set =>
      integer()(); // 0 = warmup, 1..n = normal sets, last = drop set

  IntColumn get reps => integer()();

  RealColumn get weight => real()();

  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id}; // Primary key
}

@DataClassName('WeekdayWorkout')
class WeekdayWorkouts extends Table {
  TextColumn get id => text().withLength(min: 1, max: 36)(); // UUID
  TextColumn get day => text()(); // e.g., "Monday", "Tuesday"
  TextColumn get workoutIds => text()();

  TextColumn get exercises => text().withDefault(const Constant('{}'))();

  TextColumn get activeWorkout => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('JournalEntry')
class Journals extends Table {
  TextColumn get id => text().withLength(min: 1, max: 36)();

  TextColumn get note => text()();

  TextColumn get date => text()(); // e.g. 2025-04-06
  TextColumn get time => text()(); // e.g. 2025-04-07T15:45:00.000Z

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  Users,
  Exercises,
  Workouts,
  WorkoutSets,
  WeekdayWorkouts,
  Journals,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 2; // increment when schema changes

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from == 1) {
            await m.createTable(journals); // create the new table
          }
        },
      );

  Future<User?> getUser() async {
    return select(users).getSingleOrNull();
  }

  Future<void> updateUser(UsersCompanion user) async {
    await into(users).insertOnConflictUpdate(user);
  }

  Future<List<Exercise>> getAllExercises() async {
    return select(exercises).get();
  }

  Future<String> addExercise(ExercisesCompanion exercise) async {
    await into(exercises).insertOnConflictUpdate(exercise);
    return exercise.id.value; // Return the ID after insertion
  }

  Future<void> updateExercise(ExercisesCompanion exercise) async {
    await update(exercises).replace(exercise);
  }

  Future<void> deleteExercise(String id) async {
    await (delete(exercises)..where((e) => e.id.equals(id))).go();
  }

  Future<List<Workout>> getAllWorkouts() async {
    return select(workouts).get();
  }

  Future<String> addWorkout(WorkoutsCompanion workout) async {
    await into(workouts).insertOnConflictUpdate(workout);
    return workout.id.value;
  }

  Future<void> updateWorkout(WorkoutsCompanion workout) async {
    await (update(workouts)..where((w) => w.id.equals(workout.id.value)))
        .write(workout);
  }

  Future<void> deleteWorkout(String id) async {
    await (delete(workouts)..where((w) => w.id.equals(id))).go();
  }

  Future<List<WorkoutSet>> getAllWorkoutSets() async {
    return select(workoutSets).get();
  }

  Future<String> addWorkoutSet(WorkoutSetsCompanion workoutSet) async {
    await into(workoutSets).insertOnConflictUpdate(workoutSet);
    return workoutSet.id.value;
  }

  Future<void> updateWorkoutSet(WorkoutSetsCompanion workoutSet) async {
    await (update(workoutSets)
          ..where((ws) => ws.id.equals(workoutSet.id.value)))
        .write(workoutSet);
  }

  Future<void> deleteWorkoutSet(String id) async {
    await (delete(workoutSets)..where((ws) => ws.id.equals(id))).go();
  }

  Future<List<WeekdayWorkout>> getAllWeekdays() async {
    return select(weekdayWorkouts).get();
  }

  Future<void> upsertWeekday(Weekday weekday) async {
    await into(weekdayWorkouts).insertOnConflictUpdate(
      WeekdayWorkoutsCompanion(
        id: Value(weekday.id),
        day: Value(weekday.day),
        workoutIds: Value(jsonEncode(weekday.workoutIds)),
        exercises: Value(jsonEncode(weekday.exercises)),
        activeWorkout: Value(weekday.activeWorkout),
      ),
    );
  }

  Future<List<Workout>> getWorkoutsByIds(List<String> ids) async {
    return (select(workouts)..where((w) => w.id.isIn(ids))).get();
  }

  Future<List<JournalEntry>> getAllJournals() async {
    return select(journals).get();
  }

  Future<void> insertJournal(JournalsCompanion journal) async {
    await into(journals).insertOnConflictUpdate(journal);
  }

  Future<void> deleteJournalById(String id) async {
    await (delete(journals)..where((j) => j.id.equals(id))).go();
  }

  Future<List<JournalEntry>> getJournalsByDate(DateTime date) async {
    final dateString = date.toIso8601String().split('T').first;
    return (select(journals)
          ..where((j) => j.date.equals(dateString))
          ..orderBy([(j) => OrderingTerm.desc(j.time)]))
        .get();
  }
}
