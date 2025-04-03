import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/exercise.dart';
import 'exercise_summary_screen.dart';
import 'exercise_history_screen.dart';

class ExerciseDetailsTab extends StatefulWidget {
  final bool isInfo;
  final String workoutId;
  final Exercise exercise;

  const ExerciseDetailsTab({
    super.key,
    this.isInfo = false,
    required this.workoutId,
    required this.exercise,
  });

  @override
  State<ExerciseDetailsTab> createState() => _ExerciseDetailsTabState();
}

class _ExerciseDetailsTabState extends State<ExerciseDetailsTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (!widget.isInfo) {
      _tabController.index = 1;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          'Exercise',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.exercise.name,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (widget.isInfo)
              Expanded(child: ExerciseSummaryScreen(exercise: widget.exercise)),
            if (!widget.isInfo) ...[
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
                    Tab(text: "Summary"),
                    Tab(text: "History"),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ExerciseSummaryScreen(exercise: widget.exercise),
                    ExerciseHistoryScreen(
                      workoutId: widget.workoutId,
                      exercise: widget.exercise,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
