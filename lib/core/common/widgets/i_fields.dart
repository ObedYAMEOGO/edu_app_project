import 'package:edu_app_project/core/res/colours.dart';
import 'package:flutter/material.dart';

class IField extends StatelessWidget {
  const IField({
    required this.controller,
    this.filled = false,
    this.obscureText = false,
    this.readOnly = false,
    super.key,
    this.validator,
    this.fillColour,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.keyboardType,
    this.hintStyle,
    this.overrideValidator = false,
  });

  final String? Function(String?)? validator;
  final TextEditingController controller;
  final bool filled;
  final Color? fillColour;
  final bool obscureText;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool overrideValidator;
  final TextStyle? hintStyle;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      // validator: overrideValidator
      //     ? validator
      //     : (value) {
      //         if (value == null || value.isEmpty) {
      //           return 'Veuillez remplir tous les champs';
      //         }
      //         return validator?.call(value);
      //       },
      onTapOutside: (_) {
        FocusScope.of(context).unfocus();
      },
      keyboardType: keyboardType,
      obscureText: obscureText,
      readOnly: readOnly,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFE4E6EA),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colours.primaryColour.withOpacity(0.3),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
        filled: filled,
        fillColor: fillColour,
        prefixIcon: prefixIcon != null
            ? Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colours.primaryColour.withOpacity(0.3),
                  ),
                  color: Colors.white, // Background primary color
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.only(right: 8),
                child: IconTheme(
                  data: const IconThemeData(
                    color: Colours.primaryColour, // Icon color
                  ),
                  child: prefixIcon!,
                ),
              )
            : null,
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: hintStyle ??
            const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 1.2, // Line height for hint text
              color: Color(0xFF757575),
            ),
      ),
      style: const TextStyle(
        fontSize: 12,
        height: 1.2, // Line height for input text
      ),
    );
  }
}
