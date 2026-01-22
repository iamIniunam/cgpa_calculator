import 'dart:ui';

import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/components/app_buttons.dart';
import 'package:cgpa_calculator/platform/extensions/extensions.dart';
import 'package:cgpa_calculator/ux/shared/models/cgpa_data.dart';
import 'package:cgpa_calculator/ux/shared/models/ui_models.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:cgpa_calculator/ux/views/semesters/add_course_page.dart';
import 'package:cgpa_calculator/ux/views/home/components/cgpa_display.dart';
import 'package:cgpa_calculator/ux/views/semesters/components/course_card.dart';
import 'package:cgpa_calculator/ux/shared/components/empty_state.dart';
import 'package:cgpa_calculator/ux/views/semesters/components/delete_course_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SemesterDetailsPage extends StatelessWidget {
  const SemesterDetailsPage({super.key, required this.semesterNumber});

  final int semesterNumber;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('${AppStrings.semester} $semesterNumber'),
          actions: const [CompleteCourseButton()],
          bottom: const Divider(height: 2).asPreferredSize(height: 1),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 110),
              child:
                  // courses.isEmpty
                  //     ? const EmptyState()
                  //     :
                  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8, right: 16),
                    child: Text(AppStrings.courses,
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        // final course = courses[index];
                        return CourseCard(
                          courseCode: 'CS101',
                          creditHours: 0,
                          grade: '',
                          score: 0.0,
                          semesterNumber: semesterNumber,
                          courseIndex: index,
                          isFirst: index == 0,
                          isLast: index == 10 - 1,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 66),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    color: Colors.black.withOpacity(0.0),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const GPADisplay(gpa: 3.75, maxcredits: 12),
                        const SizedBox(height: 24),
                        PrimaryButton(
                          onTap: () async {
                            var result = await Navigation.navigateToScreen(
                              context: context,
                              screen: const AddCoursePage(),
                            );

                            if (result is CourseInput) {}
                          },
                          child: const Text('Add Course'),
                        ),
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
