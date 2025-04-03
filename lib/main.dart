import 'dart:io';
import 'package:flutter/material.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/theme.dart';
import 'database/database.dart';
import 'providers/user_provider.dart';
import 'providers/weekday_provider.dart';
import 'providers/workout_provider.dart';
import 'providers/exercise_provider.dart';
import 'providers/workout_set_provider.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding/user_info_screen.dart';
import 'screens/onboarding/onboarding1_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await _initializeDatabase();

  final userProvider = UserProvider(database);
  final weekdayProvider = WeekdayProvider(database);
  final workoutProvider = WorkoutProvider(database);
  final exerciseProvider = ExerciseProvider(database);
  final workoutSetProvider = WorkoutSetProvider(database);

  await userProvider.loadUser();
  await weekdayProvider.loadWeekdays();
  await workoutProvider.loadWorkouts();
  await exerciseProvider.loadAllExercises();
  await workoutSetProvider.loadWorkoutSets();

  runApp(MyApp(
    userProvider: userProvider,
    weekdayProvider: weekdayProvider,
    workoutProvider: workoutProvider,
    exerciseProvider: exerciseProvider,
    workoutSetProvider: workoutSetProvider,
  ));
}

Future<AppDatabase> _initializeDatabase() async {
  final dbFolder = await getApplicationDocumentsDirectory();
  final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
  return AppDatabase(NativeDatabase(file));
}

class MyApp extends StatelessWidget {
  final UserProvider userProvider;
  final WeekdayProvider weekdayProvider;
  final WorkoutProvider workoutProvider;
  final ExerciseProvider exerciseProvider;
  final WorkoutSetProvider workoutSetProvider;

  const MyApp({
    super.key,
    required this.userProvider,
    required this.weekdayProvider,
    required this.workoutProvider,
    required this.exerciseProvider,
    required this.workoutSetProvider,
  });

  Future<Widget> _getInitialScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
      return const Onboarding1Screen();
    } else if (userProvider.user != null) {
      return const HomeScreen();
    } else {
      return const UserInfoScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>.value(value: userProvider),
        ChangeNotifierProvider<WeekdayProvider>.value(value: weekdayProvider),
        ChangeNotifierProvider<WorkoutProvider>.value(value: workoutProvider),
        ChangeNotifierProvider<ExerciseProvider>.value(value: exerciseProvider),
        ChangeNotifierProvider<WorkoutSetProvider>.value(
            value: workoutSetProvider),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GymBuddy',
        theme: lightMode,
        darkTheme: darkMode,
        home: FutureBuilder<Widget>(
          future: _getInitialScreen(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            }
            return snapshot.data ?? const UserInfoScreen();
          },
        ),
      ),
    );
  }
}
