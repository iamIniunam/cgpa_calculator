import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StatusDot extends StatelessWidget {
  const StatusDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.primaryColorLight
              : AppColors.primaryColor,
          shape: BoxShape.circle,
        ),
      )
          .animate(
            onPlay: (controller) => controller.repeat(reverse: true),
          )
          .fade(begin: 0.3, end: 1.0, duration: 1000.ms),
    );
  }
}
