import 'package:edu_app_project/core/res/fonts.dart';
import 'package:flutter/material.dart';

class PopupItem extends StatelessWidget {
  const PopupItem({required this.title, required this.icon, super.key});

  final String title;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: Fonts.merriweather,
            fontWeight: FontWeight.w300,
          ),
        ),
        icon,
      ],
    );
  }
}
