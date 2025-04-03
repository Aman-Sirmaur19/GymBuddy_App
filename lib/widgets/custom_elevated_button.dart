import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final void Function()? onPressed;
  final String label;
  final Color backgroundColor;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.backgroundColor = Colors.deepPurpleAccent,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minimumSize: const Size(double.infinity, 45),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 15),
      ),
    );
  }
}
