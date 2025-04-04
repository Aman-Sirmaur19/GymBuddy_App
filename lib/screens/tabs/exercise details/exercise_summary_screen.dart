import 'package:flutter/material.dart';

import '../../../models/exercise.dart';

class ExerciseSummaryScreen extends StatelessWidget {
  final Exercise exercise;

  const ExerciseSummaryScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    Set<String> muscles = {};
    muscles.addAll(exercise.primaryMuscles);
    muscles.addAll(exercise.secondaryMuscles);
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        if (exercise.instructions.isNotEmpty) ...[
          const SizedBox(height: 15),
          const Text(
            'Instructions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: exercise.instructions.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Text(
                  exercise.instructions[index],
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              );
            },
          ),
        ],
        if (muscles.isNotEmpty)
          _customColumn(label: 'Muscles', list: muscles, context: context),
        if (exercise.level != '')
          _customColumn(
              label: 'Level', value: exercise.level, context: context),
        if (exercise.force != '')
          _customColumn(
              label: 'Force', value: exercise.force, context: context),
        if (exercise.category != '')
          _customColumn(
              label: 'Category', value: exercise.category, context: context),
        if (exercise.equipment != '')
          _customColumn(
              label: 'Equipment', value: exercise.equipment, context: context),
      ],
    );
  }

  Widget _customColumn({
    required String label,
    Set<String>? list,
    String? value,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        list != null
            ? Wrap(
                spacing: 8.0,
                children: list
                    .map(
                      (String status) => Chip(
                        padding: const EdgeInsets.all(0),
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.tertiary),
                        label: Text(
                          status.capitalize(),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary),
                        ),
                      ),
                    )
                    .toList(),
              )
            : Chip(
                padding: const EdgeInsets.all(0),
                side: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                label: Text(
                  value!.capitalize(),
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary),
                ),
              )
      ],
    );
  }
}

// Helper extension to capitalize filter button labels
extension StringExtension on String {
  String capitalize() {
    return this[0].toUpperCase() + substring(1);
  }
}
