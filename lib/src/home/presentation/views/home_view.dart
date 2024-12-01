import 'package:edu_app_project/core/common/widgets/gradient_background.dart';
import 'package:edu_app_project/core/res/media_res.dart';
import 'package:edu_app_project/src/home/presentation/refractors/home_body.dart';
import 'package:edu_app_project/src/home/presentation/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: HomeAppBar(),
      body: GradientBackground(
        image: Res.homeGradientBackground,
        child: HomeBody(),
      ),
    );
  }
}
