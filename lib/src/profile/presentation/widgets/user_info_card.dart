import 'package:edu_app_project/core/res/fonts.dart';
import 'package:flutter/material.dart';

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({
    required this.infoTitle,
    required this.infoIcon,
    required this.infoValue,
    required this.infoThemeColour,
    super.key,
  });

  final String infoTitle;
  final String infoValue;
  final Widget infoIcon;
  final Color infoThemeColour;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(7),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFE4E6EA),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right:8.0),
                child: infoIcon,
              ),
              Text(
                infoTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontFamily: Fonts.montserrat,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Text(
            infoValue,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: Fonts.montserrat,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
