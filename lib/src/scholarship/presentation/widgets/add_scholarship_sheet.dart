import 'dart:io';

import 'package:edu_app_project/core/common/widgets/titled_input_field.dart';
import 'package:edu_app_project/core/enums/notification_enum.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/core/utils/constants.dart';
import 'package:edu_app_project/core/utils/core_utils.dart';
import 'package:edu_app_project/src/admin/presentation/utils/admin_utils.dart';
import 'package:edu_app_project/src/scholarship/data/models/scholarship_model.dart';
import 'package:edu_app_project/src/scholarship/presentation/app/cubit/scholarship_cubit.dart';
import 'package:edu_app_project/src/scholarship/presentation/app/cubit/scholarship_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddScholarshipSheet extends StatefulWidget {
  const AddScholarshipSheet({super.key});

  @override
  State<AddScholarshipSheet> createState() => _AddScholarshipSheetState();
}

class _AddScholarshipSheetState extends State<AddScholarshipSheet> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  final numberOfRecipientsController = TextEditingController();
  final applicationDeadlineController = TextEditingController();
  final imageController = TextEditingController();
  final logoImageController = TextEditingController();
  final countryController = TextEditingController();
  final categoryController = TextEditingController();
  final videoUrlController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  File? image;
  File? logoImage;
  bool isFileImage = false;
  bool isFileLogoImage = false;
  bool loading = false;

  List<TextEditingController> availableFieldsControllers = [
    TextEditingController()
  ];

  @override
  void initState() {
    super.initState();
    imageController.addListener(() {
      if (isFileImage && imageController.text.trim().isEmpty) {
        image = null;
        isFileImage = false;
      }
    });

    logoImageController.addListener(() {
      if (isFileLogoImage && logoImageController.text.trim().isEmpty) {
        logoImage = null;
        isFileLogoImage = false;
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    amountController.dispose();
    numberOfRecipientsController.dispose();
    applicationDeadlineController.dispose();
    imageController.dispose();
    logoImageController.dispose();
    countryController.dispose();
    categoryController.dispose();
    videoUrlController.dispose();
    for (var controller in availableFieldsControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void addField() {
    setState(() {
      availableFieldsControllers.add(TextEditingController());
    });
  }

  void removeField(int index) {
    setState(() {
      if (availableFieldsControllers.length > 1) {
        availableFieldsControllers[index].dispose();
        availableFieldsControllers.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScholarshipCubit, ScholarshipState>(
      listener: (_, state) {
        if (state is ScholarshipError) {
          Utils.showSnackBar(
              context,
              "Une erreur s\'est produite. Verifiez votre connexion internet et réessayer !",
              ContentType.failure,
              title: "Oups !");
        } else if (state is AddingScholarship) {
          loading = true;
          Utils.showLoadingDialog(context);
        } else if (state is ScholarshipAdded) {
          if (loading) {
            loading = false;
            Navigator.pop(context);
          }
          Utils.showSnackBar(context, 'La bourse à été ajouté avec succès',
              ContentType.success,
              title: "Parfait!");
          Utils.showLoadingDialog(context);
          final navigator = Navigator.of(context);
          Utils.sendNotification(
            context,
            title: 'Nouvelle bourse disponible (${nameController.text.trim()})',
            body: 'Une nouvelle bourse a été ajoutée',
            category: NotificationCategory.SCHOLARSHIP,
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
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Form(
            key: formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Nouvelle bourse',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colours.darkColour,
                        fontFamily: Fonts.inter,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon:
                          Icon(Icons.close, color: Colours.redColour, size: 30),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TitledInputField(
                  controller: nameController,
                  title: 'Le nom de l\'université',
                  hintStyle: TextStyle(
                    fontFamily: Fonts.inter,
                  ),
                ),
                const SizedBox(height: 20),
                TitledInputField(
                  controller: descriptionController,
                  title: 'La description de la bourse',
                  hintStyle: TextStyle(
                    fontFamily: Fonts.inter,
                  ),
                ),
                const SizedBox(height: 20),
                TitledInputField(
                  controller: amountController,
                  title: 'Le montant de la bourse',
                  hintText: 'Saisir le montant de la bourse',
                  hintStyle: TextStyle(
                    fontFamily: Fonts.inter,
                  ),
                ),
                const SizedBox(height: 20),
                TitledInputField(
                  controller: countryController,
                  title: 'Le pays d\'acceuil',
                  hintStyle: TextStyle(
                    fontFamily: Fonts.inter,
                  ),
                ),
                const SizedBox(height: 20),
                TitledInputField(
                  controller: numberOfRecipientsController,
                  title: 'Nombre de places disponibles',
                  hintText: 'Le nombre de places disponibles',
                  hintStyle: TextStyle(
                    fontFamily: Fonts.inter,
                  ),
                ),
                const SizedBox(height: 20),
                TitledInputField(
                  controller: applicationDeadlineController,
                  title: 'La date limite de candidature',
                  hintText: 'Saisir la date limite de candidature',
                  hintStyle: TextStyle(
                    fontFamily: Fonts.inter,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Domaines disponibles',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colours.primaryColour,
                    fontFamily: Fonts.inter,
                  ),
                ),
                const SizedBox(height: 20),
                TitledInputField(
                  controller: categoryController,
                  title: 'Catégorie de la bourse',
                  hintText:
                      'Saisir la catégorie (par ex: Sciences, Arts, etc.)',
                  hintStyle: TextStyle(
                    fontFamily: Fonts.inter,
                  ),
                ),
                const SizedBox(height: 20),
                TitledInputField(
                  controller: videoUrlController,
                  title: 'Lien vidéo (optionnel)',
                  hintText: 'Saisir un lien vidéo pour la bourse',
                  hintStyle: TextStyle(
                    fontFamily: Fonts.inter,
                  ),
                  required: false,
                ),
                Column(
                  children:
                      List.generate(availableFieldsControllers.length, (index) {
                    return Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: availableFieldsControllers[index],
                            decoration: const InputDecoration(
                              hintText: 'Saisir un domaine disponible',
                              hintStyle: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF757575),
                                fontFamily: Fonts.inter,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline,
                              color: Colours.redColour),
                          onPressed: () => removeField(index),
                        ),
                      ],
                    );
                  }),
                ),
                TextButton.icon(
                  onPressed: addField,
                  icon: const Icon(Icons.add_box, color: Colours.redColour),
                  label: const Text('Ajouter un domaine',
                      style: TextStyle(
                        color: Colours.darkColour,
                        fontFamily: Fonts.inter,
                      )),
                ),
                const SizedBox(height: 20),
                TitledInputField(
                  controller: imageController,
                  title: 'Image illustrative',
                  required: false,
                  hintText:
                      'Saisir le lien de l\'image ou sélectionner depuis votre galerie',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontFamily: Fonts.inter,
                    fontSize: 12,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      final pickedImage = await AdminUtils.pickImage();
                      if (pickedImage != null) {
                        isFileImage = true;
                        image = pickedImage;
                        final imageName = pickedImage.path.split('/').last;
                        imageController.text = imageName;
                      }
                    },
                    icon: const Icon(Icons.image, color: Colours.primaryColour),
                  ),
                ),
                const SizedBox(height: 20),
                TitledInputField(
                  controller: logoImageController,
                  title: 'Logo de l\'université',
                  required: false,
                  hintText:
                      'Saisir le lien du logo ou sélectionner depuis votre galerie',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontFamily: Fonts.inter,
                    fontSize: 12,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      final pickedLogo = await AdminUtils.pickImage();
                      if (pickedLogo != null) {
                        isFileLogoImage = true;
                        logoImage = pickedLogo;
                        final logoName = pickedLogo.path.split('/').last;
                        logoImageController.text = logoName;
                      }
                    },
                    icon: const Icon(Icons.image, color: Colours.primaryColour),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      final now = DateTime.now();
                      final fields = availableFieldsControllers
                          .map((controller) => controller.text.trim())
                          .toList();
                      final scholarship = ScholarshipModel.empty().copyWith(
                        name: nameController.text.trim(),
                        description: descriptionController.text.trim(),
                        amount: double.tryParse(amountController.text.trim()),
                        numberOfRecipients: int.tryParse(
                                numberOfRecipientsController.text.trim()) ??
                            0,
                        applicationDeadline: DateTime.tryParse(
                                applicationDeadlineController.text.trim()) ??
                            now,
                        country: countryController.text.trim(),
                        createdAt: now,
                        updatedAt: now,
                        logoImage: logoImageController.text.trim().isEmpty
                            ? kDefaultImage
                            : isFileLogoImage
                                ? logoImage!.path
                                : logoImageController.text.trim(),
                        image: imageController.text.trim().isEmpty
                            ? kDefaultImage
                            : isFileImage
                                ? image!.path
                                : imageController.text.trim(),
                        availableFields: fields,
                        imageIsFile: isFileImage,
                        category: categoryController.text.trim(),
                        videoUrl: videoUrlController.text.trim(),
                      );

                      context
                          .read<ScholarshipCubit>()
                          .addScholarship(scholarship);
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
