import 'package:edu_app_project/core/common/widgets/time_text.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:flutter/material.dart';

class TimeTile extends StatelessWidget {
  const TimeTile(this.time, {super.key, this.prefixText});

  final DateTime time;
  final String? prefixText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colours.primaryColour,
            Colours.primaryColour,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: TimeText(
              time,
              prefixText: prefixText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: Offset(0, 2),
                    blurRadius: 3,
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
