import 'package:edu_app_project/core/common/app/providers/tab_navigator.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NestedBackButton extends StatelessWidget {
  const NestedBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) async {
        if (!didPop) {
          try {
            context.read<TabNavigator>().pop();
          } catch (_) {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          }
        }
      },
      child: IconButton(
        onPressed: () {
          // don't add try catch yet till we get to creating the course
          // details view, for tutorial purposes
          try {
            context.read<TabNavigator>().pop();
          } catch (_) {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          }
        },
        icon: Theme.of(context).platform == TargetPlatform.iOS
            ? Icon(Icons.arrow_back_ios_new, color: Colours.darkColour)
            : Icon(Icons.arrow_back, color: Colours.darkColour),
      ),
    );
  }
}
