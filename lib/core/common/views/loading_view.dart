import 'package:edu_app_project/core/common/views/custom_circular_progress_bar.dart';
import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Material(
      type: MaterialType.transparency,
      child: Center(
        child: CustomCircularProgressBarIndicator(),
      ),
    );
  }
}
