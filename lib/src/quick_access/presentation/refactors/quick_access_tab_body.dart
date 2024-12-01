import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:edu_app_project/core/common/features/course/presentation/cubit/course_cubit.dart';
import 'package:edu_app_project/core/common/views/loading_view.dart';
import 'package:edu_app_project/core/common/widgets/not_found_text.dart';
import 'package:edu_app_project/core/services/injection_container.dart';
import 'package:edu_app_project/core/utils/core_utils.dart';
import 'package:edu_app_project/src/exams/presentation/app/cubit/exam_cubit.dart';
import 'package:edu_app_project/src/quick_access/presentation/providers/quick_access_tab_controller.dart';
import 'package:edu_app_project/src/quick_access/presentation/refactors/document_and_exam_body.dart';
import 'package:edu_app_project/src/quick_access/presentation/refactors/exam_history_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class QuickAccessTabBody extends StatefulWidget {
  const QuickAccessTabBody({super.key});

  @override
  State<QuickAccessTabBody> createState() => _QuickAccessTabBodyState();
}

class _QuickAccessTabBodyState extends State<QuickAccessTabBody> {
  @override
  void initState() {
    super.initState();
    context.read<CourseCubit>().getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CourseCubit, CourseState>(
      listener: (_, state) {
        if (state is CourseError) {
          Utils.showSnackBar(
            context,
            'Une erreur s\'est produite. Vérifiez votre connexion internet et réessayez!',
            ContentType.failure,
            title: 'Oups!',
          );
        }
      },
      builder: (context, state) {
        if (state is LoadingCourses) {
          return const LoadingView();
        } else if ((state is CoursesLoaded && state.courses.isEmpty) ||
            state is CourseError) {
          return const NotFoundText(
              'Aucun cours disponible \n Veuillez contacter l\'administrateur.');
        } else if (state is CoursesLoaded) {
          final courses = state.courses
            ..sort(
              (a, b) => b.updatedAt.compareTo(a.updatedAt),
            );
          return Consumer<QuickAccessTabController>(
            builder: (_, controller, __) {
              switch (controller.currentIndex) {
                case 0:
                case 1:
                  return DocumentAndExamBody(
                    courses: courses,
                    index: controller.currentIndex,
                  );
                default:
                  return BlocProvider(
                    create: (_) => sl<ExamCubit>(),
                    child: const ExamHistoryBody(),
                  );
              }
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
