import 'package:cgpa_calculator/ux/shared/models/semester_model.dart';

enum UIResultStatus { empty, loading, success, error }

class UIResult<T> {
  final UIResultStatus status;
  final T? data;
  final String? message;

  UIResult._({
    required this.status,
    this.data,
    this.message,
  });

  factory UIResult.empty() => UIResult._(status: UIResultStatus.empty);

  factory UIResult.loading({T? data}) => UIResult._(
        status: UIResultStatus.loading,
        data: data,
      );

  factory UIResult.success({T? data, String? message}) => UIResult._(
        status: UIResultStatus.success,
        data: data,
        message: message,
      );

  factory UIResult.error({String? message}) => UIResult._(
        status: UIResultStatus.error,
        message: message,
      );

  bool get isEmpty => status == UIResultStatus.empty;
  bool get isLoading => status == UIResultStatus.loading;
  bool get isSuccess => status == UIResultStatus.success;
  bool get isError => status == UIResultStatus.error;
}

class CourseInput {
  final String courseCode;
  final int creditHours;
  final String grade;
  final double score;

  CourseInput({
    required this.courseCode,
    required this.creditHours,
    required this.grade,
    required this.score,
  });
}

class CGPACalculator {
  /// Calculate CGPA from list of semesters
  /// Only includes completed semesters in calculation
  static double calculateCGPA(List<Semester> semesters) {
    final completedSemesters =
        semesters.where((s) => s.status == SemesterStatus.completed).toList();

    if (completedSemesters.isEmpty) return 0.0;

    final totalGradePoints = completedSemesters.fold<double>(
      0.0,
      (sum, semester) => sum + (semester.totalGradePoints ?? 0.0),
    );

    final totalCredits = completedSemesters.fold<int>(
      0,
      (sum, semester) => sum + (semester.totalCreditUnits ?? 0),
    );

    return totalCredits > 0 ? totalGradePoints / totalCredits : 0.0;
  }

  /// Calculate total credits earned (completed semesters only)
  static int calculateTotalCredits(List<Semester> semesters) {
    return semesters
        .where((s) => s.status == SemesterStatus.completed)
        .fold<int>(
          0,
          (sum, semester) => sum + (semester.totalCreditUnits ?? 0),
        );
  }

  /// Get number of completed semesters
  static int getCompletedSemestersCount(List<Semester> semesters) {
    return semesters.where((s) => s.status == SemesterStatus.completed).length;
  }

  /// Calculate required semester GPA to reach target CGPA
  /// Formula: Required GPA = [(Target CGPA × Total Credits) - (Current CGPA × Completed Credits)] / Upcoming Credits
  static double calculateRequiredSemesterGPA({
    required double currentCGPA,
    required double targetCGPA,
    required int completedCredits,
    required int upcomingCredits,
  }) {
    if (upcomingCredits == 0) return 0.0;

    final totalCredits = completedCredits + upcomingCredits;
    final requiredGPA =
        ((targetCGPA * totalCredits) - (currentCGPA * completedCredits)) /
            upcomingCredits;

    return requiredGPA < 0 ? 0.0 : requiredGPA;
  }

  /// Check if target CGPA is achievable with remaining credits
  static bool isTargetAchievable({
    required double currentCGPA,
    required double targetCGPA,
    required int completedCredits,
    required int upcomingCredits,
    required double maxGradePoint,
  }) {
    final requiredGPA = calculateRequiredSemesterGPA(
      currentCGPA: currentCGPA,
      targetCGPA: targetCGPA,
      completedCredits: completedCredits,
      upcomingCredits: upcomingCredits,
    );

    return requiredGPA <= maxGradePoint;
  }

  /// Get all semesters' GPA data for chart
  static List<Map<String, dynamic>> getSemesterGPAData(
      List<Semester> semesters) {
    return semesters
        .map((semester) => {
              'semesterName': semester.semesterName,
              'gpa': semester.semesterGPA,
              'credits': semester.totalCreditUnits,
              'status': semester.status?.name,
            })
        .toList();
  }

  /// Calculate GPA statistics
  static Map<String, double> calculateStatistics(List<Semester> semesters) {
    final completedSemesters =
        semesters.where((s) => s.status == SemesterStatus.completed).toList();

    if (completedSemesters.isEmpty) {
      return {
        'cgpa': 0.0,
        'highestGPA': 0.0,
        'lowestGPA': 0.0,
        'averageGPA': 0.0,
      };
    }

    final gpas = completedSemesters
        .map((s) => s.semesterGPA)
        .whereType<double>()
        .toList();

    return {
      'cgpa': calculateCGPA(semesters),
      'highestGPA':
          gpas.isNotEmpty ? gpas.reduce((a, b) => a > b ? a : b) : 0.0,
      'lowestGPA': gpas.isNotEmpty ? gpas.reduce((a, b) => a < b ? a : b) : 0.0,
      'averageGPA':
          gpas.isNotEmpty ? gpas.reduce((a, b) => a + b) / gpas.length : 0.0,
    };
  }

  /// Format GPA to 2 decimal places
  static String formatGPA(double gpa) {
    return gpa.toStringAsFixed(2);
  }

  /// Get grade color based on GPA value
  static String getGradeColor(double gpa, double maxPoint) {
    final percentage = (gpa / maxPoint) * 100;

    if (percentage >= 85) return 'excellent'; // A range
    if (percentage >= 70) return 'good'; // B range
    if (percentage >= 60) return 'average'; // C range
    if (percentage >= 50) return 'below'; // D range
    return 'fail'; // F range
  }
}
