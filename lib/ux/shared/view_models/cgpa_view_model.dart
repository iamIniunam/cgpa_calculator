import 'dart:convert';

import 'package:cgpa_calculator/ux/shared/models/cgpa_data.dart';
import 'package:cgpa_calculator/ux/shared/models/ui_models.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_constants.dart';
import 'package:cgpa_calculator/ux/shared/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CGPAViewModel extends ChangeNotifier {
  final ValueNotifier<UIResult<CGPAData>> cgpaDataResult =
      ValueNotifier(UIResult.empty());

  final AuthViewModel authViewModel;

  CGPAViewModel({required this.authViewModel}) {
    _loadData();
  }

  CGPAData get _data =>
      cgpaDataResult.value.data ??
      CGPAData(
        semesters: [],
        cgpa: 0.0,
        selectedDuration: CourseDuration.fourYears,
      );

  GradingScale get selectedScale => authViewModel.gradingScale;
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
      orElse: () => Semester(semesterNumber: semesterNumber, courses: []),
    );

    return GradeCalculator.calculateGPA(semester.courses);
  }

  int getSemesterTotalCredits(int semesterNumber) {
    final semester = _data.semesters.firstWhere(
      (s) => s.semesterNumber == semesterNumber,
      orElse: () => Semester(semesterNumber: semesterNumber, courses: []),
    );

    int totalCredits = 0;
    for (var course in semester.courses) {
      totalCredits += course.creditHours ?? 0;
    }

    return totalCredits;
  }

  int getTotalCredits() {
    return _data.semesters.fold(
      0,
      (total, semester) =>
          total + getSemesterTotalCredits(semester.semesterNumber),
    );
  }

  void addCourseToSemester(int semesterNumber, CourseInput courseInput) {
    final semesters = List<Semester>.from(_data.semesters);
    final semesterIndex =
        semesters.indexWhere((s) => s.semesterNumber == semesterNumber);

    final newCourse = Course(
      courseCode: courseInput.courseCode,
      creditHours: courseInput.creditHours,
      grade: courseInput.grade,
      score: courseInput.score,
    );

    if (semesterIndex == -1) {
      semesters.add(Semester(
        semesterNumber: semesterNumber,
        courses: [newCourse],
      ));
    } else {
      semesters[semesterIndex].courses.insert(0, newCourse);
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
    String? courseCode,
    int? creditHours,
    String? grade,
    double? score,
  }) {
    final semesters = List<Semester>.from(_data.semesters);
    final semesterIndex =
        semesters.indexWhere((s) => s.semesterNumber == semesterNumber);

    if (semesterIndex != -1 &&
        courseIndex < semesters[semesterIndex].courses.length) {
      final course = semesters[semesterIndex].courses[courseIndex];

      if (courseCode != null) course.courseCode = courseCode;
      if (creditHours != null) course.creditHours = creditHours;
      if (grade != null) course.grade = grade;
      if (score != null) course.score = score;

      _updateSemesters(semesters);
    }
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
    await prefs.setStringList(AppConstants.semestersKey, semestersJson);
    await prefs.setInt(AppConstants.selectedScaleKey, selectedScale.index);
    await prefs.setInt(
        AppConstants.selectedDurationKey, _data.selectedDuration.index);
    await prefs.setDouble(AppConstants.cgpaKey, _data.cgpa);
  }

  Future<void> _loadData() async {
    cgpaDataResult.value = UIResult.loading();

    final prefs = await SharedPreferences.getInstance();

    final semestersJson = prefs.getStringList(AppConstants.semestersKey) ?? [];
    final semesters =
        semestersJson.map((s) => Semester.fromMap(jsonDecode(s))).toList();

    final durationIndex = prefs.getInt(AppConstants.selectedDurationKey) ?? 0;
    final selectedDuration = CourseDuration.values[durationIndex];

    final cgpa = GradeCalculator.calculateCGPA(semesters);

    cgpaDataResult.value = UIResult.success(
      data: CGPAData(
        semesters: semesters,
        cgpa: cgpa,
        selectedDuration: selectedDuration,
      ),
    );
    notifyListeners();
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.semestersKey);
    await prefs.remove(AppConstants.selectedDurationKey);
    await prefs.remove(AppConstants.cgpaKey);

    cgpaDataResult.value = UIResult.success(
      data: CGPAData(
        semesters: [],
        cgpa: 0.0,
        selectedDuration: CourseDuration.fourYears,
      ),
    );
    notifyListeners();
  }
}
