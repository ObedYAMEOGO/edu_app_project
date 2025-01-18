import 'package:edu_app_project/core/common/features/course/domain/entities/course.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:flutter/material.dart';

class CourseTile extends StatelessWidget {
  const CourseTile({required this.course, super.key, this.onTap});

  final Course course;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 54,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFE4E6EA),
                borderRadius: BorderRadius.circular(3),
              ),
              height: 54,
              width: 54,
              child: Center(
                child: Image.network(
                  course.image!,
                  height: 32,
                  width: 32,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              course.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: Fonts.merriweather,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
