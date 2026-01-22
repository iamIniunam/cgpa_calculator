import 'package:cgpa_calculator/platform/extensions/map_extensions.dart';
import 'package:flutter/material.dart';

extension PreferredSizeX on Widget {
  PreferredSizeWidget asPreferredSize({double height = 1}) {
    return PreferredSize(
      preferredSize: Size.fromHeight(height),
      child: this,
    );
  }
}


abstract class Serializable {
  Map<String, dynamic> toMap();
}

extension SerializableToJsonExtension on Serializable {
  String toJson({bool pretty = false, String indent = '  '}) {
    return toMap().toJson(pretty: pretty, indent: indent);
  }
}
