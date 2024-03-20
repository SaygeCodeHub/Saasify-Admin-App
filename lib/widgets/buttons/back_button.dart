import 'package:flutter/material.dart';
import 'package:saasify/configs/app_dimensions.dart';

class CustomBackButton extends StatelessWidget {
  final void Function() onPressed;

  const CustomBackButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onPressed,
        icon: const Icon(Icons.arrow_back_ios, size: kBackButtonSize));
  }
}
