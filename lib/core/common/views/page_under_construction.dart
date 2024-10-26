import 'package:edu_app_project/core/common/widgets/gradient_background.dart';
import 'package:edu_app_project/core/res/media_res.dart';
import 'package:flutter/material.dart';

class PageUnderConstruction extends StatelessWidget {
  const PageUnderConstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        image: MediaRes.backgroundImg,
        child: Center(
            child: Image.asset(
          MediaRes.pageUnderConstruction,
          width: 150,
        )),
      ),
    );
  }
}
