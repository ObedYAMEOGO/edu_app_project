import 'package:edu_app_project/core/common/views/loading_view.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/src/on_boarding/domain/entities/page_content.dart';
import 'package:edu_app_project/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:edu_app_project/src/on_boarding/presentation/widgets/on_boarding_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  static const routeName = '/';

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController pageController = PageController();
  int currentPage = 0; // Tracks the current page

  @override
  void initState() {
    super.initState();
    context.read<OnBoardingCubit>().checkIfUserIsFirstTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<OnBoardingCubit, OnBoardingState>(
        listener: (context, state) {
          if (state is OnBoardingStatus && !state.isFirstTimer) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is UserCached) {
            Navigator.pushReplacementNamed(context, '/');
          }
        },
        builder: (context, state) {
          if (state is CheckingIfUserIsFirstTimer ||
              state is CachingFirstTimer) {
            return const LoadingView();
          }
          return Stack(
            children: [
              PageView(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                children: [
                  OnBoardingBody(
                    pageContent: const PageContent.first(),
                    isLastPage: false,
                    onNextPagePressed: () {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                  OnBoardingBody(
                    pageContent: const PageContent.second(),
                    isLastPage: false,
                    onNextPagePressed: () {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                  OnBoardingBody(
                    pageContent: const PageContent.third(),
                    isLastPage: true,
                    onNextPagePressed: () {
                      context.read<OnBoardingCubit>().cacheFirstTimer();
                    },
                  ),
                ],
              ),
              if (currentPage !=
                  3) // Only show SmoothPageIndicator for first two pages
                Align(
                  alignment: Alignment.center,
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: 3,
                    effect: const SwapEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      spacing: 10,
                      activeDotColor: Colours.primaryColour,
                      dotColor: Colours.secondaryWhiteColour,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
