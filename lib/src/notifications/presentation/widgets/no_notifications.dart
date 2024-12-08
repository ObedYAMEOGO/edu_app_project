import 'package:edu_app_project/core/res/colours.dart';
import 'package:flutter/material.dart';

class NoNotifications extends StatelessWidget {
  const NoNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(Icons.notifications_off_outlined,
          size: 200, color: Colours.secondaryColour),
    );
  }
}
