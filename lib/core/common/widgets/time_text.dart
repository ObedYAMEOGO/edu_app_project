import 'dart:async';

import 'package:edu_app_project/core/extensions/date_time_extensions.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:flutter/material.dart';

class TimeText extends StatefulWidget {
  const TimeText(
    this.time, {
    super.key,
    this.prefixText,
    this.style,
    this.maxLines,
    this.overflow,
  });

  final DateTime time;
  final String? prefixText;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  State<TimeText> createState() => _TimeTextState();
}

class _TimeTextState extends State<TimeText> {
  Timer? timer;
  late String timeAgo;

  @override
  void initState() {
    super.initState();
    timeAgo = widget.time.timeAgo;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        if (timeAgo != widget.time.timeAgo) {
          setState(() {
            timeAgo = widget.time.timeAgo;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Text(
        '${widget.prefixText != null ? '${widget.prefixText}' : ''}$timeAgo',
        maxLines: widget.maxLines,
        overflow: widget.overflow,
        textAlign: TextAlign.right,
        style: widget.style ??
            const TextStyle(
              fontSize: 10,
              fontFamily: Fonts.inter,
              color: Colours.pinkColour,
            ),
      ),
    );
  }
}
