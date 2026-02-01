import 'package:cgpa_calculator/platform/extensions/string_extensions.dart';
import 'package:cgpa_calculator/platform/extensions/extensions.dart';
import 'package:cgpa_calculator/platform/firebase/auth/auth_result_status.dart';
import 'package:cgpa_calculator/ux/shared/models/grading_scale_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final String? profilePicture;
  final String? googleImageUrl;

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
    this.profilePicture,
    this.googleImageUrl,
  });

  bool hasProfilePicture() {
    return profilePicture.isNullOrBlank == false ||
        googleImageUrl.isNullOrBlank == false;
  }

  String? displayProfileImageUrl() {
    return profilePicture ?? googleImageUrl;
  }

  String? displayProfileImageBaseUrl() {
    if (profilePicture == null) {
      return '';
    }
    return null;
  }

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['uid'] ?? json['id'] ?? '',
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
        profilePicture: json['profilePicture'],
        googleImageUrl: json['googleImageUrl'],
      );

  @override
  Map<String, dynamic> toMap() => {
        'uid': id,
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
        'profilePicture': profilePicture,
        'googleImageUrl': googleImageUrl,
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
    String? profilePicture,
    String? googleImageUrl,
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
      profilePicture: profilePicture ?? this.profilePicture,
      googleImageUrl: googleImageUrl ?? this.googleImageUrl,
    );
  }

  // Get max grade point from grading scale
  double get maxGradePoint => gradingScale?.maxPoint ?? 5.0;

  // Check if target CGPA is set
  bool get hasTargetCGPA => targetCGPA != null && targetCGPA! > 0;
}

class AuthResult {
  final AuthResultStatus status;
  final User? user;
  final String? message;

  AuthResult({
    required this.status,
    this.user,
    this.message,
  });

  bool get isSuccessful => status.isSuccessful;
  bool get isError => status.isError;
  String get errorMessage => message ?? status.message;
}
