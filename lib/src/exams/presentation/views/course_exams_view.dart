import 'package:edu_app_project/core/common/features/course/domain/entities/course.dart';
import 'package:edu_app_project/core/common/views/loading_view.dart';
import 'package:edu_app_project/core/common/widgets/nested_back_button.dart';
import 'package:edu_app_project/core/common/widgets/not_found_text.dart';
import 'package:edu_app_project/core/extensions/int_extensions.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/core/utils/core_utils.dart';
import 'package:edu_app_project/src/exams/presentation/app/cubit/exam_cubit.dart';
import 'package:edu_app_project/src/exams/presentation/views/exam_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseExamsView extends StatefulWidget {
  const CourseExamsView(this.course, {super.key});

  static const routeName = '/course-exams';

  final Course course;

  @override
  State<CourseExamsView> createState() => _CourseExamsViewState();
}

class _CourseExamsViewState extends State<CourseExamsView> {
  void getExams() {
    context.read<ExamCubit>().getExams(widget.course.id);
  }

  @override
  void initState() {
    super.initState();
    getExams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          'Quiz ${widget.course.title}',
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colours.darkColour,
              fontFamily: Fonts.merriweather,
              fontSize: 17),
        ),
        leading: const NestedBackButton(),
      ),
      body: BlocConsumer<ExamCubit, ExamState>(
        listener: (_, state) {
          if (state is ExamError) {
            Utils.showSnackBar(
              context,
              "Une erreur s'est produite. Vérifiez votre connexion internet et réessayez !",
              ContentType.failure,
              title: "Oups !",
            );
          }
        },
        builder: (context, state) {
          if (state is GettingExams) {
            return const LoadingView();
          } else if ((state is ExamsLoaded && state.exams.isEmpty) ||
              state is ExamError) {
            return NotFoundText(
              'Pas de quiz disponible sur ${widget.course.title}',
            );
          } else if (state is ExamsLoaded) {
            return SafeArea(
              child: ListView.builder(
                itemCount: state.exams.length,
                padding: const EdgeInsets.all(20),
                itemBuilder: (_, index) {
                  final exam = state.exams[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.quiz_sharp,
                                color: Colours.darkColour,
                                size: 16,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  exam.title,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: Fonts.merriweather,
                                    color: Colours.darkColour,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            exam.description,
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: Fonts.merriweather,
                              color: Colours.darkColour,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.timer,
                                    size: 18,
                                    color: Colours.darkColour,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    exam.timeLimit.displayDuration,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  backgroundColor: Colours.primaryColour,
                                  foregroundColor: Colours.whiteColour,
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    ExamDetailsView.routeName,
                                    arguments: exam,
                                  );
                                },
                                child: const Text(
                                  'Passer le quiz',
                                  style: TextStyle(
                                    fontFamily: Fonts.merriweather,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
