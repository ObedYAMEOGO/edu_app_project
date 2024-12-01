import 'package:edu_app_project/core/res/colours.dart';
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
          fontSize: 15,
          color: Colours.primaryColour,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
