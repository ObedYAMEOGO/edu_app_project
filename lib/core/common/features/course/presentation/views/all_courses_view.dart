import 'package:edu_app_project/core/common/features/course/domain/entities/course.dart';
import 'package:edu_app_project/core/common/features/course/presentation/views/course_details_screen.dart';
import 'package:edu_app_project/core/common/widgets/course_tile.dart';
import 'package:edu_app_project/core/common/widgets/nested_back_button.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:flutter/material.dart';

class AllCoursesView extends StatefulWidget {
  const AllCoursesView(
    this.courses, {
    super.key,
  });
  final List<Course> courses;

  @override
  _AllCoursesViewState createState() => _AllCoursesViewState();
}

class _AllCoursesViewState extends State<AllCoursesView> {
  late List<Course> filteredCourses;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredCourses = widget.courses;
  }

  void _filterCourses(String query) {
    final lowerCaseQuery = query.toLowerCase();
    setState(() {
      filteredCourses = widget.courses
          .where(
              (course) => course.title.toLowerCase().contains(lowerCaseQuery))
          .toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        titleSpacing: 0,
        leading: NestedBackButton(),
        title: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE4E6EA),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          height: 40,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE4E6EA),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: 40,
            child: TextField(
              controller: searchController,
              onChanged: _filterCourses,
              style: const TextStyle(color: Colours.primaryColour),
              decoration: InputDecoration(
                hintText: 'Recherche...',
                border: InputBorder.none, // Remove default border
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search_outlined,
              color: Colours.primaryColour,
            ),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Tous les cours',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colours.primaryColour),
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: Wrap(
                spacing: 20,
                runSpacing: 40,
                runAlignment: WrapAlignment.spaceEvenly,
                children: filteredCourses
                    .map(
                      (course) => CourseTile(
                        course: course,
                        onTap: () => Navigator.of(context).pushNamed(
                          CourseDetailsScreen.routeName,
                          arguments: course,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
