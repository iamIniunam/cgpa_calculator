class Course {
  final String id;
  final String courseCode;
  final int creditUnits;
  final double? score;
  final String grade;
  final double gradePoint;
  final double gradePointsScored; // creditUnits × gradePoint
  final DateTime createdAt;
  final DateTime updatedAt;

  Course({
    required this.id,
    required this.courseCode,
    required this.creditUnits,
    this.score,
    required this.grade,
    required this.gradePoint,
    required this.gradePointsScored,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseCode': courseCode,
      'creditUnits': creditUnits,
      'score': score,
      'grade': grade,
      'gradePoint': gradePoint,
      'gradePointsScored': gradePointsScored,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? '',
      courseCode: json['courseCode'] ?? '',
      creditUnits: json['creditUnits'] ?? 0,
      score: json['score']?.toDouble(),
      grade: json['grade'] ?? 'F',
      gradePoint: (json['gradePoint'] ?? 0.0).toDouble(),
      gradePointsScored: (json['gradePointsScored'] ?? 0.0).toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Course copyWith({
    String? id,
    String? courseCode,
    String? courseTitle,
    int? creditUnits,
    double? score,
    String? grade,
    double? gradePoint,
    double? gradePointsScored,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Course(
      id: id ?? this.id,
      courseCode: courseCode ?? this.courseCode,
      creditUnits: creditUnits ?? this.creditUnits,
      score: score ?? this.score,
      grade: grade ?? this.grade,
      gradePoint: gradePoint ?? this.gradePoint,
      gradePointsScored: gradePointsScored ?? this.gradePointsScored,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Factory to create course with auto-calculated values
  factory Course.create({
    String? id,
    required String courseCode,
    required int creditUnits,
    double? score,
    required String grade,
    required double gradePoint,
  }) {
    final now = DateTime.now();
    final gradePointsScored = creditUnits * gradePoint;

    return Course(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      courseCode: courseCode,
      creditUnits: creditUnits,
      score: score,
      grade: grade,
      gradePoint: gradePoint,
      gradePointsScored: gradePointsScored,
      createdAt: now,
      updatedAt: now,
    );
  }
}
