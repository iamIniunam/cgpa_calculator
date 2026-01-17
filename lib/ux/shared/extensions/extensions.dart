import 'package:flutter/material.dart';

extension PreferredSizeX on Widget {
  PreferredSizeWidget asPreferredSize({double height = 1}) {
    return PreferredSize(
      preferredSize: Size.fromHeight(height),
      child: this,
    );
  }
}
