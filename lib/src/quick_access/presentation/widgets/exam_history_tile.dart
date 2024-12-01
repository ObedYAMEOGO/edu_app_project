import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/core/res/media_res.dart';
import 'package:edu_app_project/src/exams/domain/entities/user_exam.dart';
import 'package:edu_app_project/src/quick_access/presentation/views/exam_history_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ExamHistoryTile extends StatelessWidget {
  const ExamHistoryTile(
    this.exam, {
    super.key,
    this.navigateToDetails = true,
  });

  final UserExam exam;
  final bool navigateToDetails;

  @override
  Widget build(BuildContext context) {
    final answeredQuestionsPercentage =
        exam.answers.length / exam.totalQuestions;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: navigateToDetails
          ? () => Navigator.of(context).pushNamed(
                ExamHistoryDetailsScreen.routeName,
                arguments: exam,
              )
          : null,
      child: Row(
        children: [
          Container(
            height: 54,
            width: 54,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFFE4E6EA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: exam.examImageUrl == null
                ? Image.asset(Res.test)
                : Image.network(exam.examImageUrl!),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam.examTitle,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colours.primaryColour),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Vous avez terminé',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colours.secondaryColour,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    text: '${exam.answers.length}/${exam.totalQuestions} ',
                    style: TextStyle(
                      fontFamily: Fonts.montserrat,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: answeredQuestionsPercentage < .5
                          ? Colours.redColour
                          : Colours.successColor,
                    ),
                    children: const [
                      TextSpan(
                        text: 'questions',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colours.primaryColour),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          CircularStepProgressIndicator(
            totalSteps: exam.totalQuestions,
            currentStep: exam.answers.length,
            unselectedColor: Color(0xFFE4E6EA),
            selectedColor: answeredQuestionsPercentage < .5
                ? Colours.redColour
                : Colours.successColor,
            padding: 0,
            width: 60,
            height: 60,
            child: Center(
              child: Text(
                '${(answeredQuestionsPercentage * 100).toInt()}',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: Fonts.montserrat,
                  color: answeredQuestionsPercentage < .5
                      ? Colours.redColour
                      : Colours.successColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
