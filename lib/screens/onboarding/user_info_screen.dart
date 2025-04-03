import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'workout_plan_screen.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  String? selectedGender;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'User Info',
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
                    const Text(
                      'What\'s your name?',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      controller: nameController,
                      hintText: 'Name',
                      icon: Icons.person_outline_rounded,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'What\'s your weight (in Kg)?',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      controller: weightController,
                      hintText: 'Weight (kg)',
                      icon: Icons.scale_rounded,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'What\'s your height (in cm)?',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      controller: heightController,
                      hintText: 'Height (cm)',
                      icon: Icons.height_rounded,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    const Text('Select Gender:',
                        style: TextStyle(fontSize: 15, color: Colors.grey)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ['Male', 'Female', 'Other'].map((gender) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedGender = gender;
                            });
                          },
                          child: Container(
                            width: selectedGender == gender ? 80 : 75,
                            height: selectedGender == gender ? 80 : 75,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color:
                                  gender == 'Male' && selectedGender == gender
                                      ? Colors.blue
                                      : gender == 'Female' &&
                                              selectedGender == gender
                                          ? Colors.pinkAccent
                                          : gender == 'Other' &&
                                                  selectedGender == gender
                                              ? Colors.deepPurpleAccent
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .secondaryContainer,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  gender == 'Male'
                                      ? Icons.male_rounded
                                      : gender == 'Female'
                                          ? Icons.female_rounded
                                          : Icons.transgender_rounded,
                                  size: selectedGender == gender ? 30 : 25,
                                  color: selectedGender == gender
                                      ? Colors.white
                                      : Theme.of(context).colorScheme.secondary,
                                ),
                                Text(gender,
                                    style: TextStyle(
                                      fontSize:
                                          selectedGender == gender ? 16 : 14,
                                      fontWeight: FontWeight.bold,
                                      color: selectedGender == gender
                                          ? Colors.white
                                          : Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                    )),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              CustomElevatedButton(
                onPressed: () {
                  if (nameController.text.trim().isEmpty ||
                      weightController.text.trim().isEmpty ||
                      heightController.text.trim().isEmpty ||
                      selectedGender == null) return;
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => WorkoutPlanScreen(
                                name: nameController.text.trim(),
                                weight:
                                    double.parse(weightController.text.trim()),
                                height:
                                    double.parse(heightController.text.trim()),
                                gender: selectedGender!,
                              )));
                },
                label: 'Next',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
