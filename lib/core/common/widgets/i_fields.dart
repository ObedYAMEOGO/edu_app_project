import 'package:edu_app_project/core/res/fonts.dart';
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
      cursorColor: Colors.black,
      controller: controller,
      onTapOutside: (_) {
        FocusScope.of(context).unfocus();
      },
      keyboardType: keyboardType,
      obscureText: obscureText,
      readOnly: readOnly,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade600, width: 0.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        filled: filled,
        fillColor: fillColour ?? Colors.grey.shade100,

        // 🔹 Correction de l'icône préfixe pour qu'elle ne masque pas la bordure
        prefixIcon: prefixIcon,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 40, // Taille minimale pour éviter le débordement
          minHeight: 40,
        ),

        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: hintStyle ??
            TextStyle(
              fontSize: 14,
              fontFamily: Fonts.inter,
              fontWeight: FontWeight.w400,
              height: 1.2,
              color: Colors.grey.shade600,
            ),
      ),
      style: const TextStyle(
        fontSize: 14,
        fontFamily: Fonts.inter,
        height: 1.2,
      ),
    );
  }
}
