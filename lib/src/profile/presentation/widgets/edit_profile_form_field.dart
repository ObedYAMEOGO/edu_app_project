import 'package:edu_app_project/core/common/widgets/i_fields.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:flutter/material.dart';

class EditProfileFormField extends StatelessWidget {
  const EditProfileFormField({
    required this.controller,
    required this.hintText,
    required this.fieldTitle,
    this.readOnly = false,
    super.key,
    this.prefixIcon,
  });

  final TextEditingController controller;
  final String? hintText;
  final String fieldTitle;
  final bool readOnly;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color: Colours.darkColour,
      fontFamily: Fonts.merriweather,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(fieldTitle, style: titleStyle),
        ),
        const SizedBox(height: 10),
        IField(
          controller: controller,
          hintText: hintText,
          readOnly: readOnly,
          prefixIcon: prefixIcon,
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
