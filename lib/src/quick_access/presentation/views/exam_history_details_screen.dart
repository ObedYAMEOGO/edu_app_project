import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/src/exams/domain/entities/user_exam.dart';
import 'package:edu_app_project/src/quick_access/presentation/widgets/exam_history_answer_tile.dart';
import 'package:edu_app_project/src/quick_access/presentation/widgets/exam_history_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExamHistoryDetailsScreen extends StatefulWidget {
  const ExamHistoryDetailsScreen(this.exam, {super.key});

  static const routeName = '/details-historique-examen';

  final UserExam exam;

  @override
  State<ExamHistoryDetailsScreen> createState() =>
      _ExamHistoryDetailsScreenState();
}

class _ExamHistoryDetailsScreenState extends State<ExamHistoryDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colours.primaryColour),
          titleSpacing: 0,
          title: Text(
            'Historique',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colours.primaryColour,
            ),
          )),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExamHistoryTile(widget.exam, navigateToDetails: false),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  text: 'Date de soumission : ',
                  style: TextStyle(
                    color: Colours.primaryColour,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: DateFormat.yMMMMd('fr_FR')
                          .format(widget.exam.dateSubmitted),
                      style: TextStyle(
                        color: Colours.secondaryColour,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: widget.exam.answers.length,
                  separatorBuilder: (_, __) => const Divider(
                    thickness: 1,
                    color: Color(0xFFE4E6EA),
                  ),
                  itemBuilder: (_, index) {
                    final answer = widget.exam.answers[index];
                    return ExamHistoryAnswerTile(answer, index: index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
