import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final Widget child;
  final double width; // Added width parameter

  const MyButton(
      {super.key, required this.onTap, required this.child, this.width = 200});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width, // Apply the fixed width
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16), // Adjust padding if needed
        child: Center(child: child), // Center the child widget
      ),
    );
  }
}
