import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/src/exams/domain/entities/user_choice.dart';
import 'package:flutter/material.dart';

class ExamHistoryAnswerTile extends StatelessWidget {
  const ExamHistoryAnswerTile(this.answer, {required this.index, super.key});

  final UserChoice answer;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      iconColor: Colours.darkColour,
      shape: const OutlineInputBorder(
        borderSide: BorderSide.none,
      ),
      tilePadding: EdgeInsets.zero,
      expandedAlignment: Alignment.centerLeft,
      title: Text(
        'Question $index',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          fontFamily: Fonts.inter,
          color: Colours.darkColour,
        ),
      ),
      subtitle: Text(
        answer.isCorrect ? 'Vrai' : 'Faux',
        style: TextStyle(
            fontSize: 12,
            color: answer.isCorrect ? Colours.successColor : Colours.pinkColour,
            fontWeight: FontWeight.w400,
            fontFamily: Fonts.inter),
      ),
      children: [
        Text(
          'Ma reponse: ${answer.userChoice}',
          style: TextStyle(
              color:
                  answer.isCorrect ? Colours.successColor : Colours.pinkColour,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: Fonts.inter),
        ),
      ],
    );
  }
}
