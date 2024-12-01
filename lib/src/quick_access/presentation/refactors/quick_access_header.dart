import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/src/quick_access/presentation/providers/quick_access_tab_controller.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class QuickAccessHeader extends StatelessWidget {
  const QuickAccessHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuickAccessTabController>(
      builder: (_, controller, __) {
        return Center(
          child: Icon(
            controller.currentIndex == 0
                ? IconlyLight.paper_download
                : controller.currentIndex == 1
                    ? IconlyLight.time_square
                    : IconlyLight.activity,
            size: 200,
            color: Colours.secondaryColour,
          ),
        );
      },
    );
  }
}
