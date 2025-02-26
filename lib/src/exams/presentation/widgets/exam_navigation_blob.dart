import 'dart:math';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/src/exams/presentation/app/providers/exam_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const Color primaryBlue = Colours.primaryColour;
const Color backgroundColor = Colors.white;
const Color disabledColor = Color(0xFFCCCCCC);
const Color lightGreyShadow = Color(0xFFE0E0E0);

class ExamNavigationBlob extends StatelessWidget {
  const ExamNavigationBlob({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExamController>(
      builder: (_, controller, __) {
        final progress =
            controller.currentIndex / (controller.totalQuestions - 1);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: controller.currentIndex > 0
                  ? controller.previousQuestion
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    controller.currentIndex > 0 ? primaryBlue : disabledColor,
                iconColor: controller.currentIndex > 0
                    ? Colors.white
                    : disabledColor.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Icon(Icons.arrow_back, size: 24),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    painter: ProgressPainter(progress: progress),
                    size: const Size(40, 40),
                  ),
                  Text(
                    '${controller.currentIndex + 1}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: Fonts.inter,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: controller.currentIndex < controller.totalQuestions - 1
                  ? controller.nextQuestion
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    controller.currentIndex < controller.totalQuestions - 1
                        ? primaryBlue
                        : disabledColor,
                iconColor:
                    controller.currentIndex < controller.totalQuestions - 1
                        ? Colors.white
                        : disabledColor.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Icon(Icons.arrow_forward, size: 24),
            ),
          ],
        );
      },
    );
  }
}

class ProgressPainter extends CustomPainter {
  final double progress;

  ProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryBlue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 4;

    canvas.drawCircle(center, radius, paint);

    final progressPaint = Paint()
      ..color = primaryBlue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressSweep = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      progressSweep,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
