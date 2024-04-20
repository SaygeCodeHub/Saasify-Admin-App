import 'package:flutter/material.dart';
import 'package:saasify/configs/app_colors.dart';

class ProgressBar {
  static void show(BuildContext context) {
    showDialog(
        context: context,
        barrierColor: AppColors.transparent,
        barrierDismissible: false,
        builder: (context) {
          return const Center(
              child: SizedBox(
                  height: 40.0,
                  width: 40.0,
                  child: CircularProgressIndicator(
                    color: AppColors.errorRed,
                  )));
        });
  }

  static void dismiss(BuildContext context) {
    Navigator.pop(context);
  }
}
