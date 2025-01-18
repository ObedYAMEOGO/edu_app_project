import 'package:edu_app_project/core/extensions/context_extension.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:flutter/material.dart';

class TinderCard extends StatelessWidget {
  const TinderCard({required this.isFirst, super.key, this.colour});

  final bool isFirst;
  final Color? colour;

  @override
  Widget build(BuildContext context) {
    final double cardHeight = context.height * 0.15;
    final double cardPadding = context.width * 0.05;
    final double fontSize = context.width * 0.05;

    return Stack(
      children: [
        Container(
          alignment: Alignment.bottomCenter,
          height: cardHeight,
          padding: EdgeInsets.only(
            left: cardPadding,
            right: cardPadding,
          ),
          decoration: BoxDecoration(
            gradient: isFirst
                ? LinearGradient(
                    colors: [
                      Colours.primaryColour,
                      Colours.secondaryColour,
                    ],
                  )
                : null,
            color: colour,
            borderRadius: BorderRadius.circular(3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                offset: const Offset(0, 5),
                blurRadius: 10,
              ),
            ],
          ),
          child: isFirst
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                  child: Column(
                    children: [
                      Spacer(),

                      Align(
                        alignment: Alignment.centerLeft, // Align to left
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: cardPadding / 2,
                            vertical: cardPadding / 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colours.whiteColour,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: const Text(
                            'Cours du jour',
                            style: TextStyle(
                              color: Colours.darkColour,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      // Title
                      Align(
                        alignment: Alignment.centerLeft, // Align to left
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            _splitTitle(
                                context.courseOfTheDay?.title ?? '______'),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colours.whiteColour,
                              fontFamily: Fonts.merriweather,
                              fontSize: fontSize * 1.3,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                )
              : null,
        ),
      ],
    );
  }

  String _splitTitle(String title) {
    final parts = title.split(' ');
    if (parts.length > 1) {
      return '${parts[0]}\n${parts.sublist(1).join(' ')}';
    }
    return title;
  }
}
