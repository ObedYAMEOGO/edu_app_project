import 'package:edu_app_project/core/common/widgets/nested_back_button.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/core/res/media_res.dart';
import 'package:edu_app_project/core/utils/core_utils.dart';
import 'package:edu_app_project/src/exams/presentation/app/cubit/exam_cubit.dart';
import 'package:edu_app_project/src/exams/presentation/app/providers/exam_controller.dart';
import 'package:edu_app_project/src/exams/presentation/widgets/exam_navigation_blob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class ExamView extends StatefulWidget {
  const ExamView({super.key});

  static const routeName = '/exam';

  @override
  State<ExamView> createState() => _ExamViewState();
}

class _ExamViewState extends State<ExamView> {
  bool showingLoader = false;

  late ExamController examController;

  Future<void> submitExam() async {
    if (!examController.isTimeUp) {
      examController.stopTimer();
      final isMinutesLeft = examController.remainingTimeInSeconds > 60;
      final isHoursLeft = examController.remainingTimeInSeconds > 3600;
      final timeLeftText = isHoursLeft
          ? 'heures'
          : isMinutesLeft
              ? 'minutes'
              : 'secondes';

      final endExam = await showCupertinoDialog<bool>(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text(
              'Soumettre?',
              style: TextStyle(color: Colours.primaryColour),
            ),
            content: Text(
              'Il vous reste ${examController.remainingTime} $timeLeftText.\n'
              'Êtes-vous sûr(e) de vouloir soumettre?',
              style: TextStyle(color: Colours.darkColour),
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text(
                  'Annuler',
                  style: TextStyle(
                    color: Colours.darkColour,
                  ),
                ),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                isDestructiveAction: true,
                child: const Text('J\'ai fini'),
              ),
            ],
          );
        },
      );
      if (endExam ?? false) {
        return collectAndSend();
      } else {
        examController.startTimer();
        return;
      }
    }
    collectAndSend();
  }

  void collectAndSend() {
    final exam = examController.userExam;
    context.read<ExamCubit>().submitExam(exam);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    examController = context.read<ExamController>();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPersistentFrameCallback((_) {
      examController.addListener(() {
        if (examController.isTimeUp) submitExam();
      });
    });
  }

  @override
  void dispose() {
    examController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExamController>(
      builder: (_, controller, __) {
        return BlocConsumer<ExamCubit, ExamState>(
          listener: (_, state) {
            if (showingLoader) {
              Navigator.pop(context);
              showingLoader = false;
            }
            if (state is ExamError) {
              Utils.showSnackBar(
                  context,
                  "Une erreur s'est produite. Vérifiez votre connexion internet et réessayez!",
                  ContentType.failure,
                  title: "Oups !");
            } else if (state is SubmittingExam) {
              Utils.showLoadingDialog(context);
              showingLoader = true;
            } else if (state is ExamSubmitted) {
              Utils.showSnackBar(context,
                  "Votre quiz a été soumis avec succès!", ContentType.success,
                  title: "Parfait!");
              Navigator.pop(context);
            }
          },
          // ignore: deprecated_member_use
          builder: (_, state) => WillPopScope(
            onWillPop: () async {
              if (state is SubmittingExam) return false;
              if (controller.isTimeUp) return true;
              final result = await showCupertinoDialog<bool>(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: const Text(
                      'Quitter?',
                      style: TextStyle(color: Colours.primaryColour),
                    ),
                    content: const Text(
                      'Êtes-vous sûr(e) de vouloir quitter?',
                      style: TextStyle(color: Colours.darkColour),
                    ),
                    actions: [
                      CupertinoDialogAction(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text(
                          'Annuler',
                          style: TextStyle(color: Colours.darkColour),
                        ),
                      ),
                      CupertinoDialogAction(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        isDestructiveAction: true,
                        child: const Text(
                          'Quitter',
                          style: TextStyle(color: Colours.redColour),
                        ),
                      ),
                    ],
                  );
                },
              );
              return result ?? false;
            },
            child: Scaffold(
              backgroundColor: Colours.whiteColour,
              appBar: AppBar(
                centerTitle: true,
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer,
                      color: Colours.pinkColour,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      controller.remainingTime,
                      style: const TextStyle(
                        color: Colours.darkColour,
                        fontSize: 17,
                        fontFamily: Fonts.inter,
                      ),
                    ),
                  ],
                ),
                leading: NestedBackButton(),
                actions: [
                  TextButton(
                    onPressed: submitExam,
                    child: const Text('J\'ai fini',
                        style: TextStyle(
                            color: Colours.primaryColour,
                            fontSize: 17,
                            fontFamily: Fonts.inter,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Question ${controller.currentIndex + 1}',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                fontFamily: Fonts.inter,
                                color: Colours.darkColour,
                              ),
                            ),
                            const SizedBox(height: 12),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colours.whiteColour,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: controller.exam.imageUrl == null
                                    ? Image.asset(
                                        Res.test,
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.contain,
                                      )
                                    : Image.network(
                                        controller.exam.imageUrl!,
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              controller.currentQuestion.questionText,
                              style: const TextStyle(
                                color: Colours.darkColour,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: Fonts.inter,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.currentQuestion.choices.length,
                          itemBuilder: (_, index) {
                            final choice =
                                controller.currentQuestion.choices[index];
                            return ListTile(
                              leading: Radio(
                                activeColor: Colours.darkColour,
                                fillColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                        (states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return Colours
                                        .darkColour; // Couleur si sélectionné
                                  }
                                  return Colours.darkColour.withOpacity(
                                      0.5); // Bordure verte par défaut
                                }),
                                value: choice.identifier,
                                groupValue: controller.userAnswer?.userChoice,
                                onChanged: (value) {
                                  controller.answer(choice);
                                },
                              ),
                              title: Text(
                                '${choice.identifier}. ${choice.choiceAnswer}',
                                style: const TextStyle(
                                    color: Colours.darkColour,
                                    fontFamily: Fonts.inter,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            );
                          },
                        ),
                      ),
                      const ExamNavigationBlob(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
