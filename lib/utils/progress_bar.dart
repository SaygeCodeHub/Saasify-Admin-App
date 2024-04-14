import 'package:flutter/material.dart';
import 'package:saasify/configs/app_colors.dart';
import 'package:saasify/utils/global.dart';

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
                  child: CircularProgressIndicator()));
        });
  }

  static Widget showLoadingWidget(BuildContext context) {
    return const Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.transparent)));
  }

  static void dismiss(BuildContext context) {
    (kIsCloudVersion) ? null : Navigator.of(context).pop();
  }
}
