import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.keyboardType,
    this.onChanged,
    this.onFieldSubmitted,
    this.isFilter = false,
  });

  final TextEditingController? controller;
  final String hintText;
  final IconData icon;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final bool isFilter;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      maxLines:
          hintText == 'Add note...' || hintText == 'Edit note...' ? null : 1,
      onFieldSubmitted: onFieldSubmitted,
      cursorColor: Colors.deepPurpleAccent,
      style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 24),
        // Ensures consistent size
        prefixIconConstraints:
            const BoxConstraints(minWidth: 40, minHeight: 40),
        // Aligns the prefix icon properly
        suffixIcon: isFilter
            ? IconButton(
                onPressed: () {},
                tooltip: 'Add filters',
                padding: EdgeInsets.zero,
                alignment: Alignment.center,
                icon: const Icon(CupertinoIcons.slider_horizontal_3, size: 22),
              )
            : null,
        suffixIconConstraints:
            const BoxConstraints(minWidth: 40, minHeight: 40),
        // Aligns the suffix icon properly
        hintText: hintText,
        hintStyle: const TextStyle(fontWeight: FontWeight.w500),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary.withOpacity(.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.deepPurpleAccent),
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
