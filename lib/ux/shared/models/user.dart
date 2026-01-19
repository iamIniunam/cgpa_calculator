import 'package:cgpa_calculator/ux/shared/models/ui_models.dart';

class AppUser {
  final String name;
  final DateTime createdAt;
  final GradingScale gradingScale;

  AppUser({
    required this.name,
    required this.createdAt,
    required this.gradingScale,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'createdAt': createdAt.toIso8601String(),
        'gradingScale': gradingScale.index,
      };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        name: json['name'] ?? '',
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
        gradingScale: json['gradingScale'] != null
            ? GradingScale.values[json['gradingScale']]
            : GradingScale.scale43,
      );
}
