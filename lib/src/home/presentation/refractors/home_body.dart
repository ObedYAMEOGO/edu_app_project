import 'package:edu_app_project/core/common/app/providers/course_of_the_day_notifier.dart';
import 'package:edu_app_project/core/common/features/category/presentation/cubit/category_cubit.dart';
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
  @override
  void initState() {
    final courseCubit = context.read<CourseCubit>();
    final categoryCubit = context.read<CategoryCubit>();

    if (courseCubit.state is! CoursesLoaded) courseCubit.getCourses();
    if (categoryCubit.state is! CategoriesLoaded) categoryCubit.getCategories();

    super.initState();
  }

  Widget _buildContent(CourseState courseState, CategoryState categoryState) {
    if (courseState is LoadingCourses || categoryState is LoadingCategories) {
      return const LoadingView();
    } else if ((courseState is CourseError ||
            courseState is CoursesLoaded && courseState.courses.isEmpty) ||
        (categoryState is CategoryError ||
            categoryState is CategoriesLoaded &&
                categoryState.categories.isEmpty)) {
      return NotFoundText(
          'Pas de cours disponible \n Veuillez réessayer plus tard.');
    } else if (courseState is CoursesLoaded &&
        categoryState is CategoriesLoaded) {
      final courses = courseState.courses
        ..sort((a, b) => (b.updatedAt).compareTo(a.updatedAt));
      final categories = categoryState.categories
        ..sort((a, b) => (a.categoryTitle).compareTo(b.categoryTitle));

      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          HomeHeader(),
          const SizedBox(height: 20),
          HomeSubjects(courses: courses, categories: categories),
          const SizedBox(height: 20),
          HomeVideos(),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CourseCubit, CourseState>(
      listener: (_, courseState) {
        if (courseState is CourseError) {
          Utils.showSnackBar(
            context,
            "Une erreur s'est produite",
            ContentType.failure,
            title: 'Oups!',
          );
        } else if (courseState is CoursesLoaded &&
            courseState.courses.isNotEmpty) {
          final courses = courseState.courses..shuffle();
          final courseOfTheDay = courses.first;
          context
              .read<CourseOfTheDayNotifier>()
              .setCourseOfTheDay(courseOfTheDay);
        }
      },
      builder: (context, courseState) {
        return BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, categoryState) {
            return _buildContent(courseState, categoryState);
          },
        );
      },
    );
  }
}
