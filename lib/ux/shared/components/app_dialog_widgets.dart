import 'package:cgpa_calculator/ux/shared/extensions/extensions.dart';
import 'package:cgpa_calculator/ux/shared/models/ui_models.dart';
import 'package:cgpa_calculator/ux/shared/components/radio_list_tile.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
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

class AppLoadingDialogWidget extends StatelessWidget {
  const AppLoadingDialogWidget({super.key, this.loadingText});

  final String? loadingText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            ),
            Visibility(
              visible: !loadingText.isNullOrBlank,
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  loadingText ?? '',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppSuccessDialogWidget extends StatelessWidget {
  const AppSuccessDialogWidget({super.key, required this.successText});

  final String successText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: 40,
              width: 40,
              child: Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.green,
                size: 40,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                successText,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppErrorDialogWidget extends StatelessWidget {
  const AppErrorDialogWidget({super.key, required this.errorText});

  final String errorText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: 40,
              width: 40,
              child: Icon(
                Icons.error_outline_rounded,
                color: Colors.red,
                size: 40,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                errorText,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
