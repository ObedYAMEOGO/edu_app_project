import 'dart:convert';
import 'dart:io';

import 'package:edu_app_project/core/common/features/course/domain/entities/course.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/src/admin/presentation/widgets/course_picker.dart';
import 'package:edu_app_project/core/enums/notification_enum.dart';
import 'package:edu_app_project/core/res/media_res.dart';
import 'package:edu_app_project/core/utils/core_utils.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/exams/data/models/exam_model.dart';
import 'package:edu_app_project/src/exams/presentation/app/cubit/exam_cubit.dart';
import 'package:edu_app_project/src/notifications/presentation/widgets/notification_wrapper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

class AddExamView extends StatefulWidget {
  const AddExamView({super.key});

  static const routeName = '/add-exams';

  @override
  State<AddExamView> createState() => _AddExamViewState();
}

class _AddExamViewState extends State<AddExamView> {
  File? examFile;

  final formKey = GlobalKey<FormState>();
  final courseController = TextEditingController();
  final courseNotifier = ValueNotifier<Course?>(null);

  Future<void> pickExamFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result != null) {
      setState(() {
        examFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> uploadExam() async {
    if (examFile == null) {
      return Utils.showSnackBar(context,
          'Veuillez selectionner la fiche d\'examen', ContentType.warning,
          title: 'Humm!');
    }
    if (formKey.currentState!.validate()) {
      final json = examFile!.readAsStringSync();
      final jsonMap = jsonDecode(json) as DataMap;
      final exam = ExamModel.fromUploadMap(jsonMap)
          .copyWith(courseId: courseNotifier.value!.id);
      await context.read<ExamCubit>().uploadExam(exam);
    }
  }

  bool showingDialog = false;

  @override
  void dispose() {
    courseController.dispose();
    courseNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationWrapper(
      onNotificationSent: () {
        Navigator.of(context).pop();
      },
      child: BlocListener<ExamCubit, ExamState>(
        listener: (_, state) {
          if (showingDialog == true) {
            Navigator.pop(context);
            showingDialog = false;
          }
          if (state is UploadingExam) {
            Utils.showLoadingDialog(context);
            showingDialog = true;
          } else if (state is ExamError) {
            Utils.showSnackBar(
                context,
                "Une erreur s\'est produite. Verifiez votre connexion internet et réessayer !",
                ContentType.failure,
                title: "Oups !");
          } else if (state is ExamUploaded) {
            Utils.showSnackBar(context, 'Le quizz à été ajouté avec succès',
                ContentType.success,
                title: "Parfait!");
            Utils.sendNotification(
              context,
              title: '${courseNotifier.value!.title}',
              body: 'Un nouveau quiz vient d\'être ajouté pour le cours de '
                  '${courseNotifier.value!.title}',
              category: NotificationCategory.NONE,
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              titleSpacing: 0,
              title: Text(
                'Nouveau Quiz',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colours.primaryColour),
              )),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: CoursePicker(
                        controller: courseController,
                        notifier: courseNotifier,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (examFile != null) ...[
                      const SizedBox(height: 10),
                      Card(
                        child: ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Image.asset(
                              Res.json,
                              width: 30,
                            ),
                          ),
                          title: Text(
                            examFile!.path.split('/').last,
                            style: TextStyle(
                                color: Colours.primaryColour,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                          trailing: IconButton(
                            onPressed: () => setState(() {
                              examFile = null;
                            }),
                            icon: const Icon(IconlyBroken.close_square,
                                color: Colors.red, size: 30),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: pickExamFile,
                            child: Text(
                              examFile == null
                                  ? 'Selectionner un fichier'
                                  : 'Changer de fichier',
                              style: TextStyle(color: Colours.secondaryColour),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: uploadExam,
                            child: const Text(
                              'Confirmer',
                              style: TextStyle(color: Colours.secondaryColour),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
