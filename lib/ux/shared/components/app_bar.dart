import 'package:cgpa_calculator/platform/extensions/extensions.dart';
import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/components/app_material.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_images.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:cgpa_calculator/ux/views/settings/profile_page.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key, this.actions});

  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Image(
            image: AppImages.appLogo,
            fit: BoxFit.cover,
            height: 35,
            width: 35,
          ),
          const SizedBox(width: 6),
          Text(AppStrings.appName,
              style: Theme.of(context).textTheme.headlineLarge),
        ],
      ),
      centerTitle: false,
      bottom: const Divider(height: 2).asPreferredSize(height: 1),
      actions: actions ??
          [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: AppMaterial(
                  onTap: () {
                    Navigation.navigateToScreen(
                      context: context,
                      screen: const ProfilePage(),
                    );
                  },
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: Theme.of(context).brightness ==
                            Brightness.dark
                        ? AppColors.transparentBackgroundDark
                        : AppColors.transparentBackgroundLight.withOpacity(0.4),
                    backgroundImage: AppImages.sampleProfileImage,
                  ),
                ),
              ),
            ),
          ],
    );
  }
}
