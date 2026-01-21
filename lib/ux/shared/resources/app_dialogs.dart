import 'package:cgpa_calculator/ux/shared/components/app_dialog_widgets.dart';
import 'package:flutter/material.dart';

class AppDialogs {
  AppDialogs._();

  static Future showLoadingDialog(BuildContext context, {String? loadingText}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AppLoadingDialogWidget(loadingText: loadingText),
    );
  }

  static Future showErrorDialog(BuildContext context,
      {required String errorMessage}) {
    return showDialog(
      context: context,
      builder: (context) => AppErrorDialogWidget(errorText: errorMessage),
    );
  }

  static Future showSuccessDialog(BuildContext context,
      {required String successMessage,
      String? title,
      VoidCallback? onDismiss}) {
    return showDialog(
      context: context,
      builder: (context) => AppSuccessDialogWidget(
        successText: successMessage,
        title: title,
        onDismiss: onDismiss,
      ),
    );
  }
}
