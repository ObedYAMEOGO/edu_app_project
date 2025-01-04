import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.sectionTitle,
    required this.seeAll,
    required this.onSeeAll,
    super.key,
  });

  final String sectionTitle;
  final bool seeAll;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          sectionTitle,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colours.primaryColour),
        ),
        if (seeAll)
          TextButton(
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                splashFactory: NoSplash.splashFactory,
                foregroundColor: Colours.secondaryColour),
            onPressed: onSeeAll,
            child: const Text(
              'Voir plus',
              style: TextStyle(
                fontFamily: Fonts.montserrat,
                color: Colours.greenColour,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }
}
