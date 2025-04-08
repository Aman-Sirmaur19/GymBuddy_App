import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/exercise.dart';
import '../../models/workout_set.dart';
import '../../widgets/workout_table.dart';
import '../../providers/exercise_provider.dart';
import '../../providers/workout_set_provider.dart';

class StartSessionScreen extends StatelessWidget {
  final String weekday;
  final Map<String, dynamic> workoutData;

  const StartSessionScreen({
    super.key,
    required this.weekday,
    required this.workoutData,
  });

  void _finishSession(BuildContext context) {
    final workoutSetProvider =
        Provider.of<WorkoutSetProvider>(context, listen: false);

    // Get all sets for the current workout
    List<WorkoutSet> allSets =
        workoutSetProvider.getAllWorkoutSetsForWorkout(workoutData['id']);

    // Mark each set as completed
    for (var set in allSets) {
      if (!set.isCompleted) {
        workoutSetProvider.updateWorkoutSet(set.copyWith(isCompleted: true));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final exerciseProvider =
        Provider.of<ExerciseProvider>(context, listen: false);
    final workoutSetProvider = Provider.of<WorkoutSetProvider>(context);
    List<Exercise> exercises = workoutData['exercises']
        .map<Exercise>((id) => exerciseProvider.getExerciseById(id)!)
        .where((Exercise exercise) => exercise.id.isNotEmpty)
        .toList();
    int exercisesLeft = exercises.where((Exercise exercise) {
      List<WorkoutSet> sets = workoutSetProvider.getWorkoutSetsForExercise(
          workoutData['id'], exercise.id);

      return sets.any((set) => !set.isCompleted);
    }).length;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back',
          icon: const Icon(CupertinoIcons.chevron_back),
        ),
        titleSpacing: 0,
        leadingWidth: 48,
        toolbarHeight: 100,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '$exercisesLeft',
              style: TextStyle(
                fontSize: 75,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(width: 5),
            RichText(
              text: TextSpan(
                text: exercisesLeft < 2 ? 'Exercise\n' : 'Exercises\n',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                children: [
                  TextSpan(
                    text: 'Left',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: () => _finishSession(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Finish Session'),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          return WorkoutTable(
            workoutId: workoutData['id'],
            exerciseId: exercises[index].id,
          );
        },
      ),
    );
  }
}
