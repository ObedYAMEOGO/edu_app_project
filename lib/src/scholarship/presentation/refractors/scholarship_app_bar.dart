import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:flutter/material.dart';

class ScholarshipViewAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ScholarshipViewAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: const Text(
        'Bourses d\'études',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: Fonts.inter, // Texte légèrement plus clair

          fontSize: 17,
          color: Colours.darkColour,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
