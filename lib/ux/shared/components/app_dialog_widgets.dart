import 'package:cgpa_calculator/platform/extensions/string_extensions.dart';
import 'package:cgpa_calculator/ux/navigation/navigation.dart';
import 'package:cgpa_calculator/ux/shared/components/app_buttons.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_colors.dart';
import 'package:flutter/material.dart';

class AppLoadingDialogWidget extends StatelessWidget {
  const AppLoadingDialogWidget({super.key, this.loadingText});

  final String? loadingText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32)),
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
  const AppSuccessDialogWidget(
      {super.key, required this.successText, this.title, this.onDismiss});

  final String successText;
  final String? title;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32)),
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
            Visibility(
              visible: title != null,
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  title ?? '',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
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
            const SizedBox(height: 24),
            PrimaryOutlinedButton(
              foregroundColor: Theme.of(context).appBarTheme.foregroundColor ??
                  AppColors.primaryColor,
              borderColor: Theme.of(context).appBarTheme.foregroundColor ??
                  AppColors.primaryColor,
              borderWidth: 0.5,
              onTap: onDismiss ??
                  () {
                    Navigation.back(context: context);
                  },
              child: const Text('Okay'),
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
        borderRadius: BorderRadius.all(Radius.circular(32)),
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
            const SizedBox(height: 24),
            PrimaryOutlinedButton(
              foregroundColor: Theme.of(context).appBarTheme.foregroundColor ??
                  AppColors.primaryColor,
              borderColor: Theme.of(context).appBarTheme.foregroundColor ??
                  AppColors.primaryColor,
              borderWidth: 0.5,
              onTap: () {
                Navigation.back(context: context);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      ),
    );
  }
}
