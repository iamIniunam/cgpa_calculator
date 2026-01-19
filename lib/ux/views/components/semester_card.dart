import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:cgpa_calculator/ux/views/semester_details_page.dart';
import 'package:flutter/material.dart';

class SemesterCard extends StatelessWidget {
  const SemesterCard({
    super.key,
    required this.semesterNumber,
    required this.gpa,
    required this.creditHours,
    this.isFirst = false,
    this.isLast = false,
  });

  final int semesterNumber;
  final double gpa;
  final int creditHours;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        margin: const EdgeInsets.only(bottom: 0),
        child: ListTile(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${AppStrings.semester} $semesterNumber',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text('$creditHours credits',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (gpa > 0) ...[
                Text(
                  gpa.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primaryColorLight,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text('SGPA', style: Theme.of(context).textTheme.bodySmall),
              ],
            ],
          ),
          tileColor: AppColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: isFirst ? const Radius.circular(12) : Radius.zero,
              topRight: isFirst ? const Radius.circular(12) : Radius.zero,
              bottomLeft: isLast ? const Radius.circular(12) : Radius.zero,
              bottomRight: isLast ? const Radius.circular(12) : Radius.zero,
            ),
            side: const BorderSide(color: Colors.black, width: 0),
          ),
          onTap: () {
            Navigation.navigateToScreen(
              context: context,
              screen: SemesterDetailsPage(
                semesterNumber: semesterNumber,
              ),
            );
          },
        ),
      ),
    );
  }
}
