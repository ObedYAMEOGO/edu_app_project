import 'package:edu_app_project/core/common/features/category/domain/entities/category.dart';
import 'package:edu_app_project/core/common/widgets/category_tile.dart';
import 'package:edu_app_project/core/common/widgets/gradient_background.dart';
import 'package:edu_app_project/core/common/widgets/nested_back_button.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:flutter/material.dart';

class AllCoursesCategoriesView extends StatelessWidget {
  const AllCoursesCategoriesView(this.categories, {super.key});

  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          'Toutes les catégories',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colours.primaryColour),
        ),
        leading: const NestedBackButton(),
      ),
      body: GradientBackground(
        image: '',
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 20),
              ),
              const SizedBox(height: 30),
              Center(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 40,
                  runAlignment: WrapAlignment.spaceEvenly,
                  /*children: kSubjects.map((subject) {
                    final (name, icon, colour) = subject;
                    return SubjectTile(name: name, icon: icon, colour: colour);
                  }).toList(),*/
                  children: categories.map((category) {
                    return CategoryTile(
                      category: category,
                      onTap: () {},

                      // onTap: () => Navigator.of(context).pushNamed(
                      //   CourseDetailsView.id,
                      //   arguments: Category,
                      // ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
