import 'package:cgpa_calculator/platform/di/dependency_injection.dart';
import 'package:cgpa_calculator/platform/extensions/extensions.dart';
import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/components/app_bar.dart';
import 'package:cgpa_calculator/ux/shared/components/app_form_fields.dart';
import 'package:cgpa_calculator/ux/shared/components/empty_state.dart';
import 'package:cgpa_calculator/ux/shared/models/semester_model.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:cgpa_calculator/ux/views/semesters/components/semester_card.dart';
import 'package:cgpa_calculator/ux/views/semesters/add_semester_page.dart';
import 'package:cgpa_calculator/ux/views/semesters/components/semester_search.dart';
import 'package:cgpa_calculator/ux/views/semesters/components/semester_stats_card.dart';
import 'package:cgpa_calculator/ux/views/semesters/view_models/semester_view_model.dart';
import 'package:flutter/material.dart';

class SemestersPage extends StatefulWidget {
  const SemestersPage({super.key});

  @override
  State<SemestersPage> createState() => _SemestersPageState();
}

class _SemestersPageState extends State<SemestersPage> {
  final SemesterViewModel semesterViewModel = AppDI.getIt<SemesterViewModel>();
  final TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isSearching
          ? AppBar(
              title: SearchTextFormField(
                autofocus: true,
                hintText: 'Search semesters or courses',
                controller: searchController,
                onChanged: (v) {
                  setState(() {});
                },
                onClear: () {},
                onIconTap: () {
                  setState(() {
                    isSearching = false;
                  });
                },
              ),
              bottom: const Divider(height: 2).asPreferredSize(height: 1),
            )
          : HomeAppBar(
              actions: [
                SemesterSearch(
                  onSearchToggle: () {
                    setState(() {
                      isSearching = !isSearching;
                    });
                  },
                ),
              ],
            ).asPreferredSize(height: 58),
      body: ValueListenableBuilder<List<Semester>>(
          valueListenable: semesterViewModel.semesters,
          builder: (context, semeters, _) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SemesterStats(
                              icon: Icons.bar_chart_rounded,
                              title: 'CGPA',
                              value: semesterViewModel.currentCGPA
                                  .toStringAsFixed(2),
                              iconColor: AppColors.green,
                              iconBackgroundColor: AppColors.greenBackground,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: SemesterStats(
                              icon: Icons.school_rounded,
                              title: 'Credits',
                              value: semesterViewModel.totalCredits.toString(),
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
                                  foregroundColor: Theme.of(context)
                                          .appBarTheme
                                          .foregroundColor ??
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
                  child: semeters.isEmpty
                      ? const EmptyState()
                      : ListView(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 74),
                          children: [
                            ...List.generate(
                              semesterViewModel.totalSemesters,
                              (index) {
                                return SemesterCard(
                                  semester: semeters[index],
                                );
                              },
                            ),
                            const SizedBox(height: 35),
                          ],
                        ),
                ),
              ],
            );
          }),
    );
  }
}
