import 'package:edu_app_project/core/extensions/context_extensions.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/src/on_boarding/domain/entities/page_content.dart';
import 'package:flutter/material.dart';

class OnBoardingBody extends StatefulWidget {
  const OnBoardingBody({
    required this.pageContent,
    required this.isLastPage,
    required this.onNextPagePressed,
    super.key,
  });

  final PageContent pageContent;
  final bool isLastPage; // Indicates if this is the last page
  final VoidCallback onNextPagePressed; // Callback to move to the next page

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
    )..repeat(reverse: true); // Repeat animation in a continuous loop
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(widget.pageContent.image, height: context.height * .5),
        Padding(
          padding:
              const EdgeInsets.all(0).copyWith(bottom: 10, left: 20, right: 20),
          child: Column(
            children: [
              Text(
                widget.pageContent.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: Fonts.montserrat,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: context.height * .01),
              Text(
                widget.pageContent.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              SizedBox(height: context.height * .06),
            ],
          ),
        ),

        // Stack to overlay "Continuer" text and button
        Stack(
          alignment: Alignment.center,
          children: [
            // Only show the text and button if it's not the last page
            if (!widget.isLastPage) ...[
              const SizedBox(width: 10), // Spacing between text and button
              Stack(
                alignment: Alignment.center,
                children: [
                  // Glowing Circle Effect
                  ScaleTransition(
                    scale: Tween<double>(begin: 1.0, end: 1.3).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: Curves.easeInOut,
                      ),
                    ),
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colours.primaryColour.withOpacity(0.2),
                      ),
                    ),
                  ),
                  // Actual Floating Action Button
                  FloatingActionButton(
                    shape: const CircleBorder(),
                    mini: true,
                    onPressed: widget.onNextPagePressed,
                    backgroundColor: Colours.primaryColour,
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colours.whiteColour,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ]

            // Show the button if it's the last page
            else
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 100,
                      vertical: 17,
                    ),
                    backgroundColor: Colours.primaryColour,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: widget.onNextPagePressed,
                  child: const Text(
                    'Commencer',
                    style: TextStyle(
                      fontFamily: Fonts.montserrat,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
