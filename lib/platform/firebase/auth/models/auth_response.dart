import 'package:cgpa_calculator/platform/extensions/extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser implements Serializable {
  final String id;
  final String name;
  final String email;
  final String? school;
  final double? gradingScale;
  final bool profileComplete;
  final String themePreference;
  final double? targetCGPA;
  final double? currentCGPA;
  final DateTime createdAt;
  final DateTime lastLogin;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.school,
    this.gradingScale,
    required this.profileComplete,
    this.themePreference = 'system',
    this.targetCGPA,
    this.currentCGPA,
    required this.createdAt,
    required this.lastLogin,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        school: json['school'],
        gradingScale: json['gradingScale']?.toDouble(),
        profileComplete: json['profileComplete'] ?? false,
        themePreference: json['themePreference'] ?? 'system',
        targetCGPA: json['targetCGPA']?.toDouble(),
        currentCGPA: json['currentCGPA']?.toDouble(),
        createdAt: json['createdAt'] is String
            ? DateTime.parse(json['createdAt'])
            : (json['createdAt'] is Timestamp
                ? (json['createdAt'] as Timestamp).toDate()
                : DateTime.now()),
        lastLogin: json['lastLogin'] is String
            ? DateTime.parse(json['lastLogin'])
            : (json['lastLogin'] is Timestamp
                ? (json['lastLogin'] as Timestamp).toDate()
                : DateTime.now()),
      );

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'school': school,
        'gradingScale': gradingScale,
        'profileComplete': profileComplete,
        'themePreference': themePreference,
        'targetCGPA': targetCGPA,
        'currentCGPA': currentCGPA,
        'createdAt': createdAt,
        'lastLogin': lastLogin,
      };

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? school,
    double? gradingScale,
    bool? profileComplete,
    String? themePreference,
    double? targetCGPA,
    double? currentCGPA,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) =>
      AppUser(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        school: school ?? this.school,
        gradingScale: gradingScale ?? this.gradingScale,
        profileComplete: profileComplete ?? this.profileComplete,
        themePreference: themePreference ?? this.themePreference,
        targetCGPA: targetCGPA ?? this.targetCGPA,
        currentCGPA: currentCGPA ?? this.currentCGPA,
        createdAt: createdAt ?? this.createdAt,
        lastLogin: lastLogin ?? this.lastLogin,
      );
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
