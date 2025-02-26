import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
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
      height: height ?? 50, // Default height
      width: width ?? double.maxFinite, // Default width
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: buttonColour != null
              ? LinearGradient(colors: [buttonColour!, buttonColour!])
              : Colours
                  .primaryGradient, // Use gradient if no solid color is provided
          borderRadius: BorderRadius.circular(10),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, // Make button transparent
            shadowColor: Colors.transparent, // Remove button shadow
            foregroundColor: labelColour ?? Colours.whiteColour,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              fontFamily: Fonts.inter,
              color: labelColour ?? Colours.whiteColour,
            ),
          ),
        ),
      ),
    );
  }
}
