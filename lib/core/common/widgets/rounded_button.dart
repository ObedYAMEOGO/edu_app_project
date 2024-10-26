
import 'package:edu_app_project/core/res/colours.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.label,
    required this.onPressed,
    this.buttonColour,
    this.labelColour,
    this.height,
    this.width,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final Color? buttonColour;
  final Color? labelColour;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColour ?? Colours.primaryColour,
          foregroundColor: labelColour ?? Colors.white,
          minimumSize: const Size(double.maxFinite, 50),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
