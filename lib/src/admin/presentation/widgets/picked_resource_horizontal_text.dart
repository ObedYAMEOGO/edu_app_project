import 'package:edu_app_project/core/res/fonts.dart';
import 'package:flutter/material.dart';

class PickedResourceHorizontalText extends StatelessWidget {
  const PickedResourceHorizontalText({
    required this.label,
    required this.value,
    super.key,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      child: RichText(
        text: TextSpan(
          text: '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontFamily: Fonts.inter,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(
                  fontFamily: Fonts.inter, fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }
}
