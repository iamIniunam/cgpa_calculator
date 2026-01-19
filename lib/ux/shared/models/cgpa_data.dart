import 'package:cgpa_calculator/ux/shared/models/ui_models.dart';

class CGPAData {
  final List<Semester> semesters;
  final double cgpa;
  final CourseDuration selectedDuration;

  CGPAData({
    required this.semesters,
    required this.cgpa,
    required this.selectedDuration,
  });

  CGPAData copyWith({
    List<Semester>? semesters,
    double? cgpa,
    GradingScale? selectedScale,
    CourseDuration? selectedDuration,
  }) {
    return CGPAData(
      semesters: semesters ?? this.semesters,
      cgpa: cgpa ?? this.cgpa,
      selectedDuration: selectedDuration ?? this.selectedDuration,
    );
  }
}
