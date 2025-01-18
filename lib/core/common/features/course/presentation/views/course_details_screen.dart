import 'package:edu_app_project/core/common/features/course/domain/entities/course.dart';
import 'package:edu_app_project/core/common/features/materials/presentation/views/course_materials_view.dart';
import 'package:edu_app_project/core/common/features/videos/presentation/views/course_videos_view.dart';
import 'package:edu_app_project/core/common/widgets/course_info_tile.dart';
import 'package:edu_app_project/core/common/widgets/expandable_text.dart';
import 'package:edu_app_project/core/common/widgets/nested_back_button.dart';
import 'package:edu_app_project/core/extensions/context_extension.dart';
import 'package:edu_app_project/core/extensions/int_extensions.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/core/res/media_res.dart';
import 'package:edu_app_project/src/exams/presentation/views/course_exams_view.dart';
import 'package:flutter/material.dart';

class CourseDetailsScreen extends StatelessWidget
    implements PreferredSizeWidget {
  const CourseDetailsScreen(this.course, {super.key});
  final Course course;

  static const routeName = "/course-details";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        leading: NestedBackButton(),
        title: Text(
          course.title.length > 17
              ? '${course.title.substring(0, 17)}...'
              : course.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            color: Colours.darkColour,
            fontFamily: Fonts.merriweather,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              // gradient: LinearGradient(
              //   colors: Colours.gradient
              //       .map((color) => color.withOpacity(0.5))
              //       .toList(),
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              // ),
              ),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SizedBox(
              height: context.height * .3,
              child: course.image != null
                  ? Image.network(course.image!)
                  : Image.asset(Res.digitalbook),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: Fonts.merriweather,
                      color: Colours.darkColour),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (course.description != null)
                  ExpandableText(text: course.description!, context),
                if (course.numberOfMaterials > 0 ||
                    course.numberOfVideos > 0 ||
                    course.numberOfExams > 0) ...[
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Details de ce cours",
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: Fonts.merriweather,
                        fontWeight: FontWeight.w600,
                        color: Colours.darkColour),
                  ),
                  if (course.numberOfVideos > 0) ...[
                    const SizedBox(
                      height: 10,
                    ),
                    CourseInfoTile(
                      image: Res.courseInfoVideo,
                      title: '${course.numberOfVideos} Video (s)',
                      subtitle: 'Suivre nos tutoriels de '
                          '${course.title}',
                      onTap: () => Navigator.of(context).pushNamed(
                          CourseVideosView.routeName,
                          arguments: course),
                    )
                  ],
                  if (course.numberOfExams > 0) ...[
                    const SizedBox(height: 10),
                    CourseInfoTile(
                      image: Res.courseInfoExam,
                      title: '${course.numberOfExams} Quiz disponible (s)',
                      subtitle: 'Passer le quiz de ${course.title}',
                      onTap: () => Navigator.of(context).pushNamed(
                        CourseExamsView.routeName,
                        arguments: course,
                      ),
                    ),
                  ],
                  if (course.numberOfMaterials > 0) ...[
                    const SizedBox(
                      height: 10,
                    ),
                    CourseInfoTile(
                      image: Res.courseInfoMaterial,
                      title:
                          '${course.numberOfMaterials.estimate} Documents (s)',
                      subtitle: 'Accédez à des supports PDFs de '
                          '${course.title}',
                      onTap: () => Navigator.of(context).pushNamed(
                          CourseMaterialsView.routeName,
                          arguments: course),
                    )
                  ]
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
