import 'package:cgpa_calculator/platform/extensions/extensions.dart';
import 'package:cgpa_calculator/ux/shared/models/grading_scale_models.dart';

class SignUpRequest implements Serializable {
  final String email;
  final String password;
  final String fullName;

  SignUpRequest({
    required this.email,
    required this.password,
    required this.fullName,
  });

  factory SignUpRequest.fromJson(Map<String, dynamic> json) => SignUpRequest(
        fullName: json['fullName'] ?? '',
        email: json['email'] ?? '',
        password: json['password'] ?? '',
      );

  @override
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'fullName': fullName,
    };
  }
}

class LoginRequest implements Serializable {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
        email: json['email'] ?? '',
        password: json['password'] ?? '',
      );

  @override
  Map<String, dynamic> toMap() => {
        'email': email,
        'password': password,
      };
}

class CompleteProfileRequest implements Serializable {
  final String school;
  final GradingScale gradingScale;

  CompleteProfileRequest({
    required this.school,
    required this.gradingScale,
  });

  factory CompleteProfileRequest.fromJson(Map<String, dynamic> json) =>
      CompleteProfileRequest(
        school: json['school'] ?? '',
        gradingScale: json['gradingScale'] != null
            ? GradingScale.fromJson(json['gradingScale'])
            : GradingScale.scale5_0,
      );

  @override
  Map<String, dynamic> toMap() => {
        'school': school,
        'gradingScale': gradingScale.toMap(),
      };
}

// class UpdateUserProfileRequest implements Serializable {
//   final String? fullName;
//   final String? school;
//   final double? gradingScale;
//   final String? themePreference;
//   final double? targetCGPA;

//   UpdateUserProfileRequest({
//     this.fullName,
//     this.school,
//     this.gradingScale,
//     this.themePreference,
//     this.targetCGPA,
//   });

//   factory UpdateUserProfileRequest.fromJson(Map<String, dynamic> json) =>
//       UpdateUserProfileRequest(
//         fullName: json['name'],
//         school: json['school'],
//         gradingScale: json['gradingScale']?.toDouble(),
//         themePreference: json['themePreference'],
//         targetCGPA: json['targetCGPA']?.toDouble(),
//       );

//   @override
//   Map<String, dynamic> toMap() {
//     final map = <String, dynamic>{};
//     if (fullName != null) map['name'] = fullName;
//     if (school != null) map['school'] = school;
//     if (gradingScale != null) map['gradingScale'] = gradingScale;
//     if (themePreference != null) map['themePreference'] = themePreference;
//     if (targetCGPA != null) map['targetCGPA'] = targetCGPA;
//     return map;
//   }

// Update profile request
class UpdateUserProfileRequest implements Serializable {
  final String? fullName;
  final String? school;
  final GradingScale? gradingScale;
  final String? themePreference;
  final String? profilePicture;

  UpdateUserProfileRequest({
    this.fullName,
    this.school,
    this.gradingScale,
    this.themePreference,
    this.profilePicture,
  });

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (fullName != null) map['name'] = fullName;
    if (school != null) map['school'] = school;
    if (gradingScale != null) map['gradingScale'] = gradingScale!.toMap();
    if (themePreference != null) map['themePreference'] = themePreference;
    if (profilePicture != null) map['profilePicture'] = profilePicture;
    return map;
  }

  factory UpdateUserProfileRequest.fromJson(Map<String, dynamic> json) =>
      UpdateUserProfileRequest(
        fullName: json['name'],
        school: json['school'],
        gradingScale: json['gradingScale'] != null
            ? GradingScale.fromJson(json['gradingScale'])
            : null,
        themePreference: json['themePreference'],
        profilePicture: json['profilePicture'],
      );
}

class ForgotPasswordRequest implements Serializable {
  final String email;

  ForgotPasswordRequest({required this.email});

  @override
  Map<String, dynamic> toMap() => {'email': email};

  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordRequest(email: json['email'] ?? '');
}
