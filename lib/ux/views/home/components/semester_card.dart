import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/components/app_material.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/views/semesters/semester_details_page.dart';
import 'package:flutter/material.dart';

class SemesterCard extends StatelessWidget {
  const SemesterCard({
    super.key,
    required this.semesterNumber,
    required this.gpa,
    required this.creditHours,
  });

  final int semesterNumber;
  final double gpa;
  final int creditHours;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.transparentBackgroundDark
                  : AppColors.transparentBackgroundLight,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Year 2, semester 1',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          'Summer 2024 • $creditHours credits',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColors.textGrey
                                        : AppColors.dark,
                                  ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (gpa > 0) ...[
                          Text('GPA',
                              style: Theme.of(context).textTheme.bodySmall),
                          Text(
                            gpa.toStringAsFixed(2),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.primaryColorLight
                                      : AppColors.primaryColorGradientDark,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.dark
                        : AppColors.primaryColorGradientDark,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Completed'.toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0),
          AppMaterial(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.transparentBackgroundDark
                : AppColors.transparentBackgroundLight,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            inkwellBorderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            onTap: () {
              Navigation.navigateToScreen(
                context: context,
                screen: SemesterDetailsPage(
                  semesterNumber: semesterNumber,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '6 courses',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.grey300
                              : AppColors.dark,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Icon(Icons.chevron_right_rounded,
                      color: Theme.of(context).iconTheme.color, size: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
