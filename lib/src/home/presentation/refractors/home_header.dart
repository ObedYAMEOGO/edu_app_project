import 'package:edu_app_project/core/common/app/providers/user_provider.dart';
import 'package:edu_app_project/core/extensions/context_extension.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/src/home/presentation/widgets/tinder_cards.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: 10,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Hello!\n',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: Fonts.inter,
                      fontWeight: FontWeight.w500,
                      color: Colours.darkColour.withOpacity(0.5),
                    ),
                  ),
                  TextSpan(
                    text: context.watch<UserProvider>().user!.fullName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: Fonts.inter,
                      fontWeight: FontWeight.w500,
                      color: Colours.darkColour,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: context.height >= 926
                ? -20
                : context.height >= 844
                    ? -6
                    : 10,
            right: -14,
            child: const TinderCards(),
          ),
        ],
      ),
    );
  }
}
