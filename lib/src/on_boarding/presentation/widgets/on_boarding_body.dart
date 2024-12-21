import 'dart:async';

import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/src/authentication/presentation/views/sign_in_screen.dart';
import 'package:edu_app_project/src/dashboard/presentation/views/dashboard.dart';
import 'package:edu_app_project/src/on_boarding/domain/entities/page_content.dart';
import 'package:edu_app_project/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnBoardingBody extends StatelessWidget {
  const OnBoardingBody({required this.pageContent, super.key});

  final PageContent pageContent;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          pageContent.image,
          height: mq.height * .3,
        ),
        SizedBox(height: mq.height * .03),
        Padding(
          padding: const EdgeInsets.all(20).copyWith(bottom: 0),
          child: Column(
            children: [
              SizedBox(height: mq.height * .02),
              Text(
                pageContent.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Colours.primaryColour,
                ),
              ),
              SizedBox(height: mq.height * .02),
              Text(
                pageContent.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colours.secondaryColour,
                ),
              ),
              SizedBox(height: mq.height * .05),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 17,
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
                child: const Text(
                  'Commencer',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
