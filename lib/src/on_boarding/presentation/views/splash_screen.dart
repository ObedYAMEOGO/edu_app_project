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

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 200), // Space from the top
          const Center(
            child: Image(
              image: AssetImage(Res.logoImage),
              width: 150, // Adjust logo width
              height: 150, // Adjust logo height
            ),
          ),

          SizedBox(
            height: 80,
            child: Center(
              child: Text(
                "eruditio".toUpperCase(),
                style: TextStyle(
                  color: Colours.primaryColour,
                  fontFamily: Fonts.merriweather,
                  fontWeight: FontWeight.w700,
                  fontSize: 35,
                ),
              ),
            ),
          ),
          const Spacer(),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '| Developpé par Eduritio Team',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colours.darkColour,
                      fontFamily: Fonts.merriweather),
                ),
                const SizedBox(height: 5),
                Text(
                  '© 2024 Tous droits reservés',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                      color: Colours.darkColour,
                      fontFamily: Fonts.merriweather),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
