import 'package:edu_app_project/core/common/widgets/gradient_background.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/core/res/media_res.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';

  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.forward();

    _navigateToNextScreen();
  }

  _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GradientBackground(
        image: Res.leaderboardGradientBackground,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 250),
            Center(
              child: ScaleTransition(
                scale: _animation,
                child: Image(
                  image: AssetImage(Res.logoImage),
                  width: 160,
                  height: 160,
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '| Développé par l\'équipe Eruditio',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colours.darkColour,
                      fontFamily: Fonts.inter,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '© 2024 Tout droit réservé',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w300,
                      color: Colours.darkColour,
                      fontFamily: Fonts.inter,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
