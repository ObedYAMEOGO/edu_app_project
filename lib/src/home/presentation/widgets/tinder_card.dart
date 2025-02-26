import 'dart:ui';
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
        if (isFirst)
          _buildBlurEffect(), // Ajout de l'effet blur seulement si c'est la première carte
        _buildCard(context, cardHeight, cardPadding, fontSize),
      ],
    );
  }

  /// Effet blur appliqué uniquement à la première carte
  Widget _buildBlurEffect() {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter:
              ImageFilter.blur(sigmaX: 18, sigmaY: 18), // Blur plus perceptible
          child: Container(
            color: Colors.white
                .withOpacity(0.15), // Léger voile blanc pour renforcer l'effet
          ),
        ),
      ),
    );
  }

  /// Construction de la carte avec gradient et bordures
  Widget _buildCard(
      BuildContext context, double height, double padding, double fontSize) {
    return Container(
      alignment: Alignment.bottomCenter,
      height: height,
      padding: EdgeInsets.symmetric(horizontal: padding),
      decoration: BoxDecoration(
        gradient: isFirst
            ? const LinearGradient(
                colors: [
                  Color.fromARGB(255, 2, 82, 201),
                  Color(0xff00c6ff),
                ],
                stops: [0, 1],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: colour ?? Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), // Ombre légère
            offset: const Offset(0, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: isFirst
          ? Column(
              children: [
                const Spacer(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: padding / 2,
                      vertical: padding / 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colours.whiteColour,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Cours du jour',
                      style: TextStyle(
                        color: Colours.darkColour,
                        fontWeight: FontWeight.w500,
                        fontFamily: Fonts.inter,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      _splitTitle(context.courseOfTheDay?.title ?? '______'),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colours.whiteColour,
                        fontFamily: Fonts.inter,
                        fontSize: fontSize * 1.3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            )
          : null,
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
