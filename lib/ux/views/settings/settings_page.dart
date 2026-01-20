import 'dart:io';

import 'package:cgpa_calculator/platform/di/dependency_injection.dart';
import 'package:cgpa_calculator/ux/shared/components/app_material.dart';
import 'package:cgpa_calculator/ux/shared/components/bottom_dark_gradient.dart';
import 'package:cgpa_calculator/ux/shared/extensions/extensions.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_images.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:cgpa_calculator/ux/view_models/theme_view_model.dart';
import 'package:cgpa_calculator/ux/views/settings/components/profile_card.dart';
import 'package:cgpa_calculator/ux/views/settings/components/settings_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final ThemeViewModel themeViewModel = AppDi.getIt<ThemeViewModel>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Image(
                  image: AppImages.appLogo3,
                  fit: BoxFit.cover,
                  height: 35,
                  width: 35,
                ),
                const SizedBox(width: 10),
                Text(AppStrings.appName,
                    style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            centerTitle: false,
            bottom: const Divider(height: 2).asPreferredSize(height: 1),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 74),
            children: [
              ProfileCard(context: context),
              SettingsGroup(
                settingTiles: [
                  ValueListenableBuilder<AppThemeMode>(
                    valueListenable: themeViewModel.themeMode,
                    builder: (context, mode, _) {
                      return settingTile(
                        title: 'Appearance',
                        icon: mode == AppThemeMode.light
                            ? Icons.wb_sunny_rounded
                            : Icons.nights_stay_rounded,
                        trailing: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.transparentBackgroundDark
                                    : AppColors.primaryColor.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              themeToggleWidget(
                                context: context,
                                theme: 'Light',
                                isActive: themeViewModel.isLightActive(context),
                              ),
                              themeToggleWidget(
                                context: context,
                                theme: 'Dark',
                                isActive: themeViewModel.isDarkActive(context),
                              ),
                            ],
                          ),
                        ),
                        dense: true,
                      );
                    },
                  ),
                  ValueListenableBuilder<AppThemeMode>(
                    valueListenable: themeViewModel.themeMode,
                    builder: (context, mode, _) {
                      return settingTile(
                        title: 'Use System Theme',
                        icon: Platform.isAndroid
                            ? Icons.phone_android_rounded
                            : Icons.phone_iphone_rounded,
                        trailing: CupertinoSwitch(
                          value: mode == AppThemeMode.system,
                          onChanged: mode == AppThemeMode.system
                              ? null
                              : (v) {
                                  if (v) {
                                    themeViewModel
                                        .setThemeMode(AppThemeMode.system);
                                  }
                                },
                          activeColor: AppColors.primaryColor,
                        ),
                        dense: true,
                      );
                    },
                  ),
                  settingTile(
                    title: 'Language',
                    icon: Icons.language_rounded,
                    trailing: Text(
                      'ENG',
                      style: TextStyle(
                        color: (Theme.of(context).appBarTheme.foregroundColor ??
                            AppColors.white),
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {},
                  ),
                  settingTile(
                    title: 'Go Premium',
                    icon: Icons.workspace_premium_outlined,
                    showDivider: false,
                    isLast: true,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
        const BottomDarkGradient(),
      ],
    );
  }

  Widget themeToggleWidget({
    required BuildContext context,
    required String theme,
    required bool isActive,
  }) {
    return AppMaterial(
      inkwellBorderRadius: BorderRadius.circular(20),
      onTap: () {
        themeViewModel.setThemeMode(
          theme == 'Light' ? AppThemeMode.light : AppThemeMode.dark,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryColor : AppColors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          theme,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }

  Widget settingTile({
    required String title,
    required IconData icon,
    Widget? trailing,
    VoidCallback? onTap,
    bool dense = false,
    bool showDivider = true,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final tile = Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: dense ? 10 : 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: showDivider
              ? BorderSide(
                  color: (Theme.of(context).appBarTheme.foregroundColor ??
                          AppColors.white)
                      .withOpacity(0.3),
                  width: 0,
                )
              : BorderSide.none,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon,
                  color: (Theme.of(context).appBarTheme.foregroundColor ??
                      AppColors.white),
                  size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                    color: (Theme.of(context).appBarTheme.foregroundColor ??
                        AppColors.white),
                    fontSize: 16),
              ),
            ],
          ),
          trailing ??
              (onTap != null
                  ? Icon(Icons.chevron_right_rounded,
                      color: (Theme.of(context).appBarTheme.foregroundColor ??
                          AppColors.white),
                      size: 24)
                  : const SizedBox.shrink()),
        ],
      ),
    );

    final borderRadius = (isFirst || isLast)
        ? BorderRadius.vertical(
            top: isFirst ? const Radius.circular(20) : Radius.zero,
            bottom: isLast ? const Radius.circular(20) : Radius.zero)
        : BorderRadius.zero;

    return onTap != null
        ? AppMaterial(
            borderRadius: borderRadius,
            inkwellBorderRadius: borderRadius,
            onTap: onTap,
            child: tile,
          )
        : tile;
  }
}
