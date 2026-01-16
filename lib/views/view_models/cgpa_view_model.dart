import 'dart:convert';

import 'package:cgpa_calculator/models/ui_models.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CGPAViewModel extends ChangeNotifier {
  final ValueNotifier<UIResult<CGPAData>> cgpaDataResult =
      ValueNotifier(UIResult.empty());

  CGPAViewModel() {
    _loadData();
  }

  CGPAData get _data =>
      cgpaDataResult.value.data ??
      CGPAData(
        semesters: [],
        cgpa: 0.0,
        selectedScale: GradingScale.scale43,
        selectedDuration: CourseDuration.fourYears,
      );

  List<Semester> get semesters => _data.semesters;

  List<Course> getCoursesForSemester(int semesterNumber) {
    final semester = _data.semesters.firstWhere(
      (s) => s.semesterNumber == semesterNumber,
      orElse: () => Semester(semesterNumber: semesterNumber, courses: []),
    );
    return semester.courses;
  }

  double getSemesterGPA(int semesterNumber) {
    final semester = _data.semesters.firstWhere(
      (s) => s.semesterNumber == semesterNumber,
      orElse: () =>
          Semester(semesterNumber: semesterNumber, gpa: 0.0, courses: []),
    );
    return semester.gpa;
  }

  void addCourseToSemester(int semesterNumber) {
    final semesters = List<Semester>.from(_data.semesters);
    final semesterIndex =
        semesters.indexWhere((s) => s.semesterNumber == semesterNumber);
    final maxGrade = GradeCalculator.getMaxGrade(_data.selectedScale);

    if (semesterIndex == -1) {
      semesters.add(Semester(
        semesterNumber: semesterNumber,
        courses: [Course(name: '', creditHours: 3, grade: maxGrade)],
      ));
    } else {
      semesters[semesterIndex].courses.add(
            Course(name: '', creditHours: 3, grade: maxGrade),
          );
    }
    _updateSemesters(semesters);
  }

  void removeCourseFromSemester(int semesterNumber, int courseIndex) {
    final semesters = List<Semester>.from(_data.semesters);
    final semesterIndex =
        semesters.indexWhere((s) => s.semesterNumber == semesterNumber);

    if (semesterIndex != -1) {
      semesters[semesterIndex].courses.removeAt(courseIndex);

      if (semesters[semesterIndex].courses.isEmpty) {
        semesters.removeAt(semesterIndex);
      }
      _updateSemesters(semesters);
    }
  }

  void updateCourse(
    int semesterNumber,
    int courseIndex, {
    String? name,
    int? creditHours,
    double? grade,
  }) {
    final semesters = List<Semester>.from(_data.semesters);
    final semesterIndex =
        semesters.indexWhere((s) => s.semesterNumber == semesterNumber);

    if (semesterIndex != -1 &&
        courseIndex < semesters[semesterIndex].courses.length) {
      final course = semesters[semesterIndex].courses[courseIndex];

      if (name != null) course.name = name;
      if (creditHours != null) course.creditHours = creditHours;
      if (grade != null) course.grade = grade;

      _updateSemesters(semesters);
    }
  }

  void changeGradingScale(GradingScale newScale) {
    final semesters = List<Semester>.from(_data.semesters);
    final maxGrade = GradeCalculator.getMaxGrade(newScale);

    for (var semester in semesters) {
      for (var course in semester.courses) {
        course.grade = maxGrade;
      }
      semester.gpa = GradeCalculator.calculateGPA(semester.courses);
    }

    final cgpa = GradeCalculator.calculateCGPA(semesters);

    cgpaDataResult.value = UIResult.success(
      data: _data.copyWith(
        semesters: semesters,
        cgpa: cgpa,
        selectedScale: newScale,
      ),
    );

    _saveData();
    notifyListeners();
  }

  void changeCourseDuration(CourseDuration newDuration) {
    cgpaDataResult.value = UIResult.success(
      data: _data.copyWith(selectedDuration: newDuration),
    );

    _saveData();
    notifyListeners();
  }

  void _updateSemesters(List<Semester> semesters) {
    for (var semester in semesters) {
      semester.gpa = GradeCalculator.calculateGPA(semester.courses);
    }

    final cgpa = GradeCalculator.calculateCGPA(semesters);

    cgpaDataResult.value = UIResult.success(
      data: _data.copyWith(
        semesters: semesters,
        cgpa: cgpa,
      ),
    );

    _saveData();
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    final semestersJson =
        _data.semesters.map((s) => jsonEncode(s.toMap())).toList();
    await prefs.setStringList('semesters', semestersJson);
    await prefs.setInt('selectedScale', _data.selectedScale.index);
    await prefs.setInt('selectedDuration', _data.selectedDuration.index);
    await prefs.setDouble('cgpa', _data.cgpa);
  }

  Future<void> _loadData() async {
    cgpaDataResult.value = UIResult.loading();

    final prefs = await SharedPreferences.getInstance();

    final semestersJson = prefs.getStringList('semesters') ?? [];
    final semesters =
        semestersJson.map((s) => Semester.fromMap(jsonDecode(s))).toList();

    final scaleIndex = prefs.getInt('selectedScale') ?? 1;
    final selectedScale = GradingScale.values[scaleIndex];

    final durationIndex = prefs.getInt('selectedDuration') ?? 0;
    final selectedDuration = CourseDuration.values[durationIndex];

    final cgpa = prefs.getDouble('cgpa') ?? 0.0;

    cgpaDataResult.value = UIResult.success(
      data: CGPAData(
        semesters: semesters,
        cgpa: cgpa,
        selectedScale: selectedScale,
        selectedDuration: selectedDuration,
      ),
    );
    notifyListeners();
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    cgpaDataResult.value = UIResult.success(
      data: CGPAData(
        semesters: [],
        cgpa: 0.0,
        selectedScale: GradingScale.scale43,
        selectedDuration: CourseDuration.fourYears,
      ),
    );
    notifyListeners();
  }
}
