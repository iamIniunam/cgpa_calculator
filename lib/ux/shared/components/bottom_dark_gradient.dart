import 'dart:ui';

import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:flutter/material.dart';

class BottomDarkGradient extends StatelessWidget {
  const BottomDarkGradient({super.key, this.height});

  final double? height;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: height ?? 100,
            decoration: BoxDecoration(
              gradient: AppGradients.bottomBackground,
            ),
          ),
        ),
      ),
    );
  }
}
