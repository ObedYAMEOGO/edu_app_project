import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/src/exams/presentation/app/providers/exam_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExamNavigationBlob extends StatelessWidget {
  const ExamNavigationBlob({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExamController>(
      builder: (_, controller, __) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${controller.currentIndex + 1} /'
                ' ${controller.totalQuestions}',
                style:
                    const TextStyle(fontSize: 12, color: Colours.greenColour),
              ),
              const SizedBox(height: 5),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colours.greenColour,
                  borderRadius: BorderRadius.circular(8),
                  // boxShadow: const [
                  //   // BoxShadow(
                  //   //   color: Color(0xFFE8E8E8),
                  //   //   blurRadius: 20,
                  //   //   spreadRadius: 5,
                  //   //   offset: Offset(2, 6),
                  //   // ),
                  // ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: controller.previousQuestion,
                      icon: Icon(
                        Icons.arrow_back,
                        color: controller.currentIndex == 0
                            ? Colours.secondaryColour.withOpacity(0.5)
                            : Colours.primaryColour,
                      ),
                    ),
                    Container(
                      color: Colours.primaryColour,
                      width: 1,
                      height: 24,
                    ),
                    IconButton(
                      onPressed: controller.nextQuestion,
                      icon: Icon(
                        Icons.arrow_forward,
                        color: controller.currentIndex ==
                                controller.totalQuestions - 1
                            ? Colours.secondaryColour.withOpacity(0.5)
                            : Colours.primaryColour,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
