import 'package:flutter/material.dart';

import '../../models/workout.dart';
import '../../widgets/circular_progress_painter.dart';

class OverviewTab extends StatelessWidget {
  final Workout workout;

  const OverviewTab({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      physics: const BouncingScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            children: [
              Center(
                child: SizedBox(
                  width: 90,
                  height: 90,
                  child: CustomPaint(
                    painter: CircularProgressPainter(context),
                  ),
                ),
              ),
              const SizedBox(width: 75),
              const Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.circle_rounded,
                          size: 15,
                          color: Colors.red,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Cardio',
                          style: TextStyle(fontSize: 16),
                        ),
                        Spacer(),
                        Text(
                          '45%',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.circle_rounded,
                          size: 15,
                          color: Colors.amber,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Stretch',
                          style: TextStyle(fontSize: 16),
                        ),
                        Spacer(),
                        Text(
                          '35%',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.circle_rounded,
                          size: 15,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Strength',
                          style: TextStyle(fontSize: 16),
                        ),
                        Spacer(),
                        Text(
                          '20%',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
                onPressed: () {},
                child: const Text(
                  'This week',
                  style: TextStyle(color: Colors.deepPurpleAccent),
                )),
          ],
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _customIconColumn(
                  Icons.local_fire_department_rounded,
                  Colors.deepOrange,
                  '12.6 kcal',
                  'Burned',
                ),
                _customIconColumn(
                  Icons.fitness_center_rounded,
                  Colors.lightBlue,
                  '670 kg',
                  'Lifted',
                ),
                _customIconColumn(
                  Icons.access_time_filled_rounded,
                  Colors.green,
                  '2 times',
                  'Trained',
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _customIconColumn(
                  Icons.access_time_filled_rounded,
                  Colors.deepPurple,
                  '45 min',
                  'Required',
                ),
                _customIconColumn(
                  Icons.sentiment_satisfied_rounded,
                  Colors.orange,
                  '8 RPE',
                  'Rated',
                ),
              ],
            ),
          ],
        ),
        if (workout.description.isNotEmpty) ...[
          const SizedBox(height: 30),
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            workout.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }

  Widget _customIconColumn(
      IconData icon, Color color, String data, String label) {
    return Column(
      children: [
        Icon(icon, size: 30, color: color),
        Text(data),
        Text(label),
      ],
    );
  }
}
