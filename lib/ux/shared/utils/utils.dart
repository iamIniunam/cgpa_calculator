import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  Utils._();

  static hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static Future copyText({required String text}) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  static void openWebLink({required String link}) async {
    var url = Uri.parse(link);
    try {
      await launchUrl(url);
    } catch (e) {
      printInDebugMode("Error launching link: $e");
      await copyText(text: link);
    }
  }

  static printInDebugMode(String message) {
    if (kDebugMode) {
      print(message);
    }
  }
}
