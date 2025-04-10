import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/exercise.dart';
import '../../models/workout_set.dart';
import '../../providers/exercise_provider.dart';
import '../../providers/weekday_provider.dart';
import '../../providers/workout_set_provider.dart';

class MusclesTab extends StatelessWidget {
  final String weekday;
  final Map<String, dynamic> workoutData;

  const MusclesTab({
    super.key,
    required this.weekday,
    required this.workoutData,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer3<WeekdayProvider, ExerciseProvider, WorkoutSetProvider>(
      builder:
          (context, weekdayProvider, exerciseProvider, workoutSetProvider, _) {
        return FutureBuilder<Map<String, dynamic>?>(
          future: weekdayProvider.getWeekdayData(weekday),
          builder: (context, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (dataSnapshot.hasError) {
              return Center(child: Text('Error: ${dataSnapshot.error}'));
            } else if (!dataSnapshot.hasData || dataSnapshot.data == null) {
              return const Center(child: Text('No data found.'));
            }

            final exerciseIds = workoutData['exercises'] ?? [];
            final Map<String, double> primaryMuscles = {};
            final Map<String, double> secondaryMuscles = {};

            for (final exerciseId in exerciseIds) {
              final Exercise? exercise =
                  exerciseProvider.getExerciseById(exerciseId);
              if (exercise == null) continue;

              String todaySessionId =
                  DateTime.now().toIso8601String().split('T').first;
              final List<WorkoutSet> workoutSets = workoutSetProvider
                  .getWorkoutSetsForExercise(workoutData['id'], exercise.id)
                  .where((set) => set.sessionId == todaySessionId)
                  .toList();
              final int totalSets = workoutSets.length;
              final int totalReps =
                  workoutSets.fold(0, (sum, ws) => sum + ws.reps);
              final double totalWeight =
                  workoutSets.fold(0.0, (sum, ws) => sum + ws.weight);
              final double score =
                  totalSets * 1.0 + totalReps * 0.1 + totalWeight * 0.01;

              for (final muscle in exercise.primaryMuscles) {
                final m = _capitalize(muscle);
                primaryMuscles[m] = (primaryMuscles[m] ?? 0) + score;
              }

              for (final muscle in exercise.secondaryMuscles) {
                final m = _capitalize(muscle);
                if (!primaryMuscles.containsKey(m)) {
                  secondaryMuscles[m] =
                      (secondaryMuscles[m] ?? 0) + score * 0.25;
                }
              }
            }
            final sortedPrimary = primaryMuscles.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));
            final sortedSecondary = secondaryMuscles.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));
            final topStacks = <MapEntry<String, double>>[];
            final otherPrimaryMuscles = <MapEntry<String, double>>[];
            MapEntry<String, double>? blueStackEntry;

            if (sortedPrimary.length <= 3) {
              topStacks.addAll(sortedPrimary);
              if (sortedPrimary.length == 3) {
                blueStackEntry = sortedPrimary[2];
              }
            } else {
              topStacks.addAll(sortedPrimary.take(2)); // red and amber
              otherPrimaryMuscles.addAll(sortedPrimary.skip(2));
              blueStackEntry = MapEntry(
                'Other',
                otherPrimaryMuscles.fold(0.0, (sum, e) => sum + e.value),
              );
            }

            final allStackValues = [
              ...topStacks,
              if (blueStackEntry != null) blueStackEntry
            ];
            final maxStackValue = allStackValues
                .map((e) => e.value)
                .fold(1.0, (prev, curr) => curr > prev ? curr : prev);
            final otherMusclesList = [
              ...sortedSecondary,
              ...otherPrimaryMuscles,
            ];
            return ListView(
              padding: const EdgeInsets.only(top: 25),
              physics: const BouncingScrollPhysics(),
              children: [
                const Text(
                  'Most Involved',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                if (topStacks.isNotEmpty)
                  _customStack(
                    topStacks[0].key,
                    Colors.red,
                    topStacks[0].value / maxStackValue,
                    context,
                  ),
                if (topStacks.length > 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: _customStack(
                      topStacks[1].key,
                      Colors.amber,
                      topStacks[1].value / maxStackValue,
                      context,
                    ),
                  ),
                if (blueStackEntry != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: _customStack(
                      blueStackEntry.key,
                      Colors.blue,
                      blueStackEntry.value / maxStackValue,
                      context,
                    ),
                  ),
                const SizedBox(height: 30),
                // Show only if blue stack was "Other"
                if (otherMusclesList.isNotEmpty) ...[
                  const Text(
                    'Other Includes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: Column(
                      children: List.generate(otherMusclesList.length, (index) {
                        final entry = otherMusclesList[index];
                        return Column(
                          children: [
                            _customRow(
                              entry.key,
                              _getMuscleState(
                                  entry.key, primaryMuscles, secondaryMuscles),
                              context,
                            ),
                            if (index != otherMusclesList.length - 1)
                              Divider(
                                thickness: .2,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }

  String _capitalize(String str) {
    if (str.isEmpty) return str;
    return str[0].toUpperCase() + str.substring(1);
  }

  String _getMuscleState(String muscle, Map<String, double> primaryMuscles,
      Map<String, double> secondaryMuscles) {
    final score = primaryMuscles[muscle] ?? secondaryMuscles[muscle] ?? 0.0;
    return score >= 5.0 ? 'Tired' : 'Rested';
  }

  Widget _customStack(
    String label,
    Color color,
    double value,
    BuildContext context,
  ) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        LinearProgressIndicator(
          value: value.clamp(0.0, 1.0),
          minHeight: 50,
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _customRow(String title, String value, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            color: value == 'Tired'
                ? Colors.red.shade800
                : Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ],
    );
  }
}
