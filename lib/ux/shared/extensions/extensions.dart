import 'package:flutter/material.dart';

extension PreferredSizeX on Widget {
  PreferredSizeWidget asPreferredSize({double height = 1}) {
    return PreferredSize(
      preferredSize: Size.fromHeight(height),
      child: this,
    );
  }
}

extension NullableStringExtension on String? {
  bool get isNullOrBlank {
    return this?.isBlank ?? true;
  }

  String ifNullOrBlank(String Function() defaultValue) {
    return isNullOrBlank ? defaultValue() : this ?? defaultValue();
  }
}

extension StringExtension on String {
  bool get isBlank {
    return trim().isEmpty;
  }

  String toSentenceCase() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  int toInt() {
    return int.tryParse(this) ?? 0;
  }
}
