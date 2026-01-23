import 'package:cgpa_calculator/platform/firebase/auth/auth_service.dart';
import 'package:cgpa_calculator/platform/firebase/semester/semester_service.dart';
import 'package:cgpa_calculator/ux/shared/models/semester_model.dart';
import 'package:cgpa_calculator/ux/shared/models/ui_models.dart';
import 'package:flutter/cupertino.dart';

class SemesterViewModel extends ChangeNotifier {
  final SemesterService _semesterService = SemesterService();
  final AuthService _authService = AuthService();

  ValueNotifier<List<Semester>> semesters = ValueNotifier([]);
  ValueNotifier<UIResult<Semester>> createSemesterResult =
      ValueNotifier(UIResult.empty());
  ValueNotifier<UIResult<Semester>> updateSemesterResult =
      ValueNotifier(UIResult.empty());
  ValueNotifier<UIResult<String>> deleteSemesterResult =
      ValueNotifier(UIResult.empty());

  double get currentCGPA => CGPACalculator.calculateCGPA(semesters.value);
  int get totalCredits => CGPACalculator.calculateTotalCredits(semesters.value);
  int get completedSemestersCount =>
      CGPACalculator.getCompletedSemestersCount(semesters.value);
  int get totalSemesters => semesters.value.length;

  List<Map<String, dynamic>> get semesterGPAData =>
      CGPACalculator.getSemesterGPAData(semesters.value);

  Map<String, double> get statistics =>
      CGPACalculator.calculateStatistics(semesters.value);

  bool get hasSemesters => semesters.value.isNotEmpty;

  Future<void> loadSemesters() async {
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) return;

      final loadedSemesters = await _semesterService.getSemesters(userId);
      semesters.value = loadedSemesters;
    } catch (e) {
      debugPrint('Error loading semesters: $e');
    }
  }

  Future<void> createSemester(Semester semester) async {
    createSemesterResult.value = UIResult.loading();
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _semesterService.createSemester(
        userId: userId,
        semester: semester,
      );

      await loadSemesters();

      createSemesterResult.value = UIResult.success(
        data: semester,
        message: 'Semester created successfully',
      );
    } catch (e) {
      createSemesterResult.value = UIResult.error(message: e.toString());
    }
  }

  Future<void> updateSemester(Semester semester) async {
    updateSemesterResult.value = UIResult.loading();
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _semesterService.updateSemester(
        userId: userId,
        semester: semester,
      );

      await loadSemesters();

      updateSemesterResult.value = UIResult.success(
        data: semester,
        message: 'Semester updated successfully',
      );
    } catch (e) {
      updateSemesterResult.value = UIResult.error(message: e.toString());
    }
  }

  Future<void> deleteSemester(String semesterId) async {
    deleteSemesterResult.value = UIResult.loading();
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _semesterService.deleteSemester(
        userId: userId,
        semesterId: semesterId,
      );

      await loadSemesters();

      deleteSemesterResult.value = UIResult.success(
        data: semesterId,
        message: 'Semester deleted successfully',
      );
    } catch (e) {
      deleteSemesterResult.value = UIResult.error(message: e.toString());
    }
  }

  Future<void> updateSemesterStatus({
    required String semesterId,
    required SemesterStatus status,
  }) async {
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) return;

      await _semesterService.updateSemesterStatus(
        userId: userId,
        semesterId: semesterId,
        status: status,
      );

      await loadSemesters();
    } catch (e) {
      debugPrint('Error updating semester status: $e');
    }
  }

  void listenToSemesters() {
    final userId = _authService.currentUser?.uid;
    if (userId == null) return;

    _semesterService.semestersStream(userId).listen((loadedSemesters) {
      semesters.value = loadedSemesters;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    semesters.dispose();
    createSemesterResult.dispose();
    updateSemesterResult.dispose();
    deleteSemesterResult.dispose();
    super.dispose();
  }
}
