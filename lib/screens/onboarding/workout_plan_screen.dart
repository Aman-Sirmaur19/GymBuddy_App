import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../../widgets/custom_elevated_button.dart';
import '../home_screen.dart';

class WorkoutPlanScreen extends StatefulWidget {
  final String name;
  final double weight;
  final double height;
  final String gender;

  const WorkoutPlanScreen({
    super.key,
    required this.name,
    required this.weight,
    required this.height,
    required this.gender,
  });

  @override
  State<WorkoutPlanScreen> createState() => _WorkoutPlanScreenState();
}

class _WorkoutPlanScreenState extends State<WorkoutPlanScreen> {
  int? selectedDays;
  List<String> selectedWeekDays = [];
  bool isAlternateDays = false;
  final List<String> weekDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  void _setAlternateDays() {
    setState(() {
      selectedWeekDays.clear();
      selectedWeekDays = [
        'Mon',
        'Wed',
        'Fri',
        'Sun',
        'Tue',
        'Thu',
        'Sat',
      ];
      isAlternateDays = true;
    });
  }

  void _setCustomDays() {
    setState(() {
      selectedWeekDays.clear();
      isAlternateDays = false;
    });
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
          'Workout Plan',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const Text('Select Workout Days per Week:',
                      style: TextStyle(fontSize: 15, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(6, (index) {
                      int dayCount = index + 2;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDays = dayCount;
                            selectedWeekDays.clear();
                            isAlternateDays = false;
                          });
                        },
                        child: Container(
                          width: selectedDays == dayCount ? 64 : 60,
                          height: selectedDays == dayCount ? 64 : 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selectedDays == dayCount
                                ? Colors.deepPurpleAccent
                                : Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('$dayCount Days',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: selectedDays == dayCount ? 16 : 14,
                                color: selectedDays == dayCount
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.secondary,
                              )),
                        ),
                      );
                    }),
                  ),
                  if (selectedDays == 4) ...[
                    const SizedBox(height: 20),
                    const Text('Select Workout Mode:',
                        style: TextStyle(fontSize: 15, color: Colors.grey)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _setAlternateDays,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            backgroundColor: isAlternateDays
                                ? Colors.deepPurpleAccent
                                : Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                          ),
                          child: Text('Alternate Days',
                              style: TextStyle(
                                color: isAlternateDays
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.secondary,
                              )),
                        ),
                        ElevatedButton(
                          onPressed: _setCustomDays,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            backgroundColor: !isAlternateDays
                                ? Colors.deepPurpleAccent
                                : Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                          ),
                          child: Text('Custom Days',
                              style: TextStyle(
                                color: !isAlternateDays
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.secondary,
                              )),
                        ),
                      ],
                    ),
                  ],
                  if (isAlternateDays) ...[
                    const SizedBox(height: 8),
                    const Text(
                        'Eg.: Mon, Wed, Fri, Sun, Tue, Thu, Sat',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: Colors.grey)),
                  ],
                  if (selectedDays != null &&
                      (!isAlternateDays || selectedDays != 4)) ...[
                    const SizedBox(height: 20),
                    const Text('Choose Workout Days:',
                        style: TextStyle(fontSize: 15, color: Colors.grey)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: weekDays.map((day) {
                        bool isSelected = selectedWeekDays.contains(day);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedWeekDays.remove(day);
                              } else if (selectedWeekDays.length <
                                  selectedDays!) {
                                selectedWeekDays.add(day);
                              }
                            });
                          },
                          child: Container(
                            width: isSelected ? 64 : 60,
                            height: isSelected ? 64 : 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: isSelected
                                  ? Colors.deepPurpleAccent
                                  : Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                            ),
                            child: Text(day,
                                style: TextStyle(
                                  fontSize: isSelected ? 16 : 14,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : Theme.of(context).colorScheme.secondary,
                                )),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
            CustomElevatedButton(
              onPressed: selectedDays != null &&
                      ((isAlternateDays && selectedWeekDays.length == 7) ||
                          selectedWeekDays.length == selectedDays)
                  ? () async {
                      final provider =
                          Provider.of<UserProvider>(context, listen: false);

                      final existingUser = provider.user;

                      final user = User(
                        id: existingUser?.id ?? const Uuid().v4(),
                        // Keep existing UUID or generate new
                        name: widget.name,
                        weight: widget.weight,
                        height: widget.height,
                        gender: widget.gender,
                        weekDays:
                            selectedWeekDays, // Directly assign selected weekdays
                      );

                      await provider.updateUser(user); // Update user in DB

                      Navigator.pushAndRemoveUntil(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const HomeScreen()),
                        (route) => false,
                      );
                    }
                  : null,
              label: 'Confirm',
            ),
          ],
        ),
      ),
    );
  }
}
