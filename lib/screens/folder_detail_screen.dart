import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/workout.dart';
import '../providers/weekday_provider.dart';
import '../providers/workout_provider.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_text_form_field.dart';
import 'workout_search_screen.dart';
import 'tabs/tab_screen.dart';

class FolderDetailScreen extends StatefulWidget {
  final String weekday;

  const FolderDetailScreen({super.key, required this.weekday});

  @override
  State<FolderDetailScreen> createState() => _FolderDetailScreenState();
}

class _FolderDetailScreenState extends State<FolderDetailScreen> {
  bool _isGridView = false;
  final _weekDays = {
    'Mon': 'Monday',
    'Tue': 'Tuesday',
    'Wed': 'Wednesday',
    'Thu': 'Thursday',
    'Fri': 'Friday',
    'Sat': 'Saturday',
    'Sun': 'Sunday',
  };

  void _showEditBottomSheet(BuildContext context, Workout workout) {
    TextEditingController titleController =
        TextEditingController(text: workout.title);
    TextEditingController descriptionController =
        TextEditingController(text: workout.description);
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

  void _showRemoveDialog(BuildContext context, String workoutId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Remove Workout from Folder"),
        content: const Text(
            "Are you sure you want to remove this workout from folder?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary)),
          ),
          TextButton(
            onPressed: () {
              final weekdayProvider =
                  Provider.of<WeekdayProvider>(context, listen: false);
              weekdayProvider.removeWorkoutFromWeekday(
                  widget.weekday, workoutId);
              Navigator.pop(ctx);
            },
            child: const Text("Remove", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back',
          icon: const Icon(CupertinoIcons.chevron_back),
        ),
        centerTitle: true,
        title: Text(
          'Folder',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _weekDays[widget.weekday]!,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() {
                    _isGridView = !_isGridView;
                  }),
                  tooltip: _isGridView ? 'List view' : 'Grid view',
                  icon: Icon(_isGridView
                      ? Icons.view_stream_rounded
                      : Icons.grid_view_rounded),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Workouts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                WorkoutSearchScreen(weekday: widget.weekday))),
                    child: const Text(
                      'Add / Remove',
                      style: TextStyle(color: Colors.deepPurpleAccent),
                    )),
              ],
            ),
            Expanded(
              child: Consumer<WeekdayProvider>(
                builder: (context, weekdayProvider, child) {
                  return FutureBuilder<Map<String, dynamic>?>(
                    future: weekdayProvider.getWeekdayData(widget.weekday),
                    builder: (context, dataSnapshot) {
                      if (dataSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (dataSnapshot.hasError) {
                        return Center(
                            child: Text('Error: ${dataSnapshot.error}'));
                      } else if (!dataSnapshot.hasData ||
                          dataSnapshot.data == null) {
                        return const Center(
                            child: Text('No workouts added yet.'));
                      }

                      Map<String, dynamic> allData = dataSnapshot.data!;
                      if (allData['workouts'].isEmpty) {
                        return const Center(
                            child: Text('No workouts added yet.'));
                      }

                      List<Map<String, dynamic>> workouts =
                          List<Map<String, dynamic>>.from(allData['workouts']);

                      return _isGridView
                          ? GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                mainAxisExtent: 120,
                              ),
                              itemCount: workouts.length,
                              itemBuilder: (context, index) {
                                return _buildWorkoutCard(workouts[index]);
                              },
                            )
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: workouts.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: _buildWorkoutCard(workouts[index]),
                                );
                              },
                            );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutCard(Map<String, dynamic> workoutData) {
    final workoutProvider =
        Provider.of<WorkoutProvider>(context, listen: false);
    final workoutId = workoutData['id'];
    Workout workout = workoutProvider.getWorkoutById(workoutId)!;
    return ElevatedButton(
      onPressed: () => Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => TabScreen(
                    weekDay: widget.weekday,
                    workoutData: workoutData,
                  ))),
      style: ElevatedButton.styleFrom(
        padding:
            EdgeInsets.only(left: 20, right: 10, bottom: _isGridView ? 0 : 10),
        elevation: 0,
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: _isGridView ? 20 : 30,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(width: 5),
              Container(
                width: _isGridView ? 20 : 30,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(width: 5),
              Container(
                width: _isGridView ? 20 : 30,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const Spacer(),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == "edit") {
                    _showEditBottomSheet(context, workout);
                  } else if (value == "remove") {
                    _showRemoveDialog(context, workout.id);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: "edit",
                    child: Row(
                      children: [
                        Icon(Icons.edit_rounded, color: Colors.blue),
                        SizedBox(width: 8),
                        Text("Edit"),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: "remove",
                    child: Row(
                      children: [
                        Icon(Icons.clear_rounded, color: Colors.red),
                        SizedBox(width: 8),
                        Text("Remove"),
                      ],
                    ),
                  ),
                ],
                icon: Icon(
                  Icons.more_horiz_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
          Text(
            workout.title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          Text(
            '${workoutData['exercises'].length} ${workoutData['exercises'].length < 2 ? 'Exercise' : 'Exercises'}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class Dummy extends StatelessWidget {
  const Dummy({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          // onTap: () => Navigator.push(
          //     context,
          //     CupertinoPageRoute(
          //         builder: (context) => const TabScreen())),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding:
                const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: 30,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: 30,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {},
                        padding: const EdgeInsets.all(0),
                        tooltip: 'More',
                        icon: const Icon(Icons.more_horiz_rounded)),
                  ],
                ),
                const Text(
                  'Cardio Easy',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '7 Exercises',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '7 days',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(
                              Icons.arrow_downward_rounded,
                              size: 17,
                              color: Colors.redAccent,
                            ),
                            Text(
                              ' 5%',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '30 days',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(
                              Icons.arrow_upward_rounded,
                              size: 17,
                              color: Colors.lightGreen,
                            ),
                            Text(
                              ' 5%',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Completed',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        Text(
                          '25x',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Missed',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        Text(
                          '5x',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        InkWell(
          // onTap: () => Navigator.push(
          //     context,
          //     CupertinoPageRoute(
          //         builder: (context) => const TabScreen())),
          child: Container(
            padding:
                const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: 20,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: 20,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {},
                        padding: const EdgeInsets.all(0),
                        tooltip: 'More',
                        icon: const Icon(Icons.more_horiz_rounded)),
                  ],
                ),
                const Text(
                  'Cardio Easy',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Aerobics | Jump Rope | Climbing',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
