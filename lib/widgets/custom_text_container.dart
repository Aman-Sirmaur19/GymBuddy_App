import 'package:flutter/material.dart';

class CustomTextContainer extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;

  const CustomTextContainer({
    super.key,
    required this.width,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(15),
      ),
      child: child,
    );
  }
}
