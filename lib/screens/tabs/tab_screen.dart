import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/workout.dart';
import '../../providers/weekday_provider.dart';
import '../../providers/workout_provider.dart';
import '../../widgets/custom_elevated_button.dart';
import 'overview_tab.dart';
import 'exercises_tab.dart';
import 'muscles_tab.dart';
import 'sessions_tab.dart';
import 'start_session_screen.dart';

class TabScreen extends StatefulWidget {
  final String weekDay;
  final Map<String, dynamic> workoutData;

  const TabScreen({
    super.key,
    required this.weekDay,
    required this.workoutData,
  });

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.index = 1;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider =
        Provider.of<WorkoutProvider>(context, listen: false);
    final workoutId = widget.workoutData['id'];
    Workout workout = workoutProvider.getWorkoutById(workoutId)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back',
          icon: const Icon(CupertinoIcons.chevron_back),
        ),
        centerTitle: true,
        title: Text(
          'Workout',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              workout.title,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: 30,
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(5),
                ),
                dividerColor: Colors.transparent,
                labelColor: Theme.of(context).colorScheme.secondary,
                indicatorSize: TabBarIndicatorSize.tab,
                labelPadding: const EdgeInsets.all(0),
                indicatorPadding: const EdgeInsets.all(3),
                // Unselected text color
                tabs: const [
                  Tab(text: "Overview"),
                  Tab(text: "Exercises"),
                  Tab(text: "Muscles"),
                  Tab(text: "Sessions"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  OverviewTab(workout: workout),
                  ExercisesTab(
                    weekday: widget.weekDay,
                    workoutData: widget.workoutData,
                  ),
                  const MusclesTab(),
                  const SessionsTab(),
                ],
              ),
            ),
            Consumer<WeekdayProvider>(builder: (context, weekdayProvider, _) {
              return CustomElevatedButton(
                onPressed: widget.workoutData['exercises'].isNotEmpty
                    ? () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => StartSessionScreen(
                                  weekday: widget.weekDay,
                                  workoutData: widget.workoutData,
                                )))
                    : null,
                label: 'Start new session',
                backgroundColor: Colors.green,
              );
            }),
          ],
        ),
      ),
    );
  }
}
