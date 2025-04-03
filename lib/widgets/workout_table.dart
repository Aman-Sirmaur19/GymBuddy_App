import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/workout_set.dart';
import '../providers/exercise_provider.dart';
import '../providers/workout_set_provider.dart';
import 'custom_text_form_field.dart';
import 'custom_elevated_button.dart';

class WorkoutTable extends StatefulWidget {
  final String workoutId;
  final String exerciseId;

  const WorkoutTable({
    super.key,
    required this.workoutId,
    required this.exerciseId,
  });

  @override
  State<WorkoutTable> createState() => _WorkoutTableState();
}

class _WorkoutTableState extends State<WorkoutTable> {
  bool _allSetsCompleted = false;

  void _showAddSetModal() {
    TextEditingController setController = TextEditingController();
    TextEditingController repController = TextEditingController();
    TextEditingController weightController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Add New Set",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: setController,
                hintText: 'Set',
                icon: Icons.format_list_numbered_rounded,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (value) {
                  setController.text = value;
                },
                isFilter: false,
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: repController,
                hintText: 'Reps',
                icon: Icons.replay_rounded,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (value) {
                  repController.text = value;
                },
                isFilter: false,
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: weightController,
                hintText: 'Weight (Kg)',
                icon: Icons.fitness_center_rounded,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (value) {
                  weightController.text = value;
                },
                isFilter: false,
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                onPressed: () {
                  if (setController.text.isNotEmpty &&
                      repController.text.isNotEmpty &&
                      weightController.text.isNotEmpty) {
                    setState(() {
                      final workoutSetProvider =
                          Provider.of<WorkoutSetProvider>(context,
                              listen: false);
                      workoutSetProvider.addWorkoutSet(WorkoutSet(
                        id: const Uuid().v4(),
                        workoutId: widget.workoutId,
                        exerciseId: widget.exerciseId,
                        set: int.parse(setController.text),
                        reps: int.parse(repController.text),
                        weight: double.parse(weightController.text),
                        isCompleted: [],
                      ));
                    });
                    Navigator.pop(context);
                  }
                },
                label: 'Add Set',
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _deleteSet(String id) {
    final workoutSetProvider =
        Provider.of<WorkoutSetProvider>(context, listen: false);
    workoutSetProvider.deleteWorkoutSet(id).then((value) => setState(() {}));
  }

  void _toggleAllSets(bool markAsCompleted, List<WorkoutSet> workoutSets) {
    setState(() {
      final workoutSetProvider =
          Provider.of<WorkoutSetProvider>(context, listen: false);
      String today = _getTodayDate();

      for (var workoutSet in workoutSets) {
        List<String> updatedCompletion = List.from(workoutSet.isCompleted);

        if (markAsCompleted) {
          if (!updatedCompletion.contains(today)) {
            updatedCompletion.add(today);
          }
        } else {
          updatedCompletion.remove(today);
        }

        workoutSetProvider.updateWorkoutSet(
          workoutSet.copyWith(isCompleted: updatedCompletion),
        );
      }
    });
  }

  void _toggleCompletion(WorkoutSet workoutSet) {
    setState(() {
      final workoutSetProvider =
          Provider.of<WorkoutSetProvider>(context, listen: false);
      List<String> updatedCompletion = List.from(workoutSet.isCompleted);
      String today = _getTodayDate();
      if (updatedCompletion.contains(today)) {
        updatedCompletion.remove(today);
      } else {
        updatedCompletion.add(today);
      }

      workoutSetProvider.updateWorkoutSet(
        workoutSet.copyWith(isCompleted: updatedCompletion),
      );
    });
  }

  String _getTodayDate() {
    return DateTime.now().toIso8601String().split('T')[0]; // e.g., "2025-04-03"
  }

  @override
  Widget build(BuildContext context) {
    final exerciseProvider = Provider.of<ExerciseProvider>(context);
    final exercise = exerciseProvider.getExerciseById(widget.exerciseId)!;
    final workoutSetProvider = Provider.of<WorkoutSetProvider>(context);
    List<WorkoutSet> workoutSets = workoutSetProvider.getWorkoutSetsForExercise(
        widget.workoutId, widget.exerciseId);
    _allSetsCompleted = workoutSets.isNotEmpty &&
        workoutSets.every((set) => set.isCompleted.contains(_getTodayDate()));
    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).colorScheme.primaryContainer),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  exercise.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (workoutSets.isNotEmpty)
                Checkbox(
                  checkColor: Colors.green,
                  value: _allSetsCompleted,
                  onChanged: (bool? checked) {
                    _toggleAllSets(checked ?? false, workoutSets);
                  },
                ),
              IconButton(
                onPressed: _showAddSetModal,
                tooltip: 'Add set',
                icon: const Icon(Icons.add_circle_outline_rounded),
              ),
            ],
          ),
          const SizedBox(height: 5),
          if (workoutSets.isEmpty) const Center(child: Text('Add set')),
          if (workoutSets.isNotEmpty)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(Icons.fitness_center_rounded,
                        size: 30, color: Colors.deepPurpleAccent)),
                Expanded(
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                      3: FlexColumnWidth(1),
                      4: FlexColumnWidth(1)
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                        ),
                        children: const [
                          TableCell(
                              child: Center(
                                  child: Text(
                            "SET",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ))),
                          TableCell(
                              child: Center(
                                  child: Text(
                            "REP",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ))),
                          TableCell(
                              child: Center(
                                  child: Text(
                            "WT (kg)",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ))),
                          TableCell(
                              child: Center(
                                  child: Text(
                            "Status",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ))),
                          TableCell(
                              child: Center(
                                  child: Text(
                            "Delete",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ))),
                        ],
                      ),
                      for (int i = 0; i < workoutSets.length; i++)
                        TableRow(
                          children: [
                            for (var value in [
                              workoutSets[i].set,
                              workoutSets[i].reps,
                              workoutSets[i].weight.toStringAsFixed(0),
                            ])
                              TableCell(child: Center(child: Text('$value'))),
                            TableCell(
                                child: Center(
                                    child: Checkbox(
                              checkColor: Colors.green,
                              value: workoutSets[i]
                                  .isCompleted
                                  .contains(_getTodayDate()),
                              onChanged: (bool? checked) {
                                _toggleCompletion(workoutSets[i]);
                              },
                            ))),
                            TableCell(
                                child: IconButton(
                                    onPressed: () => showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text("Delete Set"),
                                            content: const Text(
                                                "Are you sure you want to delete set from exercise?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(ctx),
                                                child: Text("Cancel",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary)),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  _deleteSet(workoutSets[i].id);
                                                  Navigator.pop(ctx);
                                                },
                                                child: const Text("Delete",
                                                    style: TextStyle(
                                                        color: Colors.red)),
                                              ),
                                            ],
                                          ),
                                        ),
                                    tooltip: 'Delete',
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red))),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
