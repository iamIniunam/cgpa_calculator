import 'dart:ui';

import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:flutter/material.dart';

class BottomDarkGradient extends StatelessWidget {
  const BottomDarkGradient({super.key, this.height});

  final double? height;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SizedBox(
        height: height ?? 50,
        child: Stack(
          children: [
            // Blur layer
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: AppColors.transparent,
                ),
              ),
            ),

            // Fade overlay at the TOP only
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              height: 300, // controls fade strength
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context)
                            .scaffoldBackgroundColor, // blends into bg
                        Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
