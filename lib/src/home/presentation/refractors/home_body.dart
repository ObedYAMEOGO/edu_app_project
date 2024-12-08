import 'package:edu_app_project/core/common/app/providers/course_of_the_day_notifier.dart';
import 'package:edu_app_project/core/common/features/course/presentation/cubit/course_cubit.dart';
import 'package:edu_app_project/core/common/views/loading_view.dart';
import 'package:edu_app_project/core/common/widgets/not_found_text.dart';
import 'package:edu_app_project/core/utils/core_utils.dart';
import 'package:edu_app_project/src/home/presentation/refractors/home_header.dart';
import 'package:edu_app_project/src/home/presentation/refractors/home_subjects.dart';
import 'package:edu_app_project/src/home/presentation/refractors/home_videos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  void getCourses() {
    context.read<CourseCubit>().getCourses();
  }

  @override
  void initState() {
    getCourses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CourseCubit, CourseState>(
      listener: (_, state) {
        if (state is CourseError) {
          Utils.showSnackBar(
              context, "Une erreur s\'est produite", ContentType.failure,
              title: 'Oups!');
        } else if (state is CoursesLoaded && state.courses.isNotEmpty) {
          final courses = state.courses..shuffle();
          final courseOfTheDay = courses.first;
          context
              .read<CourseOfTheDayNotifier>()
              .setCourseOfTheDay(courseOfTheDay);
        }
      },
      builder: (context, state) {
        if (state is LoadingCourses) {
          return const LoadingView();
        } else if (state is CoursesLoaded && state.courses.isEmpty ||
            state is CourseError) {
          return NotFoundText(
              'Aucun cours disponible \n Veuillez contacter l\'administrateur.');
        } else if (state is CoursesLoaded) {
          final courses = state.courses
            ..sort(
              (a, b) => b.updatedAt.compareTo(a.updatedAt),
            );
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              HomeHeader(),
              const SizedBox(
                height: 20,
              ),
              HomeSubjects(courses: courses),
              const SizedBox(
                height: 20,
              ),
              HomeVideos(),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
