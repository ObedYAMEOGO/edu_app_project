import 'package:edu_app_project/core/extensions/context_extension.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:flutter/material.dart';

class NotFoundText extends StatelessWidget {
  const NotFoundText(this.text, {super.key});

  final String text;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: context.theme.textTheme.headlineMedium?.copyWith(
            fontFamily: Fonts.montserrat,
            fontWeight: FontWeight.w400,
            fontSize: 17,
            color: Colors.grey.withOpacity(.5)),
      ),
    );
  }
}
