import 'package:edu_app_project/core/common/widgets/gradient_background.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/core/res/media_res.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';

  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 5), () {});
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GradientBackground(
        image: MediaRes.onBoardingBackground,
        child: Center(
            child: Text(
          'skillora',
          style: TextStyle(
              color: Colours.primaryColour,
              fontSize: 22,
              fontFamily: Fonts.montserrat,
              fontWeight: FontWeight.w600),
        )),
      ),
    );
  }
}
