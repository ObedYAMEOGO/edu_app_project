import 'package:edu_app_project/core/res/media_res.dart';
import 'package:edu_app_project/src/quick_access/presentation/providers/quick_access_tab_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuickAccessHeader extends StatelessWidget {
  const QuickAccessHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuickAccessTabController>(
      builder: (_, controller, __) {
        return Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Image.asset(
              controller.currentIndex == 0
                  ? Res.documents
                  : controller.currentIndex == 1
                      ? Res.quiz
                      : Res.historic,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
