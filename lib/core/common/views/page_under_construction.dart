import 'package:edu_app_project/core/common/widgets/gradient_background.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/core/res/media_res.dart';
import 'package:flutter/material.dart';

class PageUnderConstruction extends StatelessWidget {
  const PageUnderConstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        image: Res.backgroundImg,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(Res.pageUnderConstruction, width: 250),
              const SizedBox(height: 10),
              const Text(
                'Nous rencontrons des soucis techniques.\n'
                'Nous travaillons pour rétablir l\'accès.\n'
                'Merci pour votre patience.',
                style: TextStyle(fontFamily: Fonts.inter),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
