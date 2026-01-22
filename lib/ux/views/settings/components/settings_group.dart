import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:flutter/material.dart';

class SettingsGroup extends StatelessWidget {
  const SettingsGroup(
      {super.key, required this.settingTiles, this.backgroundColor});

  final List<Widget> settingTiles;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ??
              ((Theme.of(context).brightness == Brightness.dark)
                  ? AppColors.transparentBackgroundDark
                  : AppColors.primaryColor.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(children: settingTiles),
      ),
    );
  }
}
