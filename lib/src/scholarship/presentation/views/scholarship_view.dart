import 'package:edu_app_project/src/scholarship/presentation/refractors/scholarship_app_bar.dart';
import 'package:edu_app_project/src/scholarship/presentation/refractors/scholarship_body.dart';
import 'package:flutter/material.dart';

class ScholarshipView extends StatelessWidget {
  const ScholarshipView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      appBar: ScholarshipViewAppBar(),
      body: ScholarshipViewBody(),
    );
  }
}
