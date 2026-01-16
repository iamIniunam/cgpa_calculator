import 'package:cgpa_calculator/models/ui_models.dart';
import 'package:cgpa_calculator/views/components/radio_list_tile.dart';
import 'package:flutter/material.dart';

class GradingScaleDialog extends StatelessWidget {
  final GradingScale currentScale;
  final ValueChanged<GradingScale?> onScaleChanged;

  const GradingScaleDialog({
    Key? key,
    required this.currentScale,
    required this.onScaleChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Grading Scale'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomRadioListTile(
            title: '4.0 Scale',
            subtitle: 'A = 4.0',
            value: GradingScale.scale40,
            currentScale: currentScale,
            onScaleChanged: onScaleChanged,
          ),
          CustomRadioListTile(
            title: '4.3 Scale',
            subtitle: 'A+ = 4.3',
            value: GradingScale.scale43,
            currentScale: currentScale,
            onScaleChanged: onScaleChanged,
          ),
          CustomRadioListTile(
            title: '5.0 Scale',
            subtitle: 'A+ = 5.0',
            value: GradingScale.scale50,
            currentScale: currentScale,
            onScaleChanged: onScaleChanged,
          ),
        ],
      ),
    );
  }
}

class CourseDurationDialog extends StatelessWidget {
  final CourseDuration currentDuration;
  final ValueChanged<CourseDuration?> onCourseDurationChanged;

  const CourseDurationDialog({
    Key? key,
    required this.currentDuration,
    required this.onCourseDurationChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Course Duration'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomRadioListTile(
            title: '4 years',
            value: CourseDuration.fourYears,
            currentScale: currentDuration,
            onScaleChanged: onCourseDurationChanged,
          ),
          CustomRadioListTile(
            title: '5 years',
            value: CourseDuration.fiveYears,
            currentScale: currentDuration,
            onScaleChanged: onCourseDurationChanged,
          ),
          CustomRadioListTile(
            title: '6 years',
            value: CourseDuration.sixYears,
            currentScale: currentDuration,
            onScaleChanged: onCourseDurationChanged,
          ),
          CustomRadioListTile(
            title: '7 years',
            value: CourseDuration.sevenYears,
            currentScale: currentDuration,
            onScaleChanged: onCourseDurationChanged,
          ),
        ],
      ),
    );
  }
}
