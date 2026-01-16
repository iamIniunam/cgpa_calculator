import 'package:cgpa_calculator/views/semester_details_page.dart';
import 'package:flutter/material.dart';

class SemesterCard extends StatelessWidget {
  const SemesterCard({
    super.key,
    required this.semesterNumber,
    required this.gpa,
  });

  final int semesterNumber;
  final double gpa;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text('Semester $semesterNumber'),
        subtitle: gpa > 0 ? Text('GPA: ${gpa.toStringAsFixed(2)}') : null,
        trailing: const Icon(Icons.chevron_right_rounded, size: 25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SemesterDetailsPage(semesterNumber: semesterNumber),
            ),
          );
        },
      ),
    );
  }
}
