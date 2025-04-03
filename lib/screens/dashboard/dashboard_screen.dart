import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
          'Dashboard',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        physics: const BouncingScrollPhysics(),
        children: [
          _customContainer(
              context: context,
              child: ListTile(
                leading:
                    const Icon(Icons.star_rate_rounded, color: Colors.amber),
                title: RichText(
                  text: TextSpan(
                    text: 'Gym',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    children: const [
                      TextSpan(
                        text: 'Buddy',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                        ),
                        children: [
                          TextSpan(
                            text: ' Pro',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                trailing: const Icon(
                  CupertinoIcons.chevron_forward,
                  color: Colors.grey,
                ),
              )),
          const SizedBox(height: 20),
          _customContainer(
            context: context,
            child: Column(
              children: [
                _customListTile(
                  Icons.fitness_center_rounded,
                  'Workouts',
                ),
                _customListTile(
                  Icons.sports_gymnastics_rounded,
                  'Exercises',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _customContainer(
            context: context,
            child: Column(
              children: [
                _customListTile(
                  Icons.settings_outlined,
                  'Settings',
                ),
                _customListTile(
                  Icons.bar_chart_rounded,
                  'Analytics',
                ),
                _customListTile(
                  Icons.backup_outlined,
                  'Backup',
                ),
                _customListTile(
                  Icons.archive_outlined,
                  'Archive',
                ),
                _customListTile(
                  CupertinoIcons.wand_stars,
                  'Workouts AI',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _customContainer(
              context: context,
              child:
                  _customListTile(Icons.card_giftcard_rounded, 'Win Rewards!')),
          const SizedBox(height: 20),
          _customContainer(
            context: context,
            child: Column(
              children: [
                _customListTile(
                  Icons.send_outlined,
                  'Send feedback',
                ),
                _customListTile(
                  Icons.facebook_rounded,
                  'Follow us on Facebook',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _customContainer(
            context: context,
            child: Column(
              children: [
                _customListTile(
                  Icons.lock_outline_rounded,
                  'Privacy policy',
                ),
                _customListTile(
                  Icons.sticky_note_2_outlined,
                  'Terms of use',
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'MADE WITH ❤️ IN 🇮🇳',
            textAlign: TextAlign.center,
            style: TextStyle(
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _customContainer({
    required BuildContext context,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: child,
    );
  }

  Widget _customListTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(
        CupertinoIcons.chevron_forward,
        color: Colors.grey,
      ),
    );
  }
}
