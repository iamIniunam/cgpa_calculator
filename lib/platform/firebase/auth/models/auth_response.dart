import 'package:cgpa_calculator/platform/extensions/extensions.dart';
import 'package:cgpa_calculator/ux/shared/models/grading_scale_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser implements Serializable {
  final String id;
  final String name;
  final String email;
  final String? school;
  final GradingScale? gradingScale;
  final double? targetCGPA;
  final bool profileComplete;
  final String themePreference;
  final String? appVersion;
  final String? onboardingVersion;
  final DateTime createdAt;
  final DateTime lastLogin;
  final DateTime? lastActive;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.school,
    this.gradingScale,
    this.targetCGPA,
    required this.profileComplete,
    this.themePreference = 'system',
    this.appVersion,
    this.onboardingVersion,
    required this.createdAt,
    required this.lastLogin,
    this.lastActive,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        school: json['school'],
        gradingScale: json['gradingScale'] != null
            ? GradingScale.fromJson(json['gradingScale'])
            : null,
        targetCGPA: json['targetCGPA']?.toDouble(),
        profileComplete: json['profileComplete'] ?? false,
        themePreference: json['themePreference'] ?? 'system',
        appVersion: json['appVersion'],
        onboardingVersion: json['onboardingVersion'],
        createdAt: json['createdAt'] != null
            ? (json['createdAt'] is String
                ? DateTime.parse(json['createdAt'])
                : (json['createdAt'] as Timestamp).toDate())
            : DateTime.now(),
        lastLogin: json['lastLogin'] != null
            ? (json['lastLogin'] is String
                ? DateTime.parse(json['lastLogin'])
                : (json['lastLogin'] as Timestamp).toDate())
            : DateTime.now(),
        lastActive: json['lastActive'] != null
            ? (json['lastActive'] is String
                ? DateTime.parse(json['lastActive'])
                : (json['lastActive'] as Timestamp).toDate())
            : null,
      );

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'school': school,
        'gradingScale': gradingScale?.toMap(),
        'targetCGPA': targetCGPA,
        'profileComplete': profileComplete,
        'themePreference': themePreference,
        'appVersion': appVersion,
        'onboardingVersion': onboardingVersion,
        'createdAt': createdAt.toIso8601String(),
        'lastLogin': lastLogin.toIso8601String(),
        'lastActive': lastActive?.toIso8601String(),
      };

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? school,
    GradingScale? gradingScale,
    double? targetCGPA,
    bool? profileComplete,
    String? themePreference,
    String? appVersion,
    String? onboardingVersion,
    DateTime? createdAt,
    DateTime? lastLogin,
    DateTime? lastActive,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      school: school ?? this.school,
      gradingScale: gradingScale ?? this.gradingScale,
      targetCGPA: targetCGPA ?? this.targetCGPA,
      profileComplete: profileComplete ?? this.profileComplete,
      themePreference: themePreference ?? this.themePreference,
      appVersion: appVersion ?? this.appVersion,
      onboardingVersion: onboardingVersion ?? this.onboardingVersion,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      lastActive: lastActive ?? this.lastActive,
    );
  }

  // Get max grade point from grading scale
  double get maxGradePoint => gradingScale?.maxPoint ?? 5.0;

  // Check if target CGPA is set
  bool get hasTargetCGPA => targetCGPA != null && targetCGPA! > 0;
}

class AuthResponse {
  final AppUser? user;
  final String? message;

  AuthResponse({
    this.user,
    this.message,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        user: json['user'] != null ? AppUser.fromJson(json['user']) : null,
        message: json['message'],
      );

  Map<String, dynamic> toMap() => {
        'user': user?.toMap(),
        'message': message,
      };
}
