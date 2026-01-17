import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_strings.dart';
import 'package:cgpa_calculator/ux/views/semester_details_page.dart';
import 'package:flutter/material.dart';

class SemesterCard extends StatelessWidget {
  const SemesterCard({
    super.key,
    required this.semesterNumber,
    required this.gpa,
    this.isFirst = false,
    this.isLast = false,
  });

  final int semesterNumber;
  final double gpa;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.only(bottom: 0),
      child: ListTile(
        title: Text('${AppStrings.semester} $semesterNumber'),
        subtitle: gpa > 0
            ? Text('${AppStrings.gpa}: ${gpa.toStringAsFixed(2)}')
            : null,
        trailing: const Icon(Icons.chevron_right_rounded, size: 25),
        tileColor: Colors.grey.shade900,
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
    );
  }
}
