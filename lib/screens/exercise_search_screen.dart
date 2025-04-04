import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/workout.dart';
import '../providers/exercise_provider.dart';
import '../providers/weekday_provider.dart';
import '../providers/workout_provider.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/custom_elevated_button.dart';
import 'tabs/exercise details/exercise_details_tab.dart';

class ExerciseSearchScreen extends StatefulWidget {
  final String weekDay;
  final Map<String, dynamic> workoutData;

  const ExerciseSearchScreen({
    super.key,
    required this.weekDay,
    required this.workoutData,
  });

  @override
  State<ExerciseSearchScreen> createState() => _ExerciseSearchScreenState();
}

class _ExerciseSearchScreenState extends State<ExerciseSearchScreen> {
  final TextEditingController _controller = TextEditingController();

  // Store applied filters
  final Map<String, String?> _selectedFilters = {
    'level': null,
    'category': null,
    'primaryMuscles': null,
    'secondaryMuscles': null,
    'equipment': null,
    'force': null,
    'mechanic': null,
  };

  void _showFilterOptions(
      BuildContext context, String filterKey, ExerciseProvider provider) {
    Set<String> options = {};

    for (var exercise in provider.exercises) {
      if (filterKey == 'primaryMuscles') {
        options.addAll(exercise.primaryMuscles);
      } else if (filterKey == 'secondaryMuscles') {
        options.addAll(exercise.secondaryMuscles);
      } else {
        final value = exercise.toJson()[filterKey];
        if (value != null) {
          options.add(value);
        }
      }
    }

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        // Filter out "Unknown"
        final filteredOptions =
            options.where((option) => option != 'Unknown').toList();

        double sheetHeight = (filteredOptions.length * 56.0)
            .clamp(100, MediaQuery.of(context).size.height * 0.6);

        return SizedBox(
          height: sheetHeight,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            itemCount: filteredOptions.length,
            itemBuilder: (context, index) {
              final option = filteredOptions[index];
              return ListTile(
                title: Text(option.capitalize()),
                trailing: _selectedFilters[filterKey] == option
                    ? const Icon(
                        Icons.circle,
                        size: 10,
                        color: Colors.deepPurpleAccent,
                      )
                    : null,
                onTap: () {
                  setState(() {
                    if (_selectedFilters[filterKey] != option) {
                      _selectedFilters[filterKey] = option;
                    } else {
                      _selectedFilters[filterKey] = null;
                    }
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final exerciseProvider = Provider.of<ExerciseProvider>(context);

    // Filter exercises based on search query and selected filters
    final filteredExercises = exerciseProvider.exercises.where((exercise) {
      if (_controller.text.isNotEmpty &&
          !exercise.name
              .toLowerCase()
              .contains(_controller.text.toLowerCase())) {
        return false;
      }

      return _selectedFilters.entries.every((filter) {
        final key = filter.key;
        final value = filter.value;

        if (value == null) return true; // Skip filter if not selected

        if (key == 'muscles') {
          return exercise.primaryMuscles.contains(value) ||
              exercise.secondaryMuscles.contains(value);
        } else {
          return exercise.toJson()[key]?.contains(value) == true;
        }
      });
    }).toList();

    // Sort to show selected exercises at the top
    // filteredExercises.sort((a, b) {
    //   bool aSelected = _selectedExercises.contains(a.name);
    //   bool bSelected = _selectedExercises.contains(b.name);
    //   return aSelected == bSelected ? 0 : (aSelected ? -1 : 1);
    // });

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
          child:
              Consumer<WeekdayProvider>(builder: (context, weekdayProvider, _) {
            return Column(
              children: [
                CustomTextFormField(
                  controller: _controller,
                  hintText: 'Search',
                  icon: Icons.search_rounded,
                  keyboardType: TextInputType.text,
                  onChanged: (value) => setState(() {}),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _selectedFilters.keys.map((filter) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ElevatedButton.icon(
                          onPressed: () => _showFilterOptions(
                              context, filter, exerciseProvider),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            foregroundColor: _selectedFilters[filter] != null
                                ? Colors.white
                                : Theme.of(context).colorScheme.secondary,
                            backgroundColor: _selectedFilters[filter] != null
                                ? Colors.deepPurpleAccent
                                : Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          icon:
                              const Icon(CupertinoIcons.chevron_down, size: 15),
                          label: Text(_selectedFilters[filter] != null
                              ? _selectedFilters[filter]!.capitalize()
                              : filter.capitalize()),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${widget.workoutData['exercises'].length} selected out of ${filteredExercises.length} exercises',
                  style: TextStyle(
                    letterSpacing: .5,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: Consumer<WeekdayProvider>(
                    builder: (context, weekdayProvider, _) {
                      final workoutProvider =
                          Provider.of<WorkoutProvider>(context, listen: false);
                      Workout workout = workoutProvider
                          .getWorkoutById(widget.workoutData['id'])!;
                      List<String> exerciseIds =
                          widget.workoutData['exercises'];
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: filteredExercises.length,
                        itemBuilder: (context, index) {
                          final exercise = filteredExercises[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              onTap: () => Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => ExerciseDetailsTab(
                                    isInfo: true,
                                    workoutId: widget.workoutData['id'],
                                    exercise: exercise,
                                  ),
                                ),
                              ),
                              contentPadding: const EdgeInsets.only(left: 8),
                              tileColor: Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              title: Text(exercise.name),
                              subtitle: Text(exercise.category),
                              trailing: Checkbox(
                                value: exerciseIds.contains(exercise.id),
                                checkColor: Colors.white,
                                activeColor: Colors.green,
                                onChanged: (bool? value) async {
                                  if (value == true) {
                                    await weekdayProvider.addExerciseToWorkout(
                                      widget.weekDay,
                                      workout.id,
                                      exercise.id,
                                    );
                                    setState(() {
                                      // widget.workout.exerciseIds.add(
                                      //     exercise.id); // Update UI immediately
                                    });
                                  } else {
                                    await weekdayProvider
                                        .removeExerciseFromWorkout(
                                      widget.weekDay,
                                      workout.id,
                                      exercise.id,
                                    );
                                    setState(() {
                                      // widget.workout.exerciseIds.remove(
                                      //     exercise.id); // Update UI immediately
                                    });
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                CustomElevatedButton(
                  onPressed: () {},
                  label: 'Add custom',
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

// Helper extension to capitalize filter button labels
extension StringExtension on String {
  String capitalize() {
    return this[0].toUpperCase() + substring(1);
  }
}
