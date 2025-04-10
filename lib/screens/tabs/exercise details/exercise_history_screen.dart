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
  bool _isAddingSet = false;
  String? _selectedSet;
  String? _selectedReps;
  String? _selectedWeight;

  void _showInputBottomSheet(String title, Function(String) onSubmit) {
    TextEditingController controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 16, right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Add $title",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 20),
            CustomTextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              hintText: title,
              icon: title == 'Reps'
                  ? Icons.replay_rounded
                  : Icons.fitness_center_rounded,
              onFieldSubmitted: (value) {
                onSubmit(value);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 100,
              child: CustomElevatedButton(
                onPressed: () {
                  onSubmit(controller.text);
                  Navigator.pop(context);
                },
                label: 'Add',
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getSetNumber(List<WorkoutSet> workoutSets) {
    if (_selectedSet == 'W') {
      return 0;
    } else if (_selectedSet == 'S') {
      final sSets = workoutSets.where((set) => set.set > 0).toList();
      if (sSets.isEmpty) return 1;
      final maxSet =
          sSets.map((set) => set.set).reduce((a, b) => a > b ? a : b);
      return maxSet + 1;
    } else if (_selectedSet == 'D') {
      return -1;
    } else {
      return int.tryParse(_selectedSet ?? '') ?? 0;
    }
  }

  void _deleteSet(String id) {
    final workoutSetProvider =
        Provider.of<WorkoutSetProvider>(context, listen: false);
    workoutSetProvider.deleteWorkoutSet(id).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final workoutSetProvider =
        Provider.of<WorkoutSetProvider>(context, listen: false);
    String todaySessionId = DateTime.now().toIso8601String().split('T').first;
    List<WorkoutSet> workoutSets = workoutSetProvider
        .getWorkoutSetsForExercise(widget.workoutId, widget.exercise.id)
        .where((set) => set.sessionId == todaySessionId)
        .toList();
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
                onPressed: () {
                  setState(() {
                    _isAddingSet = true;
                    _selectedSet = null;
                    _selectedReps = null;
                    _selectedWeight = null;
                  });
                },
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.deepPurpleAccent),
                )),
          ],
        ),
        if (workoutSets.isEmpty && !_isAddingSet)
          const Center(child: Text('Add set')),
        if (workoutSets.isNotEmpty || _isAddingSet)
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: const {
              0: FlexColumnWidth(.75),
              1: FlexColumnWidth(.75),
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
              // Existing Sets
              ...(() {
                final sortedSets = [...workoutSets];
                sortedSets.sort((a, b) {
                  int orderValue(WorkoutSet s) {
                    if (s.set == 0) return 0;
                    if (s.set == -1) return 2;
                    return 1; // normal sets
                  }

                  int orderA = orderValue(a);
                  int orderB = orderValue(b);

                  if (orderA != orderB) {
                    return orderA.compareTo(orderB);
                  }
                  return a.set.compareTo(b.set);
                });

                return sortedSets.map((set) {
                  return TableRow(
                    children: [
                      TableCell(
                        child: Center(
                          child: Text(
                            set.set == 0
                                ? 'W'
                                : set.set == -1
                                    ? 'D'
                                    : '${set.set}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: set.set == 0
                                  ? Colors.deepPurpleAccent
                                  : set.set == -1
                                      ? Colors.blue
                                      : null,
                            ),
                          ),
                        ),
                      ),
                      TableCell(child: Center(child: Text('${set.reps}'))),
                      TableCell(
                          child: Center(
                              child: Text(set.weight.toStringAsFixed(0)))),
                      TableCell(
                        child: IconButton(
                          icon: const Icon(Icons.delete_outline_rounded,
                              color: Colors.red),
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
                                  onPressed: () {
                                    _deleteSet(set.id);
                                    Navigator.pop(ctx);
                                  },
                                  child: const Text("Delete",
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList();
              })(),
              // New Set Row (Conditional)
              if (_isAddingSet)
                TableRow(
                  children: [
                    _buildSetButton(workoutSets),
                    _buildRepsButton(),
                    _buildWeightButton(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (_selectedSet != null &&
                                _selectedReps != null &&
                                _selectedWeight != null) {
                              final provider = Provider.of<WorkoutSetProvider>(
                                  context,
                                  listen: false);
                              final setNumber = _getSetNumber(workoutSets);
                              provider.addWorkoutSet(WorkoutSet(
                                id: const Uuid().v4(),
                                workoutId: widget.workoutId,
                                exerciseId: widget.exercise.id,
                                sessionId: DateTime.now()
                                    .toIso8601String()
                                    .split('T')
                                    .first,
                                set: setNumber,
                                reps: int.parse(_selectedReps!),
                                weight: double.parse(_selectedWeight!),
                                isCompleted: false,
                              ));
                              setState(() {
                                _isAddingSet = false;
                                _selectedSet = null;
                                _selectedReps = null;
                                _selectedWeight = null;
                              });
                            }
                          },
                          tooltip: 'Save',
                          icon: const Icon(Icons.check_circle_outline_rounded,
                              color: Colors.lightGreen),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isAddingSet = false;
                              _selectedSet = null;
                              _selectedReps = null;
                              _selectedWeight = null;
                            });
                          },
                          tooltip: 'Discard',
                          icon: Icon(Icons.cancel_outlined,
                              color: Colors.red.shade400),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        const SizedBox(height: 30),
        const SizedBox(height: 300, child: HistoryTab()),
      ],
    );
  }

  Widget _buildSetButton(List<WorkoutSet> workoutSets) {
    // Check if W and D are already present
    bool hasW = workoutSets.any((e) => e.set == 0);
    bool hasD = workoutSets.any((e) => e.set == -1);
    bool hasBothWD = hasW && hasD;

    // If both W and D exist, auto-select S
    if (_selectedSet == null && hasBothWD) {
      final sSets = workoutSets
          .where((e) => e.set != 0 && e.set != -1)
          .toList(); // only normal sets

      final lastSet = sSets.isNotEmpty
          ? sSets.map((e) => e.set).reduce((a, b) => a > b ? a : b)
          : 0;

      _selectedSet = (lastSet + 1).toString(); // auto-assign next S set
    }

    return Center(
      child: _selectedSet == null
          ? PopupMenuButton<String>(
              icon: const Icon(Icons.more_horiz),
              tooltip: 'Choose Set-Type',
              onSelected: (value) {
                if (value == 'S') {
                  final sSets = workoutSets
                      .where((e) => e.set != 0 && e.set != -1)
                      .toList();
                  final lastSet = sSets.isNotEmpty
                      ? sSets.map((e) => e.set).reduce((a, b) => a > b ? a : b)
                      : 0;
                  setState(() {
                    _selectedSet = (lastSet + 1).toString();
                  });
                } else {
                  setState(() {
                    _selectedSet = value == 'D' ? '-1' : value; // D as -1
                  });
                }
              },
              itemBuilder: (context) {
                final List<PopupMenuEntry<String>> items = [];
                if (!hasW) {
                  items.add(const PopupMenuItem(
                      value: 'W',
                      child: Text(
                        'W - Warmup',
                        style: TextStyle(color: Colors.deepPurpleAccent),
                      )));
                }
                items.add(const PopupMenuItem(
                    value: 'S', child: Text('S - Straight')));
                if (!hasD) {
                  items.add(const PopupMenuItem(
                      value: 'D',
                      child: Text(
                        'D - Drop',
                        style: TextStyle(color: Colors.blue),
                      )));
                }
                return items;
              },
            )
          : Text(
              _selectedSet! == '-1' ? 'D' : _selectedSet!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
    );
  }

  Widget _buildRepsButton() {
    return Center(
      child: _selectedReps == null
          ? IconButton(
              onPressed: () => _showInputBottomSheet("Reps", (value) {
                setState(() => _selectedReps = value);
              }),
              tooltip: 'Add Reps',
              icon: const Icon(Icons.more_horiz),
            )
          : Text(_selectedReps!,
              style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildWeightButton() {
    return Center(
      child: _selectedWeight == null
          ? IconButton(
              onPressed: () => _showInputBottomSheet("Weight", (value) {
                setState(() => _selectedWeight = value);
              }),
              tooltip: 'Add Weight',
              icon: const Icon(Icons.more_horiz),
            )
          : Text(_selectedWeight!,
              style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
