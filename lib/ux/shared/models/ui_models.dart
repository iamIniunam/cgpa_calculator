enum GradingScale {
  scale40,
  scale43,
  scale50,
}

enum CourseDuration {
  fourYears,
  fiveYears,
  sixYears,
  sevenYears,
}

class GradeOption {
  final String label;
  final double value;

  GradeOption(this.label, this.value);
}

class Course {
  String name;
  int creditHours;
  double grade;

  Course({
    required this.name,
    required this.creditHours,
    required this.grade,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'creditHours': creditHours,
      'grade': grade,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      name: map['name'] ?? '',
      creditHours: map['creditHours'] ?? 3,
      grade: map['grade'] ?? 4.0,
    );
  }
}

class Semester {
  final int semesterNumber;
  final List<Course> courses;
  double gpa;

  Semester({
    required this.semesterNumber,
    required this.courses,
    this.gpa = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'semesterNumber': semesterNumber,
      'courses': courses.map((course) => course.toMap()).toList(),
      'gpa': gpa,
    };
  }

  factory Semester.fromMap(Map<String, dynamic> map) {
    return Semester(
      semesterNumber: map['semesterNumber'] ?? 1,
      courses: List<Course>.from(
        (map['courses'] as List<dynamic>? ?? [])
            .map((courseMap) => Course.fromMap(courseMap)),
      ),
      gpa: map['gpa'] ?? 0.0,
    );
  }
}

class GradeCalculator {
  static List<GradeOption> getGradeOptions(GradingScale scale) {
    switch (scale) {
      case GradingScale.scale40:
        return [
          GradeOption('A (4.0)', 4.0),
          GradeOption('A- (3.7)', 3.7),
          GradeOption('B+ (3.3)', 3.3),
          GradeOption('B (3.0)', 3.0),
          GradeOption('B- (2.7)', 2.7),
          GradeOption('C+ (2.3)', 2.3),
          GradeOption('C (2.0)', 2.0),
          GradeOption('C- (1.7)', 1.7),
          GradeOption('D+ (1.3)', 1.3),
          GradeOption('D (1.0)', 1.0),
          GradeOption('F (0.0)', 0.0),
        ];
      case GradingScale.scale43:
        return [
          GradeOption('A+ (4.3)', 4.3),
          GradeOption('A (4.0)', 4.0),
          GradeOption('A- (3.7)', 3.7),
          GradeOption('B+ (3.3)', 3.3),
          GradeOption('B (3.0)', 3.0),
          GradeOption('B- (2.7)', 2.7),
          GradeOption('C+ (2.3)', 2.3),
          GradeOption('C (2.0)', 2.0),
          GradeOption('C- (1.7)', 1.7),
          GradeOption('D+ (1.3)', 1.3),
          GradeOption('D (1.0)', 1.0),
          GradeOption('F (0.0)', 0.0),
        ];
      case GradingScale.scale50:
        return [
          GradeOption('A+ (5.0)', 5.0),
          GradeOption('A (4.5)', 4.5),
          GradeOption('B+ (4.0)', 4.0),
          GradeOption('B (3.5)', 3.5),
          GradeOption('C+ (3.0)', 3.0),
          GradeOption('C (2.5)', 2.5),
          GradeOption('D+ (2.0)', 2.0),
          GradeOption('D (1.5)', 1.5),
          GradeOption('E (1.0)', 1.0),
          GradeOption('F (0.0)', 0.0),
        ];
    }
  }

  static double getMaxGrade(GradingScale scale) {
    switch (scale) {
      case GradingScale.scale40:
        return 4.0;
      case GradingScale.scale43:
        return 4.3;
      case GradingScale.scale50:
        return 5.0;
    }
  }

  static String getScaleText(GradingScale scale) {
    switch (scale) {
      case GradingScale.scale40:
        return '4.0';
      case GradingScale.scale43:
        return '4.3';
      case GradingScale.scale50:
        return '5.0';
    }
  }

  static double calculateGPA(List<Course> courses) {
    if (courses.isEmpty) return 0.0;

    double totalPoints = 0.0;
    int totalCredits = 0;

    for (var course in courses) {
      totalPoints += course.grade * course.creditHours;
      totalCredits += course.creditHours;
    }

    return totalCredits > 0 ? totalPoints / totalCredits : 0.0;
  }

  static double calculateCGPA(List<Semester> semesters) {
    if (semesters.isEmpty) return 0.0;

    double totalPoints = 0.0;
    int totalCredits = 0;

    for (var semester in semesters) {
      for (var course in semester.courses) {
        totalPoints += course.grade * course.creditHours;
        totalCredits += course.creditHours;
      }
    }

    return totalCredits > 0 ? totalPoints / totalCredits : 0.0;
  }
}

extension CourseDurationExtension on CourseDuration {
  int get semesterCount {
    switch (this) {
      case CourseDuration.fourYears:
        return 8;
      case CourseDuration.fiveYears:
        return 10;
      case CourseDuration.sixYears:
        return 12;
      case CourseDuration.sevenYears:
        return 14;
    }
  }

  String get yearsText {
    switch (this) {
      case CourseDuration.fourYears:
        return '4';
      case CourseDuration.fiveYears:
        return '5';
      case CourseDuration.sixYears:
        return '6';
      case CourseDuration.sevenYears:
        return '7';
    }
  }
}

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

class CGPAData {
  final List<Semester> semesters;
  final double cgpa;
  final GradingScale selectedScale;
  final CourseDuration selectedDuration;

  CGPAData({
    required this.semesters,
    required this.cgpa,
    required this.selectedScale,
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
      selectedScale: selectedScale ?? this.selectedScale,
      selectedDuration: selectedDuration ?? this.selectedDuration,
    );
  }
}
