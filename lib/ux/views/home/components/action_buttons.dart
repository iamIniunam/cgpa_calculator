import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/components/app_material.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:cgpa_calculator/ux/views/semesters/add_semester_page.dart';
import 'package:cgpa_calculator/ux/views/settings/target_cpga_page.dart';
import 'package:flutter/material.dart';

class ActionButtons extends StatefulWidget {
  const ActionButtons({super.key});

  @override
  State<ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              AppStrings.quickActions,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ActionButton(
                context: context,
                title: AppStrings.addSemester,
                icon: Icons.add_rounded,
                onTap: () {
                  Navigation.navigateToScreen(
                    context: context,
                    screen: const AddSemesterPage(),
                  );
                },
              ),
              const SizedBox(width: 16),
              ActionButton(
                context: context,
                title: AppStrings.setTargetCGPA,
                icon: Icons.track_changes_rounded,
                onTap: () {
                  Navigation.navigateToScreen(
                    context: context,
                    screen: const TargetCGPAPage(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.context,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final BuildContext context;
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppMaterial(
        inkwellBorderRadius: BorderRadius.circular(32),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryColorGradientDark,
                AppColors.primaryColorGradientLight,
              ],
            ),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppColors.white,
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
