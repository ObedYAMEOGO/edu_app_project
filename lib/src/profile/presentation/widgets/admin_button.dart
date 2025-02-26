import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:flutter/material.dart';

class AdminButton extends StatelessWidget {
  const AdminButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width, // Full screen width
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: Colours.primaryGradient, // Apply gradient
          borderRadius: BorderRadius.circular(10),
        ),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, // Transparent to show gradient
            shadowColor: Colors.transparent, // Remove shadow for a clean look
            foregroundColor: Colours.whiteColour,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onPressed,
          label: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: Fonts.inter,
            ),
          ),
          icon: Icon(icon),
        ),
      ),
    );
  }
}
