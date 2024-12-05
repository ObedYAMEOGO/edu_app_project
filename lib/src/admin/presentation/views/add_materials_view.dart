import 'package:edu_app_project/core/common/features/course/domain/entities/course.dart';
import 'package:edu_app_project/core/common/features/materials/data/models/material_model.dart';
import 'package:edu_app_project/core/common/features/materials/domain/entities/material.dart';
import 'package:edu_app_project/core/common/features/materials/presentation/app/cubit/material_cubit.dart';
import 'package:edu_app_project/src/admin/presentation/models/resource.dart';
import 'package:edu_app_project/src/admin/presentation/widgets/edit_resource_dialog.dart';
import 'package:edu_app_project/src/admin/presentation/widgets/picked_resource_tile.dart';
import 'package:edu_app_project/src/admin/presentation/widgets/course_picker.dart';
import 'package:edu_app_project/src/admin/presentation/widgets/info_field.dart';
import 'package:edu_app_project/core/enums/notification_enum.dart';
import 'package:edu_app_project/core/extensions/context_extension.dart';
import 'package:edu_app_project/core/extensions/int_extensions.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/utils/core_utils.dart';
import 'package:edu_app_project/src/notifications/presentation/widgets/notification_wrapper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart ' hide MaterialState, Material;
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddMaterialsView extends StatefulWidget {
  const AddMaterialsView({super.key});

  static const routeName = '/add-material';

  @override
  State<AddMaterialsView> createState() => _AddMaterialsViewState();
}

class _AddMaterialsViewState extends State<AddMaterialsView> {
  List<Resource> resources = [];

  final formKey = GlobalKey<FormState>();
  final courseController = TextEditingController();
  final courseNotifier = ValueNotifier<Course?>(null);
  final authorController = TextEditingController();

  bool authorSet = false;

  Future<void> pickResources() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        resources.addAll(
          result.paths.map(
            (path) => Resource(
              path: path!,
              author: authorController.text.trim(),
              title: path.split('/').last,
            ),
          ),
        );
      });
    }
  }

  Future<void> editResource(int resourceIndex) async {
    final resource = resources[resourceIndex];
    final newResource = await showDialog<Resource>(
      context: context,
      builder: (_) => EditResourceDialog(resource),
    );
    if (newResource != null) {
      setState(() {
        resources[resourceIndex] = newResource;
      });
    }
  }

  void uploadMaterials() {
    if (!authorSet && authorController.text.trim().isNotEmpty) {
      Utils.showSnackBar(context, 'Cliquer l\'icône pour confirmer l\'auteur ',
          ContentType.failure,
          title: 'Oups!');
      return;
    }
    final date = DateTime.now();
    final materials = <Material>[];
    for (final resource in resources) {
      materials.add(
        MaterialModel.empty().copyWith(
          courseId: courseNotifier.value!.id,
          uploadDate: date,
          fileURL: resource.path,
          title: resource.title,
          description: resource.description,
          author: resource.author,
          fileExtension: resource.path.split('.').last,
        ),
      );
    }
    context.read<MaterialCubit>().addMaterials(materials);
  }

  bool showingLoader = false;
  void setAuthor() {
    if (authorSet) return;
    final text = authorController.text.trim();
    FocusManager.instance.primaryFocus?.unfocus();
    // it's generally not a good idea to add or remove items from a list while
    // iterating over it, so we'll just copy the list and replace the items
    // with the new author
    final newResources = <Resource>[];
    for (var i = 0; i < resources.length; i++) {
      final resource = resources[i];
      if (resource.authorManuallySet) {
        newResources.add(resource);
        continue;
      }
      newResources.add(resource.copyWith(author: text));
    }
    setState(() {
      resources = newResources;
      authorSet = true;
    });
  }

  @override
  void dispose() {
    courseController.dispose();
    courseNotifier.dispose();
    authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationWrapper(
      onNotificationSent: () {
        Navigator.pop(context);
      },
      child: BlocListener<MaterialCubit, MaterialState>(
        listener: (context, state) {
          if (showingLoader) {
            Navigator.pop(context);
            showingLoader = false;
          }
          if (state is MaterialError) {
            Utils.showSnackBar(
                context,
                "Une erreur s\'est produite. Verifiez vos informations et réessayer !",
                ContentType.failure,
                title: "Oups !");
          } else if (state is MaterialsAdded) {
            Utils.showSnackBar(
                context, 'Documents ajoutés avec succès', ContentType.success,
                title: 'Parfait!');
            Utils.sendNotification(
              context,
              title: '${courseNotifier.value!.title} '
                  '${resources.length.pluralize}',
              body: 'De nouveaux documents'
                  'viennent d\'être ajouté ${courseNotifier.value!.title}',
              category: NotificationCategory.MATERIAL,
            );
          } else if (state is AddingMaterials) {
            Utils.showLoadingDialog(context);
            showingLoader = true;
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              titleSpacing: 0,
              title: const Text(
                'Nouveaux Documents',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
                    InfoField(
                      controller: authorController,
                      border: true,
                      hintText: 'Auteur',
                      onChanged: (_) {
                        if (authorSet) setState(() => authorSet = false);
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          authorSet
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                          color: authorSet ? Colors.green : Colors.grey,
                        ),
                        onPressed: setAuthor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Vous pouvez téléchager plusieurs documents à la fois.',
                      style: context.theme.textTheme.bodySmall?.copyWith(
                        color: Colours.neutralTextColour,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (resources.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: resources.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (_, index) {
                            final resource = resources[index];
                            return PickedResourceTile(
                              resource,
                              onEdit: () => editResource(index),
                              onDelete: () {
                                setState(() {
                                  resources.removeAt(index);
                                });
                              },
                            );
                          },
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
                            onPressed: pickResources,
                            child: const Text(
                              'Ajouter des documents',
                              style: TextStyle(color: Colours.secondaryColour),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: uploadMaterials,
                            child: const Text(
                              'confirmer',
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
