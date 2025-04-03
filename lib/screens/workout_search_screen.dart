import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/workout.dart';
import '../providers/weekday_provider.dart';
import '../providers/workout_provider.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_text_form_field.dart';
import 'tabs/tab_screen.dart';

class WorkoutSearchScreen extends StatefulWidget {
  final String weekday;

  const WorkoutSearchScreen({super.key, required this.weekday});

  @override
  State<WorkoutSearchScreen> createState() => _WorkoutSearchScreenState();
}

class _WorkoutSearchScreenState extends State<WorkoutSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Set<String> selectedWorkouts = {};
  List<Workout> _filteredWorkouts = [];
  List<Workout> _allWorkouts = [];

  @override
  void initState() {
    super.initState();
    _loadSelectedWorkouts();
  }

  void _loadSelectedWorkouts() async {
    final weekdayProvider =
        Provider.of<WeekdayProvider>(context, listen: false);
    final weekdayData = await weekdayProvider.getWeekdayData(widget.weekday);

    if (weekdayData != null && weekdayData.containsKey('workouts')) {
      setState(() {
        selectedWorkouts = {
          for (var workout in (weekdayData['workouts'] as List))
            workout['id'] as String
        };
      });
    }
  }

  void _filterWorkouts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredWorkouts = List.from(_allWorkouts);
      } else {
        _filteredWorkouts = _allWorkouts
            .where((workout) =>
                workout.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _showAddWorkoutSheet(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final workoutProvider =
        Provider.of<WorkoutProvider>(context, listen: false);
    final weekdayProvider =
        Provider.of<WeekdayProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      // Allows the sheet to go full screen if needed
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom +
                16, // Avoids keyboard overlap
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Add Custom Workout",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: titleController,
                hintText: "Workout Title",
                icon: Icons.fitness_center_rounded,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: descriptionController,
                hintText: "Description",
                icon: Icons.description_rounded,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                onPressed: () async {
                  if (titleController.text.isNotEmpty) {
                    // Create and add workout
                    Workout newWorkout = Workout(
                      id: const Uuid().v4(),
                      title: titleController.text,
                      description: descriptionController.text,
                      metadata: {},
                    );
                    await workoutProvider.addWorkout(newWorkout);
                    await weekdayProvider.addWorkoutToWeekday(
                        widget.weekday, newWorkout.id);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
                label: "Save Workout",
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditBottomSheet(BuildContext context, Workout workout) {
    TextEditingController titleController =
        TextEditingController(text: workout.title);
    TextEditingController descriptionController =
        TextEditingController(text: workout.description);
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom +
                16, // Avoids keyboard overlap
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Edit Workout",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: titleController,
                hintText: "Workout Title",
                icon: Icons.fitness_center_rounded,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: descriptionController,
                hintText: "Description",
                icon: Icons.description_rounded,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty) {
                    setState(() {
                      final workoutProvider =
                          Provider.of<WorkoutProvider>(context, listen: false);
                      Workout updatedWorkout = Workout(
                        id: workout.id,
                        title: titleController.text.trim(),
                        description: descriptionController.text.trim(),
                        metadata: workout.metadata,
                      );
                      workoutProvider.updateWorkout(updatedWorkout);
                    });
                    Navigator.pop(context);
                  }
                },
                label: "Save Workout",
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, String workoutId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Workout Permanently"),
        content: const Text(
            "Are you sure you want to delete this workout permanently?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary)),
          ),
          TextButton(
            onPressed: () {
              final workoutProvider =
                  Provider.of<WorkoutProvider>(context, listen: false);
              final weekdayProvider =
                  Provider.of<WeekdayProvider>(context, listen: false);
              workoutProvider.deleteWorkout(workoutId);
              weekdayProvider.removeWorkoutFromWeekday(
                  widget.weekday, workoutId);
              Navigator.pop(ctx);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final weekdayProvider =
        Provider.of<WeekdayProvider>(context, listen: false);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Back',
            icon: const Icon(CupertinoIcons.chevron_back),
          ),
          centerTitle: true,
          title: Text(
            'Search',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            children: [
              CustomTextFormField(
                controller: _searchController,
                hintText: 'Search',
                icon: Icons.search_rounded,
                keyboardType: TextInputType.text,
                onChanged: (query) => _filterWorkouts(query),
              ),
              const SizedBox(height: 10),
              Consumer<WorkoutProvider>(
                builder: (context, snapshot, child) {
                  _allWorkouts = snapshot.workouts;
                  if (_searchController.text.isEmpty) {
                    _filteredWorkouts = List.from(_allWorkouts);
                  }
                  return Expanded(
                    child: _filteredWorkouts.isEmpty
                        ? const Center(child: Text("No workouts found"))
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: _filteredWorkouts.length,
                            itemBuilder: (context, index) {
                              final workout = _filteredWorkouts[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  // onTap: () => Navigator.push(
                                  //   context,
                                  //   CupertinoPageRoute(
                                  //     builder: (context) => TabScreen(
                                  //       weekDay: widget.weekday,
                                  //       workoutData: {
                                  //         'id': workout.id,
                                  //         'title': workout.title,
                                  //         'description': workout.description,
                                  //         'exercises': const [],
                                  //       },
                                  //     ),
                                  //   ),
                                  // ),
                                  contentPadding:
                                      const EdgeInsets.only(left: 8),
                                  tileColor:
                                      Theme.of(context).colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  title: Text(
                                    workout.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () => _showEditBottomSheet(
                                            context, workout),
                                        tooltip: 'Edit',
                                        color: Colors.blue,
                                        icon: const Icon(Icons.edit_rounded),
                                      ),
                                      IconButton(
                                        onPressed: () => _showDeleteDialog(
                                            context, workout.id),
                                        tooltip: 'Delete',
                                        color: Colors.red,
                                        icon: const Icon(
                                            Icons.delete_outline_rounded),
                                      ),
                                      Checkbox(
                                        checkColor: Colors.white,
                                        activeColor: Colors.green,
                                        value: selectedWorkouts
                                            .contains(workout.id),
                                        onChanged: (bool? isChecked) async {
                                          if (isChecked == true) {
                                            await weekdayProvider
                                                .addWorkoutToWeekday(
                                                    widget.weekday, workout.id);
                                            setState(() {
                                              selectedWorkouts.add(workout.id);
                                            });
                                          } else {
                                            await weekdayProvider
                                                .removeWorkoutFromWeekday(
                                                    widget.weekday, workout.id);
                                            setState(() {
                                              selectedWorkouts
                                                  .remove(workout.id);
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  );
                },
              ),
              CustomElevatedButton(
                onPressed: () => _showAddWorkoutSheet(context),
                label: 'Add Custom',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
