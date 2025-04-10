import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/weekday_provider.dart';
import '../../providers/exercise_provider.dart';
import '../../providers/workout_set_provider.dart';
import '../exercise_search_screen.dart';
import 'exercise details/exercise_details_tab.dart';

class ExercisesTab extends StatefulWidget {
  final String weekday;
  final Map<String, dynamic> workoutData;

  const ExercisesTab({
    super.key,
    required this.weekday,
    required this.workoutData,
  });

  @override
  State<ExercisesTab> createState() => _ExercisesTabState();
}

class _ExercisesTabState extends State<ExercisesTab> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WeekdayProvider>(builder: (context, weekdayProvider, _) {
      return FutureBuilder<Map<String, dynamic>?>(
          future: weekdayProvider.getWeekdayData(widget.weekday),
          builder: (context, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (dataSnapshot.hasError) {
              return Center(child: Text('Error: ${dataSnapshot.error}'));
            } else if (!dataSnapshot.hasData || dataSnapshot.data == null) {
              return const Center(child: Text('No data found.'));
            }

            Map<String, dynamic> allData = dataSnapshot.data!;
            if (allData['workouts'].isEmpty) {
              return const Center(child: Text('No workouts added yet.'));
            }
            final exerciseIds = widget.workoutData['exercises'];
            return ListView(
              padding: const EdgeInsets.only(top: 20),
              physics: const BouncingScrollPhysics(),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      exerciseIds.length < 2
                          ? '${exerciseIds.length} Exercise'
                          : '${exerciseIds.length} Exercises',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                        onPressed: () => Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => ExerciseSearchScreen(
                                      weekDay: widget.weekday,
                                      workoutData: widget.workoutData,
                                    ))),
                        child: const Text(
                          'Add / Remove',
                          style: TextStyle(color: Colors.deepPurpleAccent),
                        )),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: exerciseIds.length,
                    itemBuilder: (context, index) {
                      final exerciseProvider =
                          Provider.of<ExerciseProvider>(context);
                      final workoutSetProvider =
                          Provider.of<WorkoutSetProvider>(context);
                      final exercise =
                          exerciseProvider.getExerciseById(exerciseIds[index])!;

                      // Get all today's workout sets for this exercise
                      String todaySessionId =
                          DateTime.now().toIso8601String().split('T').first;
                      final workoutSets = workoutSetProvider
                          .getWorkoutSetsForExercise(
                              widget.workoutData['id'], exercise.id)
                          .where((set) => set.sessionId == todaySessionId)
                          .toList();
                      final totalSets = workoutSets.length;
                      final totalReps =
                          workoutSets.fold(0, (sum, ws) => sum + ws.reps);
                      final totalWeight =
                          workoutSets.fold(0.0, (sum, ws) => sum + ws.weight);
                      return Column(
                        children: [
                          InkWell(
                            onTap: () => Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => ExerciseDetailsTab(
                                  workoutId: widget.workoutData['id'],
                                  exercise: exercise,
                                ),
                              ),
                            ),
                            child: _customRow(
                              title: exercise.name,
                              value:
                                  '$totalSets ${totalSets < 2 ? 'set' : 'sets'}  •  $totalReps ${totalReps < 2 ? 'rep' : 'reps'}  •  ${totalWeight.toStringAsFixed(1)} kg',
                              context: context,
                            ),
                          ),
                          if (index < exerciseIds.length - 1)
                            Divider(
                              height: 20,
                              thickness: .2,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          });
    });
  }

  Widget _customRow({
    required String title,
    required String value,
    required BuildContext context,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                value,
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
              ),
            ],
          ),
        ),
        Icon(
          CupertinoIcons.chevron_forward,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ],
    );
  }
}
