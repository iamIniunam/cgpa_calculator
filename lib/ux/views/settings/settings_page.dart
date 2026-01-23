import 'dart:io';

import 'package:cgpa_calculator/platform/di/dependency_injection.dart';
import 'package:cgpa_calculator/platform/firebase/auth/models/auth_request.dart';
import 'package:cgpa_calculator/platform/firebase/auth/models/auth_response.dart';
import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/components/app_material.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/view_models/auth_view_model.dart';
import 'package:cgpa_calculator/ux/shared/view_models/theme_view_model.dart';
import 'package:cgpa_calculator/ux/views/onboarding/grading_system_selection_page.dart';
import 'package:cgpa_calculator/ux/views/settings/components/danger_buttons.dart';
import 'package:cgpa_calculator/ux/views/settings/components/profile_card.dart';
import 'package:cgpa_calculator/ux/views/settings/components/settings_group.dart';
import 'package:cgpa_calculator/ux/views/settings/components/settings_tile.dart';
import 'package:cgpa_calculator/ux/views/settings/target_cpga_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final ThemeViewModel themeViewModel = AppDI.getIt<ThemeViewModel>();
  final AuthViewModel authViewModel = AppDI.getIt<AuthViewModel>();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 74),
      children: [
        ProfileCard(context: context),
        SettingsGroup(
          settingTiles: [
            ValueListenableBuilder<AppUser?>(
                valueListenable: authViewModel.currentUser,
                builder: (context, user, _) {
                  return SettingTile(
                    title: 'Grading Scale',
                    icon: Icons.scale_rounded,
                    trailing: Text(
                      user?.gradingScale?.name ?? '',
                      style: TextStyle(
                        color: (Theme.of(context).appBarTheme.foregroundColor ??
                            AppColors.white),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    isFirst: true,
                    onTap: () {
                      Navigation.navigateToScreen(
                        context: context,
                        screen:
                            const GradingSystemSelectionPage(isEditMode: true),
                      );
                    },
                  );
                }),
            SettingTile(
              title: 'Target CGPA',
              icon: Icons.track_changes_rounded,
              showDivider: false,
              isLast: true,
              onTap: () {
                Navigation.navigateToScreen(
                  context: context,
                  screen: const TargetCGPAPage(),
                );
              },
            ),
          ],
        ),
        SettingsGroup(
          settingTiles: [
            ValueListenableBuilder<AppThemeMode>(
              valueListenable: themeViewModel.themeMode,
              builder: (context, mode, _) {
                return SettingTile(
                  title: 'Appearance',
                  icon: mode == AppThemeMode.light
                      ? Icons.wb_sunny_rounded
                      : Icons.nights_stay_rounded,
                  trailing: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
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
                return SettingTile(
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
                              themeViewModel.setThemeMode(AppThemeMode.system);
                              authViewModel.updateProfile(
                                UpdateUserProfileRequest(
                                  themePreference: AppThemeMode.system.name,
                                ),
                              );
                            }
                          },
                    activeColor: AppColors.primaryColor,
                  ),
                  dense: true,
                  showDivider: false,
                );
              },
            ),
          ],
        ),
        SettingsGroup(
          settingTiles: [
            SettingTile(
              title: 'FAQ',
              icon: Icons.help_outline_rounded,
              isFirst: true,
              onTap: () {},
            ),
            SettingTile(
              title: 'Terms of service',
              icon: Icons.privacy_tip_outlined,
              onTap: () {},
            ),
            SettingTile(
              title: 'User policy',
              icon: Icons.info_outline_rounded,
              showDivider: false,
              isLast: true,
              onTap: () {},
            ),
          ],
        ),
        const DangerButtons(),
        const SizedBox(height: 35),
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
        authViewModel.updateProfile(
          UpdateUserProfileRequest(
            themePreference: theme == 'Light'
                ? AppThemeMode.light.name
                : AppThemeMode.dark.name,
          ),
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
}
