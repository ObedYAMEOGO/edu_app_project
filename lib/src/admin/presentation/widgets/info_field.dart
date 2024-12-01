import 'package:edu_app_project/core/res/colours.dart';
import 'package:flutter/material.dart';

class InfoField extends StatelessWidget {
  const InfoField({
    required this.controller,
    super.key,
    this.onEditingComplete,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.autoFocus = false,
    this.labelText,
    this.focusNode,
    this.onTapOutside,
    this.onChanged,
    this.border = false,
    this.suffixIcon,
    this.hintStyle,
    this.enabledBorder,
  });

  final TextEditingController controller;
  final VoidCallback? onEditingComplete;
  final String? hintText;
  final TextInputType keyboardType;
  final bool autoFocus;
  final String? labelText;
  final FocusNode? focusNode;
  final TextStyle? hintStyle;
  final OutlineInputBorder? enabledBorder;
  final ValueChanged<PointerDownEvent>? onTapOutside;
  final ValueChanged<String?>? onChanged;
  final bool border;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    const defaultBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colours.primaryColour),
    );

    const focusedBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colours.secondaryColour, width: 0.2),
    );

    return ListenableBuilder(
      listenable: controller,
      builder: (_, __) {
        return TextField(
          cursorColor: Colours.secondaryColour,
          style: const TextStyle(fontSize: 12),
          controller: controller,
          autofocus: autoFocus,
          focusNode: focusNode,
          keyboardType: keyboardType,
          onEditingComplete: onEditingComplete,
          onTapOutside: onTapOutside ??
              (_) => FocusManager.instance.primaryFocus?.unfocus(),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: hintStyle,
            labelText: labelText,
            border: border ? defaultBorder : null,
            enabledBorder: enabledBorder,
            focusedBorder:
                focusedBorder, // This line sets the focused border color to black
            contentPadding:
                border ? const EdgeInsets.symmetric(horizontal: 10) : null,
            suffixIcon: suffixIcon ??
                (controller.text.trim().isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: Colours.redColour,
                        ),
                        onPressed: controller.clear,
                      )),
          ),
        );
      },
    );
  }
}
