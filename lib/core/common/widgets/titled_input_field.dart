import 'package:edu_app_project/core/common/widgets/i_fields.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:flutter/material.dart';

class TitledInputField extends StatelessWidget {
  const TitledInputField({
    required this.controller,
    required this.title,
    this.required = true,
    this.hintText,
    this.hintStyle,
    this.suffixIcon,
    super.key,
  });

  final bool required;
  final TextEditingController controller;
  final String title;
  final String? hintText;
  final TextStyle? hintStyle;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                text: title,
                style: const TextStyle(
                  fontFamily: Fonts.montserrat,
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                  color: Colours.neutralTextColour,
                ),
                children: [
                  TextSpan(
                    text: required ? ' *' : '',
                    style: const TextStyle(color: Colours.redColour),
                  ),
                ],
              ),
            ),
            if (suffixIcon != null) suffixIcon!,
          ],
        ),
        const SizedBox(height: 10),
        IField(
          controller: controller,
          hintText: hintText ?? 'Entrer $title',
          hintStyle: hintStyle,
          overrideValidator: true,
          validator: (value) {
            if (!required) return null;
            if (value == null || value.isEmpty) {
              return 'Ce champ est obligatore';
            }
            return null;
          },
        ),
      ],
    );
  }
}
