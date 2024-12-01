import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:edu_app_project/core/common/widgets/course_info_tile.dart';
import 'package:edu_app_project/core/common/widgets/nested_back_button.dart';
import 'package:edu_app_project/core/common/widgets/rounded_button.dart';
import 'package:edu_app_project/core/extensions/int_extensions.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/core/res/media_res.dart';
import 'package:edu_app_project/core/utils/core_utils.dart';
import 'package:edu_app_project/src/exams/data/models/exam_model.dart';
import 'package:edu_app_project/src/exams/domain/entities/exam.dart';
import 'package:edu_app_project/src/exams/presentation/app/cubit/exam_cubit.dart';
import 'package:edu_app_project/src/exams/presentation/views/exam_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExamDetailsView extends StatefulWidget {
  const ExamDetailsView(this.exam, {super.key});

  static const routeName = '/exam-details';

  final Exam exam;

  @override
  State<ExamDetailsView> createState() => _ExamDetailsViewState();
}

class _ExamDetailsViewState extends State<ExamDetailsView> {
  late Exam completeExam;

  void getQuestions() {
    context.read<ExamCubit>().getExamQuestions(widget.exam);
  }

  @override
  void initState() {
    completeExam = widget.exam;
    super.initState();
    getQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: NestedBackButton(),
        title: Text(
          widget.exam.title,
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colours.primaryColour,
              fontSize: 15),
        ),
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
          } else if (state is ExamQuestionsLoaded) {
            completeExam = (completeExam as ExamModel).copyWith(
              questions: state.questions,
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildExamHeader(),
                  const SizedBox(height: 20),
                  _buildExamDetails(state),
                  const SizedBox(height: 30),
                  _buildStartExamButton(state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildExamHeader() {
    return Column(
      children: [
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
              color: Color(0xFFE4E6EA),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: completeExam.imageUrl != null
                  ? Image.network(
                      completeExam.imageUrl!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      Res.test,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          completeExam.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colours.primaryColour,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          completeExam.description,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 13,
              color: Colours.secondaryColour,
              fontFamily: Fonts.montserrat),
        ),
      ],
    );
  }

  Widget _buildExamDetails(ExamState state) {
    return Column(
      children: [
        CourseInfoTile(
          image: Res.examTime,
          title:
              'Durée limite : ${completeExam.timeLimit.displayDurationLong}.',
          subtitle: 'Vous devez compléter l\'examen en '
              '${completeExam.timeLimit.displayDurationLong}.',
        ),
        const SizedBox(height: 10),
        if (state is ExamQuestionsLoaded)
          CourseInfoTile(
            image: Res.examQuestions,
            title: '${completeExam.questions?.length} questions',
            subtitle:
                'Cet examen contient ${completeExam.questions?.length} questions.',
          )
        else if (state is GettingExamQuestions)
          const Center(
            child: CircularProgressIndicator(color: Colours.primaryColour),
          )
        else
          const Text(
            'Aucune question disponible pour cet examen.',
            textAlign: TextAlign.center,
          ),
      ],
    );
  }

  Widget _buildStartExamButton(ExamState state) {
    return state is ExamQuestionsLoaded
        ? RoundedButton(
            label: 'Commencer l\'examen',
            onPressed: () {
              Navigator.pushNamed(
                context,
                ExamView.routeName,
                arguments: completeExam,
              );
            },
          )
        : const SizedBox.shrink();
  }
}
