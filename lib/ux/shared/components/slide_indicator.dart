import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:flutter/material.dart';

class SlideIndicator extends StatelessWidget {
  const SlideIndicator(
      {super.key, required this.selectedIndex, required this.slideList});

  final int selectedIndex;
  final List slideList;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: slideList.asMap().entries.map((entry) {
          return Container(
            width: selectedIndex == entry.key ? 36 : 7,
            height: 7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: selectedIndex == entry.key
                  ? AppColors.primaryColor
                  : AppColors.dark2,
            ),
          );
        }).toList(),
      ),
    );
  }
}
