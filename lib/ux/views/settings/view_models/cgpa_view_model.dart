import 'package:cgpa_calculator/platform/di/dependency_injection.dart';
import 'package:cgpa_calculator/platform/firebase/auth/auth_service.dart';
import 'package:cgpa_calculator/platform/firebase/auth/models/auth_response.dart';
import 'package:cgpa_calculator/platform/firebase/cgpa/cgpa_service.dart';
import 'package:cgpa_calculator/ux/shared/models/ui_models.dart';
import 'package:cgpa_calculator/ux/shared/view_models/auth_view_model.dart';
import 'package:flutter/foundation.dart';

class CGPAViewModel {
  final CGPAService _cgpaService = CGPAService();
  final AuthService _authService = AuthService();

  final AuthViewModel _authViewModel = AppDI.getIt<AuthViewModel>();

  ValueNotifier<UIResult<AppUser>> setTargetCGPAResult =
      ValueNotifier(UIResult.empty());

  Future<void> setTargetCGPA(
      {required double targetCGPA, required double currentCGPA}) async {
    setTargetCGPAResult.value = UIResult.loading();
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _cgpaService.setTargetCGPA(
        userId: userId,
        targetCGPA: targetCGPA,
        currentCGPA: currentCGPA,
      );

      final userData = await _authService.getUserData(userId);
      if (userData != null) {
        final appUser = AppUser.fromJson(userData);
        _authViewModel.currentUser.value = appUser;
        setTargetCGPAResult.value = UIResult.success(
          data: appUser,
          message: 'Target CGPA set successfully',
        );
      }
    } catch (e) {
      setTargetCGPAResult.value = UIResult.error(message: e.toString());
    }
  }

  // Calculate required semester GPA
  double calculateRequiredSemesterGPA(
      {required double currentCGPA,
      required double targetCGPA,
      required int completedCredits,
      required int upcomingCredits}) {
    // Formula: Required GPA = [(Target CGPA × Total Credits) - (Current CGPA × Completed Credits)] / Upcoming Credits
    final totalCredits = completedCredits + upcomingCredits;
    final requiredGPA =
        ((targetCGPA * totalCredits) - (currentCGPA * completedCredits)) /
            upcomingCredits;

    // Cap at max scale (adjust this based on your grading scale)
    final maxScale = _authViewModel.currentUser.value?.gradingScale ?? 5.0;
    return requiredGPA.clamp(0.0, maxScale);
  }
}
