import 'package:flutter/material.dart';

class MusclesTab extends StatelessWidget {
  const MusclesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 25),
      physics: const BouncingScrollPhysics(),
      children: [
        const Text(
          'Most Involved',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        _customStack('Cardio', Colors.red, 1),
        const SizedBox(height: 10),
        _customStack('Biceps', Colors.amber, .75),
        const SizedBox(height: 10),
        _customStack('Other', Colors.blue, .45),
        const SizedBox(height: 30),
        const Text(
          'Other Includes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: Column(
            children: [
              _customRow('Back', 'Rested', context),
              Divider(
                thickness: .2,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              _customRow('Neck', 'Tired', context),
              Divider(
                thickness: .2,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              _customRow('Deltoid', 'Tired', context),
              Divider(
                thickness: .2,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              _customRow('Abs', 'Rested', context),
            ],
          ),
        )
      ],
    );
  }

  Widget _customStack(String label, Color color, double value) {
    return Stack(
      alignment: Alignment.center,
      children: [
        LinearProgressIndicator(
          value: value,
          minHeight: 50,
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _customRow(String title, String value, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            color: value == 'Tired'
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ],
    );
  }
}
