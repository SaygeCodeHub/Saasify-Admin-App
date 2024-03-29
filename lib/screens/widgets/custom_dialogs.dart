import 'package:flutter/material.dart';
import 'package:saasify/configs/app_colors.dart';

class CustomDialogs {
  showAlertDialog(BuildContext context, String content,
      {void Function()? onPressed}) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.warning, color: AppColors.warningYellow), // Icon
          SizedBox(width: 10), // Spacer
          Text("Alert"),
        ],
      ),
      content: Text(content), // Content text
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("No"), // Button text
        ),
        TextButton(
          onPressed: onPressed,
          child: const Text("Yes"), // Button text
        ),
      ],
    );
  }

  showSuccessDialog(BuildContext context, String content,
      {void Function()? onPressed}) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green), // Icon
          SizedBox(width: 10), // Spacer
          Text("Success"), // Title text
        ],
      ),
      content: Text(content), // Content text
      actions: [
        TextButton(
          onPressed: onPressed,
          child: const Text("OK"), // Button text
        ),
      ],
    );
  }
}
