import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../models/exercise.dart';
import '../../../models/workout_set.dart';
import '../../../providers/workout_set_provider.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import 'history_tab.dart';

class ExerciseHistoryScreen extends StatefulWidget {
  final String workoutId;
  final Exercise exercise;

  const ExerciseHistoryScreen({
    super.key,
    required this.workoutId,
    required this.exercise,
  });

  @override
  State<ExerciseHistoryScreen> createState() => _ExerciseHistoryScreenState();
}

class _ExerciseHistoryScreenState extends State<ExerciseHistoryScreen> {
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
                        exerciseId: widget.exercise.id,
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

  @override
  Widget build(BuildContext context) {
    final workoutSetProvider =
        Provider.of<WorkoutSetProvider>(context, listen: false);
    List workoutSets = workoutSetProvider.getWorkoutSetsForExercise(
        widget.workoutId, widget.exercise.id);
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Sets overview',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton(
                onPressed: _showAddSetModal,
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.deepPurpleAccent),
                )),
          ],
        ),
        if (workoutSets.isEmpty) const Center(child: Text('Add set')),
        if (workoutSets.isNotEmpty)
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).colorScheme.secondaryContainer,
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
                        child: IconButton(
                            onPressed: () => showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text("Delete Set"),
                                    content: const Text(
                                        "Are you sure you want to delete set from exercise?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: Text("Cancel",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary)),
                                      ),
                                      TextButton(
                                        onPressed: () => workoutSetProvider
                                            .deleteWorkoutSet(workoutSets[i].id)
                                            .then((value) {
                                          setState(() {});
                                          Navigator.pop(ctx);
                                        }),
                                        child: const Text("Delete",
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                ),
                            tooltip: 'Delete',
                            icon: const Icon(Icons.delete, color: Colors.red))),
                  ],
                ),
            ],
          ),
        const SizedBox(height: 30),
        const SizedBox(height: 300, child: HistoryTab()),
      ],
    );
  }
}
