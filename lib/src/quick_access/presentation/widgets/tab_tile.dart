import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/src/quick_access/presentation/providers/quick_access_tab_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabTile extends StatelessWidget {
  const TabTile({required this.index, required this.title, super.key});

  final int index;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Consumer<QuickAccessTabController>(
      builder: (_, controller, __) {
        final isSelected = controller.currentIndex == index;
        return GestureDetector(
          onTap: () => controller.changeIndex(index),
          child: isSelected
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFE4E6EA),
                  ),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colours.darkColour, fontFamily: Fonts.inter),
                  ),
                )
              : Text(
                  title,
                  style: const TextStyle(
                      color: Colors.grey, fontFamily: Fonts.inter),
                ),
        );
      },
    );
  }
}
