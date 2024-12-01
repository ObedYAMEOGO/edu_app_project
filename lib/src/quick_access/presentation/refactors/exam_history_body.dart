import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:edu_app_project/core/common/views/loading_view.dart';
import 'package:edu_app_project/core/common/widgets/not_found_text.dart';
import 'package:edu_app_project/core/utils/core_utils.dart';
import 'package:edu_app_project/src/exams/presentation/app/cubit/exam_cubit.dart';
import 'package:edu_app_project/src/quick_access/presentation/widgets/exam_history_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExamHistoryBody extends StatefulWidget {
  const ExamHistoryBody({super.key});

  @override
  State<ExamHistoryBody> createState() => _ExamHistoryBodyState();
}

class _ExamHistoryBodyState extends State<ExamHistoryBody> {
  void getHistory() {
    context.read<ExamCubit>().getUserExams();
  }

  @override
  void initState() {
    super.initState();
    getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExamCubit, ExamState>(
      listener: (_, state) {
        if (state is ExamError) {
          Utils.showSnackBar(
            context,
            'Une erreur s\'est produite. Vérifiez votre connexion internet et réessayez!',
            ContentType.failure,
            title: 'Oups!',
          );
        }
      },
      builder: (context, state) {
        if (state is GettingUserExams) {
          return const LoadingView();
        } else if ((state is UserExamsLoaded && state.exams.isEmpty) ||
            state is ExamError) {
          return const NotFoundText(
              'Vous n\'avez passer aucun\n quizz pour le moment');
        } else if (state is UserExamsLoaded) {
          final exams = state.exams
            ..sort(
              (a, b) => b.dateSubmitted.compareTo(a.dateSubmitted),
            );
          return ListView.builder(
            itemCount: exams.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (_, index) {
              final exam = exams[index];
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExamHistoryTile(exam),
                  if (index != exams.length - 1) const SizedBox(height: 20),
                ],
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
