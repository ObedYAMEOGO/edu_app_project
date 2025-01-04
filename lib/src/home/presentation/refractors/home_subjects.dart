import 'package:edu_app_project/core/common/features/category/domain/entities/category.dart';
import 'package:edu_app_project/core/common/features/category/presentation/views/all_courses_categories_view.dart';
import 'package:edu_app_project/core/common/features/course/domain/entities/course.dart';
import 'package:edu_app_project/core/common/features/course/presentation/views/all_courses_view.dart';
import 'package:edu_app_project/core/common/features/course/presentation/views/course_details_screen.dart';
import 'package:edu_app_project/core/common/widgets/course_tile.dart';
import 'package:edu_app_project/core/extensions/context_extension.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/src/home/presentation/widgets/section_header.dart';
import 'package:flutter/material.dart';

class HomeSubjects extends StatelessWidget {
  const HomeSubjects({super.key, required this.courses, this.categories});
  final List<Course> courses;
  final List<Category>? categories;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
            sectionTitle: 'Cours',
            seeAll: courses.length >= 4,
            onSeeAll: () =>
                context.push(AllCoursesCategoriesView(categories!))),
        const Text(
          'Explorer nos cours',
          style: TextStyle(
            fontSize: 12,
            color: Colours.secondaryColour,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          /*children: kSubjects.sublist(0, 4).map((subject) {
            final (name, icon, colour) = subject;
            return SubjectTile(name: name, icon: icon, colour: colour);
          }).toList(),*/
          children: courses
              .take(4)
              .map((course) => CourseTile(
                    course: course,
                    onTap: () => Navigator.of(context).pushNamed(
                        CourseDetailsScreen.routeName,
                        arguments: course),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
