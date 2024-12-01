import 'package:edu_app_project/core/extensions/context_extension.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:flutter/material.dart';

class TinderCard extends StatelessWidget {
  const TinderCard({required this.isFirst, super.key, this.colour});

  final bool isFirst;
  final Color? colour;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Le contenu principal de la carte
        Container(
          alignment: Alignment.bottomCenter,
          height: 137,
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          decoration: BoxDecoration(
            gradient: isFirst
                ? const LinearGradient(
                    colors: [
                      Colours.primaryColour,
                      Colours.primaryColour,
                    ],
                  )
                : null,
            color: colour,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.15),
                offset: const Offset(0, 5),
                blurRadius: 10,
              ),
            ],
          ),
          child: isFirst
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '\n${context.courseOfTheDay?.title != null && context.courseOfTheDay!.title.length > 17 ? '${context.courseOfTheDay!.title.substring(0, 17)}...' : context.courseOfTheDay?.title ?? '______'} ',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Icon(Icons.timer, color: Colours.favoriteYellow),
                        SizedBox(width: 8),
                        Text(
                          '10 minutes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : null,
        ),
        // Le label "Cours du jour"
        if (isFirst)
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colours.greenColour,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Cours du jour',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
