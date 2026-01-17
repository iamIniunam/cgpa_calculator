import 'dart:convert';

import 'package:cgpa_calculator/ux/shared/models/ui_models.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends ChangeNotifier {
  AppUser? appUser;
  ValueNotifier<UIResult<bool>> loginResult = ValueNotifier(UIResult.empty());

  AuthViewModel() {
    loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(AppConstants.userKey);

    if (userJson != null) {
      appUser = AppUser.fromJson(jsonDecode(userJson));
      notifyListeners();
    }
  }

  Future<void> login(String name) async {
    if (name.trim().isEmpty) {
      loginResult.value = UIResult.error(message: 'Please enter your name');
      return;
    }

    loginResult.value = UIResult.loading();

    try {
      await Future.delayed(const Duration(seconds: 1));

      final user = AppUser(
        name: name.trim(),
        createdAt: DateTime.now(),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.userKey, jsonEncode(user.toJson()));

      appUser = user;
      loginResult.value =
          UIResult.success(data: true, message: 'Welcome, ${user.name}!');

      notifyListeners();
    } catch (e) {
      loginResult.value =
          UIResult.error(message: 'Failed to save your name: $e');
    }
  }

  String? get userName => appUser?.name;
}
