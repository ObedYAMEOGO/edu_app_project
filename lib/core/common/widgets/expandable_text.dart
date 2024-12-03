import 'package:edu_app_project/core/extensions/context_extension.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText(
    this.context, {
    required this.text,
    super.key,
    this.style,
  });

  final BuildContext context;
  final String text;
  final TextStyle? style;

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool expanded = false;
  late TextSpan textSpan;
  late TextPainter textPainter;

  @override
  void initState() {
    textSpan = TextSpan(text: widget.text);

    textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: expanded ? null : 2,
    )..layout(maxWidth: widget.context.width * .9);
    super.initState();
  }

  @override
  void dispose() {
    textPainter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const defaultStyle = TextStyle(
        color: Colours.secondaryColour,
        height: 1.9,
        fontSize: 12,
        fontFamily: Fonts.montserrat);
    return Container(
      child: textPainter.didExceedMaxLines
          ? RichText(
              text: TextSpan(
                text: expanded
                    ? widget.text
                    : '${widget.text.substring(
                        0,
                        textPainter
                            .getPositionForOffset(
                              Offset(
                                widget.context.width,
                                widget.context.height,
                              ),
                            )
                            .offset,
                      )}...',
                style: widget.style ?? defaultStyle,
                children: [
                  TextSpan(
                    text: expanded ? ' Voir moins' : 'Voir plus',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        setState(() {
                          expanded = !expanded;
                        });
                      },
                    style:  TextStyle(
                      color: Colours.successColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : Text(
              widget.text,
              style: widget.style ?? defaultStyle,
            ),
    );
  }
}
