import 'package:flutter/material.dart';

class CustomRadioListTile<T> extends StatelessWidget {
  const CustomRadioListTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.currentScale,
    required this.onScaleChanged,
  });

  final String title;
  final String? subtitle;
  final dynamic value;
  final dynamic currentScale;
  final ValueChanged<T> onScaleChanged;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<T>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      activeColor: Colors.blue.shade500,
      title: Text(title),
      subtitle: (subtitle ?? '').isNotEmpty ? Text(subtitle ?? '') : null,
      value: value,
      groupValue: currentScale,
      onChanged: (value) {
        if (value != null) {
          Navigator.pop(context);
          onScaleChanged(value);
        }
      },
    );
  }
}
