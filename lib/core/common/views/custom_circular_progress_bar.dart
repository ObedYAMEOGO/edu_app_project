import 'package:flutter/material.dart';
import 'package:edu_app_project/core/res/colours.dart';

class CustomCircularProgressBarIndicator extends StatelessWidget {
  const CustomCircularProgressBarIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 20, // Taille augmentée pour plus de visibilité
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 1.5, // Réduire l'épaisseur pour un effet plus fluide
        valueColor: AlwaysStoppedAnimation(Colours.secondaryColour),
      ),
    );
  }
}
