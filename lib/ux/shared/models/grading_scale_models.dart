import 'package:flutter/foundation.dart';

class GradeMapping {
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GradeMapping &&
        grade == other.grade &&
        gradePoint == other.gradePoint &&
        minScore == other.minScore &&
        maxScore == other.maxScore;
  }

  @override
  int get hashCode => Object.hash(grade, gradePoint, minScore, maxScore);
  final String grade;
  final double gradePoint;
  final double minScore;
  final double maxScore;

  GradeMapping({
    required this.grade,
    required this.gradePoint,
    required this.minScore,
    required this.maxScore,
  });

  Map<String, dynamic> toMap() {
    return {
      'grade': grade,
      'point': gradePoint,
      'minScore': minScore,
      'maxScore': maxScore,
    };
  }

  factory GradeMapping.fromJson(Map<String, dynamic> json) {
    return GradeMapping(
      grade: json['grade'] ?? '',
      gradePoint: (json['gradePoint'] ?? json['point'] ?? 0.0).toDouble(),
      minScore: (json['minScore'] ?? 0.0).toDouble(),
      maxScore: (json['maxScore'] ?? 0.0).toDouble(),
    );
  }
}

class GradingScale {
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GradingScale &&
        name == other.name &&
        maxPoint == other.maxPoint &&
        listEquals(gradeMappings, other.gradeMappings);
  }

  @override
  int get hashCode =>
      Object.hash(name, maxPoint, Object.hashAll(gradeMappings));
  final String name;
  final double maxPoint;
  final List<GradeMapping> gradeMappings;

  GradingScale({
    required this.name,
    required this.maxPoint,
    required this.gradeMappings,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'maxPoint': maxPoint,
      'gradeMappings': gradeMappings.map((m) => m.toMap()).toList(),
    };
  }

  factory GradingScale.fromJson(Map<String, dynamic> json) {
    return GradingScale(
      name: json['name'] ?? '',
      maxPoint: (json['maxPoint'] ?? 0.0).toDouble(),
      gradeMappings: (json['gradeMappings'] as List?)
              ?.map((m) => GradeMapping.fromJson(m))
              .toList() ??
          [],
    );
  }

  // Predefined grading scales
  static GradingScale get scale4_0 {
    return GradingScale(
      name: '4.0 Scale',
      maxPoint: 4.0,
      gradeMappings: [
        GradeMapping(grade: 'A', gradePoint: 4.0, minScore: 90, maxScore: 100),
        GradeMapping(grade: 'A-', gradePoint: 3.7, minScore: 85, maxScore: 89),
        GradeMapping(grade: 'B+', gradePoint: 3.3, minScore: 80, maxScore: 84),
        GradeMapping(grade: 'B', gradePoint: 3.0, minScore: 75, maxScore: 79),
        GradeMapping(grade: 'B-', gradePoint: 2.7, minScore: 70, maxScore: 74),
        GradeMapping(grade: 'C+', gradePoint: 2.3, minScore: 65, maxScore: 69),
        GradeMapping(grade: 'C', gradePoint: 2.0, minScore: 60, maxScore: 64),
        GradeMapping(grade: 'D', gradePoint: 1.0, minScore: 50, maxScore: 59),
        GradeMapping(grade: 'F', gradePoint: 0.0, minScore: 0, maxScore: 49),
      ],
    );
  }

  static GradingScale get scale4_3 {
    return GradingScale(
      name: '4.3 Scale',
      maxPoint: 4.3,
      gradeMappings: [
        GradeMapping(grade: 'A+', gradePoint: 4.3, minScore: 90, maxScore: 100),
        GradeMapping(grade: 'A', gradePoint: 4.0, minScore: 85, maxScore: 89),
        GradeMapping(grade: 'A-', gradePoint: 3.7, minScore: 80, maxScore: 84),
        GradeMapping(grade: 'B+', gradePoint: 3.3, minScore: 75, maxScore: 79),
        GradeMapping(grade: 'B', gradePoint: 3.0, minScore: 70, maxScore: 74),
        GradeMapping(grade: 'C+', gradePoint: 2.3, minScore: 65, maxScore: 69),
        GradeMapping(grade: 'C', gradePoint: 2.0, minScore: 60, maxScore: 64),
        GradeMapping(grade: 'D', gradePoint: 1.0, minScore: 50, maxScore: 59),
        GradeMapping(grade: 'F', gradePoint: 0.0, minScore: 0, maxScore: 49),
      ],
    );
  }

  static GradingScale get scale5_0 {
    return GradingScale(
      name: '5.0 Scale',
      maxPoint: 5.0,
      gradeMappings: [
        GradeMapping(grade: 'A', gradePoint: 5.0, minScore: 70, maxScore: 100),
        GradeMapping(grade: 'B', gradePoint: 4.0, minScore: 60, maxScore: 69),
        GradeMapping(grade: 'C', gradePoint: 3.0, minScore: 50, maxScore: 59),
        GradeMapping(grade: 'D', gradePoint: 2.0, minScore: 45, maxScore: 49),
        GradeMapping(grade: 'E', gradePoint: 1.0, minScore: 40, maxScore: 44),
        GradeMapping(grade: 'F', gradePoint: 0.0, minScore: 0, maxScore: 39),
      ],
    );
  }

  static GradingScale get scale10_0 {
    return GradingScale(
      name: '10.0 Scale',
      maxPoint: 10.0,
      gradeMappings: [
        GradeMapping(
            grade: 'A+', gradePoint: 10.0, minScore: 90, maxScore: 100),
        GradeMapping(grade: 'A', gradePoint: 9.0, minScore: 80, maxScore: 89),
        GradeMapping(grade: 'B+', gradePoint: 8.0, minScore: 70, maxScore: 79),
        GradeMapping(grade: 'B', gradePoint: 7.0, minScore: 60, maxScore: 69),
        GradeMapping(grade: 'C', gradePoint: 6.0, minScore: 50, maxScore: 59),
        GradeMapping(grade: 'D', gradePoint: 5.0, minScore: 40, maxScore: 49),
        GradeMapping(grade: 'F', gradePoint: 0.0, minScore: 0, maxScore: 39),
      ],
    );
  }

  static List<GradingScale> get predefinedScales {
    return [
      scale4_0,
      scale4_3,
      scale5_0,
      scale10_0,
    ];
  }

  // Get grade from score
  String getGradeFromScore(double score) {
    for (var mapping in gradeMappings) {
      if (score >= mapping.minScore && score <= mapping.maxScore) {
        return mapping.grade;
      }
    }
    return 'F';
  }

  // Get grade point from grade
  double getGradePoint(String grade) {
    final mapping = gradeMappings.firstWhere(
      (m) => m.grade.toUpperCase() == grade.toUpperCase(),
      orElse: () =>
          GradeMapping(grade: 'F', gradePoint: 0.0, minScore: 0, maxScore: 0),
    );
    return mapping.gradePoint;
  }
}
