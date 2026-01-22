import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:cgpa_calculator/ux/views/semesters/components/semester_card.dart';
import 'package:cgpa_calculator/ux/views/semesters/add_semester_page.dart';
import 'package:cgpa_calculator/ux/views/semesters/components/semester_stats_card.dart';
import 'package:flutter/material.dart';

class SemestersPage extends StatefulWidget {
  const SemestersPage({super.key});

  @override
  State<SemestersPage> createState() => _SemestersPageState();
}

class _SemestersPageState extends State<SemestersPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Column(
            children: [
              const Row(
                children: [
                  Expanded(
                    child: SemesterStats(
                      icon: Icons.bar_chart_rounded,
                      title: 'CGPA',
                      value: '3.90',
                      iconColor: AppColors.green,
                      iconBackgroundColor: AppColors.greenBackground,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: SemesterStats(
                      icon: Icons.school_rounded,
                      title: 'Credits',
                      value: '84',
                      iconColor: AppColors.purple,
                      iconBackgroundColor: AppColors.purpleBackground,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(AppStrings.semesters,
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Center(
                      child: TextButton.icon(
                        onPressed: () {
                          Navigation.navigateToScreen(
                            context: context,
                            screen: const AddSemesterPage(),
                          );
                        },
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('Add Semester'),
                        style: TextButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).appBarTheme.foregroundColor ??
                                  AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 74),
            children: [
              ...List.generate(
                8,
                (index) {
                  return const SemesterCard(
                    semesterNumber: 1,
                    gpa: 4.50,
                    creditHours: 5,
                  );
                },
              ),
              const SizedBox(height: 35),
            ],
          ),
        ),
      ],
    );
  }
}
