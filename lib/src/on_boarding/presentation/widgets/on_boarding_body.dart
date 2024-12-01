import 'dart:async';

import 'package:edu_app_project/core/extensions/context_extension.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/src/authentication/presentation/views/sign_in_screen.dart';
import 'package:edu_app_project/src/dashboard/presentation/views/dashboard.dart';
import 'package:edu_app_project/src/on_boarding/domain/entities/page_content.dart';
import 'package:edu_app_project/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnBoardingBody extends StatefulWidget {
  const OnBoardingBody({
    required this.pageContent,
    required this.isLastPage,
    required this.onNextPagePressed,
    super.key,
  });

  final PageContent pageContent;
  final bool isLastPage;
  final VoidCallback onNextPagePressed;

  @override
  _OnBoardingBodyState createState() => _OnBoardingBodyState();
}

class _OnBoardingBodyState extends State<OnBoardingBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double padding = context.width * 0.07;
    final double imageHeight = context.height * 0.5;
    final double buttonWidth = context.width * 0.2;
    final double fontSizeTitle = context.width * 0.075;
    final double fontSizeDescription =
        context.width * 0.04; // Description font size

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: context.height * 0.02),
          Image.asset(
            widget.pageContent.image,
            height: imageHeight,
            fit: BoxFit.contain,
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: padding, vertical: padding),
            child: Column(
              children: [
                Text(
                  widget.pageContent.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: Fonts.montserrat,
                    fontSize: fontSizeTitle,
                    fontWeight: FontWeight.bold,
                    color: Colours.primaryColour,
                  ),
                ),
                SizedBox(height: context.height * 0.02),
                Text(
                  widget.pageContent.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSizeDescription,
                    color: Colours.darkColour,
                  ),
                ),
                SizedBox(height: context.height * 0.08),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              if (!widget.isLastPage) ...[
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ScaleTransition(
                      scale: Tween<double>(begin: 1.0, end: 1.3).animate(
                        CurvedAnimation(
                          parent: _controller,
                          curve: Curves.easeInOut,
                        ),
                      ),
                      child: Container(
                        width: context.width * 0.15,
                        height: context.width * 0.15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colours.primaryColour.withOpacity(0.2),
                        ),
                      ),
                    ),
                    FloatingActionButton(
                      shape: const CircleBorder(),
                      mini: true,
                      onPressed: widget.onNextPagePressed,
                      backgroundColor: Colours.primaryColour,
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colours.whiteColour,
                        size: context.width * 0.05,
                      ),
                    ),
                  ],
                ),
              ] else
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: buttonWidth,
                        vertical: context.height * 0.018,
                      ),
                      backgroundColor: Colours.primaryColour,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      await context.read<OnBoardingCubit>().cacheFirstTimer();
                      unawaited(
                        navigator.pushReplacementNamed(
                          FirebaseAuth.instance.currentUser == null
                              ? SignInScreen.routeName
                              : Dashboard.routeName,
                        ),
                      );
                    },
                    child: Text(
                      'Commencer',
                      style: TextStyle(
                        fontFamily: Fonts.montserrat,
                        fontWeight: FontWeight.bold,
                        fontSize: context.width * 0.043,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
