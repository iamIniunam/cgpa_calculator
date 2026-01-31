import 'package:cgpa_calculator/ux/shared/models/course_model.dart';

enum SemesterStatus { inProgress, completed }

extension StatusX on SemesterStatus {
  String get label {
    switch (this) {
      case SemesterStatus.completed:
        return 'Completed';
      case SemesterStatus.inProgress:
        return 'In Progress';
    }
  }
}


class Semester {
  final String? id;
  final String? semesterName;
  final String? academicYear; // e.g., "2023/2024"
  final List<Course>? courses;
  final int? totalCreditUnits; // Sum of all course credits
  final double? totalGradePoints; // Sum of all gradePointsScored
  final double? semesterGPA; // totalGradePoints / totalCreditUnits
  final double? targetGPA;
  final SemesterStatus? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Semester({
    this.id,
    this.semesterName,
    this.academicYear,
    this.courses,
    this.totalCreditUnits,
    this.totalGradePoints,
    this.semesterGPA,
    this.targetGPA,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'semesterName': semesterName,
      'academicYear': academicYear,
      'totalCreditUnits': totalCreditUnits,
      'totalGradePoints': totalGradePoints,
      'semesterGPA': semesterGPA,
      'targetGPA': targetGPA,
      'status': status?.name,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Semester.fromJson(Map<String, dynamic> json,
      {List<Course>? courses}) {
    return Semester(
      id: json['id'] ?? '',
      semesterName: json['semesterName'] ?? '',
      academicYear: json['academicYear'] ?? '',
      courses: courses ?? [],
      totalCreditUnits: json['totalCreditUnits'] ?? 0,
      totalGradePoints: (json['totalGradePoints'] ?? 0.0).toDouble(),
      semesterGPA: (json['semesterGPA'] ?? 0.0).toDouble(),
      targetGPA: (json['targetGPA'] ?? 0.0).toDouble(),
      status: json['status'] == 'completed'
          ? SemesterStatus.completed
          : SemesterStatus.inProgress,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Semester copyWith({
    String? id,
    String? semesterName,
    String? academicYear,
    List<Course>? courses,
    int? totalCreditUnits,
    double? totalGradePoints,
    double? semesterGPA,
    double? targetGPA,
    SemesterStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Semester(
      id: id ?? this.id,
      semesterName: semesterName ?? this.semesterName,
      academicYear: academicYear ?? this.academicYear,
      courses: courses ?? this.courses,
      totalCreditUnits: totalCreditUnits ?? this.totalCreditUnits,
      totalGradePoints: totalGradePoints ?? this.totalGradePoints,
      semesterGPA: semesterGPA ?? this.semesterGPA,
      targetGPA: targetGPA ?? this.targetGPA,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Factory to create semester with auto-calculated values
  factory Semester.create({
    String? id,
    required String semesterName,
    required String academicYear,
    double? targetGPA,
    List<Course>? courses,
    SemesterStatus status = SemesterStatus.inProgress,
    DateTime? createdAt,
  }) {
    final now = DateTime.now();
    final courseList = courses ?? [];

    final totalCreditUnits = courseList.fold<int>(
      0,
      (sum, course) => sum + (course.creditUnits ?? 0),
    );

    final totalGradePoints = courseList.fold<double>(
      0.0,
      (sum, course) => sum + (course.gradePointsScored ?? 0),
    );

    final semesterGPA =
        totalCreditUnits > 0 ? totalGradePoints / totalCreditUnits : 0.0;

    return Semester(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      semesterName: semesterName,
      academicYear: academicYear,
      courses: courseList,
      totalCreditUnits: totalCreditUnits,
      totalGradePoints: totalGradePoints,
      semesterGPA: semesterGPA,
      targetGPA: targetGPA,
      status: status,
      createdAt: createdAt ?? now,
      updatedAt: now,
    );
  }

  // Recalculate semester values when courses change
  Semester recalculate() {
    final totalCreditUnits = courses?.fold<int>(
      0,
      (sum, course) => sum + (course.creditUnits ?? 0),
    );

    final totalGradePoints = courses?.fold<double>(
      0.0,
      (sum, course) => sum + (course.gradePointsScored ?? 0),
    );

    final semesterGPA = (totalCreditUnits ?? 0) > 0
        ? (totalGradePoints ?? 0) / (totalCreditUnits ?? 0)
        : 0.0;

    return copyWith(
      totalCreditUnits: totalCreditUnits,
      totalGradePoints: totalGradePoints,
      semesterGPA: semesterGPA,
      updatedAt: DateTime.now(),
    );
  }

  // Check if semester is empty
  bool get isEmpty => courses?.isEmpty ?? true;

  // Get formatted GPA
  String get formattedGPA => semesterGPA?.toStringAsFixed(2) ?? '';
}
