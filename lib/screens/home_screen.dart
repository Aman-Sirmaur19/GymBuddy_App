import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import 'dashboard/dashboard_screen.dart';
import 'journal_screen.dart';
import 'folder_detail_screen.dart';
import 'tabs/start_session_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;
        final userName = user?.name ?? 'Buddy';
        final folders = user!.weekDays;
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'assets/images/avatar.png',
                    width: 55,
                  ),
                ),
                const SizedBox(width: 5),
                RichText(
                  text: TextSpan(
                    text: 'Good to see you,\n',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    children: [
                      TextSpan(
                        text: '$userName!',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => const JournalScreen())),
                tooltip: 'Journal',
                icon: const Icon(CupertinoIcons.book),
              ),
              IconButton(
                onPressed: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => const DashboardScreen())),
                tooltip: 'Dashboard',
                icon: const Icon(CupertinoIcons.square_grid_2x2),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 45),
            physics: const BouncingScrollPhysics(),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 45),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                          child: SizedBox(
                        width: 75,
                        height: 75,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.secondary,
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                          value: .85,
                          strokeWidth: 7.5,
                          strokeCap: StrokeCap.round,
                        ),
                      )),
                      Center(
                          child: SizedBox(
                        width: 55,
                        height: 55,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.secondary,
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                          value: .65,
                          strokeWidth: 7.5,
                          strokeCap: StrokeCap.round,
                        ),
                      )),
                      Center(
                          child: SizedBox(
                        width: 35,
                        height: 35,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.secondary,
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                          value: .35,
                          strokeWidth: 7.5,
                          strokeCap: StrokeCap.round,
                        ),
                      )),
                    ],
                  ),
                  const SizedBox(width: 70),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _customTextRow(title: 'Triceps', value: 'Tired'),
                        _customTextRow(title: 'Biceps', value: 'Rested'),
                        _customTextRow(title: 'Quads', value: 'Tired'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              const SizedBox(height: 45),
              const Text(
                'You look ready to hit\nthe gym today!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  letterSpacing: 1.5,
                ),
              ),

              /// SUGGESTED FOR TODAY
              const SizedBox(height: 25),
              const Text(
                'Suggested for Today',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              ElevatedButton(
                onPressed: () {},
                // onPressed: () => Navigator.push(context,
                //     CupertinoPageRoute(builder: (context) => const TabScreen())),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.only(
                      left: 20, right: 10, top: 10, bottom: 10),
                  elevation: 0,
                  alignment: Alignment.center,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 30,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              width: 30,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Push Workout',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        Text(
                          '6 Exercises',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Container(
                          height: 30,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.orange.shade200,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.local_fire_department_rounded,
                                color: Colors.deepOrangeAccent,
                              ),
                              Text(
                                '60 min',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.orange.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      // onPressed: () => Navigator.push(
                      //     context,
                      //     CupertinoPageRoute(
                      //         builder: (context) =>
                      //             const StartSessionScreen())),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepPurpleAccent,
                        minimumSize: const Size(75, 120),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text(
                        'Start',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// FOLDERS
              const SizedBox(height: 28),
              const Text(
                'Folders',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: folders.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) =>
                                  FolderDetailScreen(weekday: folders[index]),
                            ),
                          ),
                          child: ListTile(
                            title: Text(
                              folders[index], // Folder name
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            trailing: const Icon(
                              CupertinoIcons.chevron_forward,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        if (index !=
                            folders.length - 1) // Avoid divider for last item
                          const Divider(
                            height: 0,
                            thickness: .1,
                            indent: 16,
                            endIndent: 16,
                          ),
                      ],
                    );
                  },
                ),
              ),

              /// LATEST WORKOUT
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Past Workouts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                      onPressed: () {},
                      child: const Text(
                        'View all',
                        style: TextStyle(color: Colors.deepPurpleAccent),
                      )),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 75,
                      height: 120,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Mar\n16',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 30,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              width: 30,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.lightBlueAccent,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              width: 30,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Push Workout',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '5 Exercises',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '35.24 | 340kg | 2PR',
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black26,
                        minimumSize: const Size(75, 75),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Icon(CupertinoIcons.chevron_forward),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _customTextRow({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(value, textAlign: TextAlign.end),
      ],
    );
  }
}
