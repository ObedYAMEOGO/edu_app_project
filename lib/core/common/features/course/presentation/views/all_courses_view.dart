import 'package:flutter/material.dart';
import 'package:edu_app_project/core/common/features/course/domain/entities/course.dart';
import 'package:edu_app_project/core/common/features/category/domain/entities/category.dart';
import 'package:edu_app_project/core/common/features/course/presentation/views/course_details_screen.dart';
import 'package:edu_app_project/core/common/widgets/course_tile.dart';
import 'package:edu_app_project/core/common/widgets/nested_back_button.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';

class AllCoursesView extends StatefulWidget {
  const AllCoursesView(
    this.courses,
    this.categories, {
    super.key,
  });

  final List<Course> courses;
  final List<Category> categories;

  @override
  _AllCoursesViewState createState() => _AllCoursesViewState();
}

class _AllCoursesViewState extends State<AllCoursesView> {
  late List<Course> filteredCourses;
  final TextEditingController searchController = TextEditingController();
  String? selectedCategoryId;

  // Add this key to your Scaffold
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
            (course) =>
                course.title.toLowerCase().contains(lowerCaseQuery) &&
                (selectedCategoryId == null ||
                    course.courseCategoryId == selectedCategoryId),
          )
          .toList();
    });
  }

  void _filterByCategory(String? categoryId) {
    setState(() {
      selectedCategoryId = categoryId;
      _filterCourses(searchController.text);
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
      key: scaffoldKey, // Assign the scaffold key here
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        titleSpacing: 0,
        leading: const NestedBackButton(),
        title: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE4E6EA),
              borderRadius: BorderRadius.circular(0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: searchController,
              onChanged: _filterCourses,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Recherche...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
              textAlignVertical: TextAlignVertical.center,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search_outlined,
              color: Colours.darkColour,
            ),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide.none),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Filtrer par Catégorie',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  'Tous',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colours.darkColour,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _filterByCategory(null);
                },
                selected: selectedCategoryId == null,
              ),
              ...widget.categories.map((category) {
                return ListTile(
                  title: Text(
                    category.categoryTitle,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colours.darkColour,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _filterByCategory(category.categoryId);
                  },
                  selected: selectedCategoryId == category.categoryId,
                );
              }).toList(),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tous les cours',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: Fonts.merriweather,
                      fontSize: 15,
                      color: Colours.darkColour,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Filtrer',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontFamily: Fonts.merriweather,
                          fontSize: 15,
                          color: Colours.darkColour,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.filter_list,
                          color: Colours.darkColour,
                        ),
                        onPressed: () {
                          scaffoldKey.currentState
                              ?.openEndDrawer(); // Open the drawer
                        },
                      ),
                    ],
                  ),
                ],
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
