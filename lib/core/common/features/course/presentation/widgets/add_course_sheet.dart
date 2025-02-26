import 'dart:io';

import 'package:edu_app_project/core/common/features/category/domain/entities/category.dart';
import 'package:edu_app_project/core/common/features/course/data/models/course_model.dart';
import 'package:edu_app_project/core/common/features/course/presentation/cubit/course_cubit.dart';
import 'package:edu_app_project/core/common/widgets/titled_input_field.dart';
import 'package:edu_app_project/core/enums/notification_enum.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/core/utils/constants.dart';
import 'package:edu_app_project/core/utils/core_utils.dart';
import 'package:edu_app_project/src/admin/presentation/utils/admin_utils.dart';
import 'package:edu_app_project/src/admin/presentation/widgets/category_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCourseSheet extends StatefulWidget {
  const AddCourseSheet({super.key});

  @override
  State<AddCourseSheet> createState() => _AddCourseSheetState();
}

class _AddCourseSheetState extends State<AddCourseSheet> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final imageController = TextEditingController();
  final categoryController = TextEditingController();
  final categoryNotifier = ValueNotifier<Category?>(null);
  final formKey = GlobalKey<FormState>();

  File? image;
  bool isFile = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    imageController.addListener(() {
      if (isFile && imageController.text.trim().isEmpty) {
        image = null;
        isFile = false;
      }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    imageController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CourseCubit, CourseState>(
      listener: (context, state) async {
        if (state is CourseError) {
          Utils.showSnackBar(
            context,
            'Une erreur s\'est produite. Vérifiez votre connexion internet et réessayez!',
            ContentType.failure,
            title: 'Oups!',
          );
        } else if (state is AddingCourse) {
          loading = true;
          Utils.showLoadingDialog(context);
        } else if (state is CourseAdded) {
          if (loading) {
            loading = false;
            Navigator.pop(context);
          }
          Utils.showSnackBar(
            context,
            'Votre nouveau cours a été ajouté avec succès',
            ContentType.success,
            title: 'Parfait!',
          );
          Utils.showLoadingDialog(context);
          final navigator = Navigator.of(context);
          Utils.sendNotification(
            context,
            title: 'Du nouveau sur (${titleController.text.trim()})',
            body: 'Un nouveau cours vient d\'être ajouté',
            category: NotificationCategory.COURSE,
          );
          navigator
            ..pop()
            ..pop();
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ajouter un nouveau cours',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          fontFamily: Fonts.inter,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close, color: Colors.red, size: 30),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TitledInputField(
                    controller: titleController,
                    title: 'Intitulé du cours',
                    hintStyle: TextStyle(
                      fontFamily: Fonts.inter,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TitledInputField(
                    controller: descriptionController,
                    title: 'Description du cours',
                    hintStyle: TextStyle(
                      fontFamily: Fonts.inter,
                    ),
                    required: false,
                  ),
                  const SizedBox(height: 20),
                  CategoryPicker(
                    controller: categoryController,
                    notifier: categoryNotifier,
                  ),
                  const SizedBox(height: 20),
                  TitledInputField(
                    controller: imageController,
                    title: 'Image du cours',
                    hintText:
                        'Saisir le lien de l\'image ou sélectionner depuis votre galerie',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: Fonts.inter,
                    ),
                    required: false,
                    suffixIcon: IconButton(
                      onPressed: () async {
                        final image = await AdminUtils.pickImage();
                        if (image != null) {
                          isFile = true;
                          this.image = image;
                          final imageName = image.path.split('/').last;
                          imageController.text = imageName;
                        }
                      },
                      icon:
                          const Icon(Icons.image, color: Colours.primaryColour),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Gradient Button
                  GestureDetector(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        final now = DateTime.now();
                        final course = CourseModel.empty().copyWith(
                          title: titleController.text.trim(),
                          description: descriptionController.text.trim(),
                          image: imageController.text.trim().isEmpty
                              ? kDefaultImage
                              : isFile
                                  ? image!.path
                                  : imageController.text.trim(),
                          createdAt: now,
                          updatedAt: now,
                          imageIsFile: isFile,
                          courseCategoryId:
                              categoryNotifier.value?.categoryId ?? '',
                        );
                        context.read<CourseCubit>().addCourse(course);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 50),
                      decoration: BoxDecoration(
                        gradient: Colours.primaryGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Ajouter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: Fonts.inter,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
