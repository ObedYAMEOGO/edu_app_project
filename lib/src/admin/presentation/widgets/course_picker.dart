import 'package:edu_app_project/core/common/features/course/domain/entities/course.dart';
import 'package:edu_app_project/core/common/features/course/presentation/cubit/course_cubit.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoursePicker extends StatefulWidget {
  const CoursePicker(
      {super.key, required this.controller, required this.notifier});
  final TextEditingController controller;
  final ValueNotifier<Course?> notifier;

  @override
  State<CoursePicker> createState() => _CoursePickerState();
}

class _CoursePickerState extends State<CoursePicker> {
  void getCourses() {
    context.read<CourseCubit>().getCourses();
  }

  @override
  void initState() {
    super.initState();
    getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CourseCubit, CourseState>(
      listener: (context, state) {
        if (state is CourseError) {
          Utils.showSnackBar(
              context,
              "Une erreur s\'est produite. Verifiez vos informations et réessayer !",
              ContentType.failure,
              title: "Oups !");
          Navigator.pop(context);
        } else if (state is CoursesLoaded && state.courses.isEmpty) {
          Utils.showSnackBar(
              context,
              'Aucun cours disponible \nVeuillez ajouter un cours',
              ContentType.warning,
              title: 'Humm');
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return TextFormField(
            controller: widget.controller,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Choisir Cours',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colours.primaryColour,
                ),
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colours.primaryColour,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              suffixIcon: state is CoursesLoaded
                  ? PopupMenuButton<String>(
                      offset: Offset(0, 50),
                      surfaceTintColor: Colors.white,
                      icon: const Icon(Icons.arrow_drop_down_outlined),
                      itemBuilder: (context) {
                        return state.courses
                            .map(
                              (course) => PopupMenuItem<String>(
                                child: Text(course.title),
                                onTap: () {
                                  widget.controller.text = course.title;
                                  widget.notifier.value = course;
                                },
                              ),
                            )
                            .toList();
                      },
                    )
                  : const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('Entrain de charger...'),
                    ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez choisir un cours';
              }
              return null;
            });
      },
    );
  }
}
