import 'dart:io';

import 'package:edu_app_project/core/common/features/category/data/models/category_model.dart';
import 'package:edu_app_project/core/common/features/category/presentation/cubit/category_cubit.dart';
import 'package:edu_app_project/core/common/widgets/titled_input_field.dart';
import 'package:edu_app_project/core/enums/notification_enum.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/core/utils/constants.dart';
import 'package:edu_app_project/core/utils/core_utils.dart';
import 'package:edu_app_project/src/admin/presentation/utils/admin_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

class AddCategorySheet extends StatefulWidget {
  const AddCategorySheet({super.key});

  @override
  State<AddCategorySheet> createState() => _AddCategorySheetState();
}

class _AddCategorySheetState extends State<AddCategorySheet> {
  final titleController = TextEditingController();
  final imageController = TextEditingController();
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
    imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoryCubit, CategoryState>(
      listener: (context, state) async {
        if (state is CategoryError) {
          Utils.showSnackBar(
            context,
            'Une erreur s\'est produite. Vérifiez votre connexion internet et réessayez!',
            ContentType.failure,
            title: 'Oups!',
          );
        } else if (state is AddingCategory) {
          loading = true;
          Utils.showLoadingDialog(context);
        } else if (state is CategoryAdded) {
          if (loading) {
            loading = false;
            Navigator.pop(context);
          }
          Utils.showSnackBar(
            context,
            'Une nouvelle catégorie de cours a été ajouté avec succès',
            ContentType.success,
            title: 'Parfait!',
          );
          Utils.showLoadingDialog(context);
          final navigator = Navigator.of(context);
          Utils.sendNotification(
            context,
            title: 'Du nouveau sur (${titleController.text.trim()})',
            body: 'Une nouvelle catégorie vient d\'être ajouté',
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
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // S'assure que la hauteur est ajustée
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ajouter un nouveau cours',
                      style: TextStyle(
                        fontFamily: Fonts.merriweather,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(IconlyBroken.close_square,
                          color: Colours.redColour, size: 30),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TitledInputField(
                  controller: titleController,
                  title: 'Nom catégorie',
                  hintStyle: TextStyle(
                    fontFamily: Fonts.merriweather,
                  ),
                ),
                const SizedBox(height: 20),
                TitledInputField(
                  controller: imageController,
                  title: 'Image catégorie',
                  hintText:
                      'Saisir le lien de l\'image ou sélectionner depuis votre galerie',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontFamily: Fonts.merriweather,
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
                    icon: const Icon(IconlyBroken.image,
                        color: Colours.primaryColour),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colours.primaryColour,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 50),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final category = CategoryModel.empty().copyWith(
                          categoryTitle: titleController.text.trim(),
                          categoryImage: imageController.text.trim().isEmpty
                              ? kDefaultImage
                              : isFile
                                  ? image!.path
                                  : imageController.text.trim(),
                          isImageFile: isFile,
                        );
                        context.read<CategoryCubit>().addCategory(category);
                      }
                    },
                    child: const Text(
                      'Ajouter',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: Fonts.merriweather,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
