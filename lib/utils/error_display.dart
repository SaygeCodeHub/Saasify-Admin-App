import 'package:flutter/material.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/configs/app_theme.dart';

class ErrorDisplay extends StatelessWidget {
  final String text;
  final String buttonText;
  final VoidCallback onPressed;

  const ErrorDisplay({
    super.key,
    required this.text,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/empty-box.png'),
        const SizedBox(height: spacingSmall),
        Text(text, style: Theme.of(context).textTheme.errorTextStyle),
        const SizedBox(height: spacingSmallest),
        Row(
          children: [
            Text(buttonText, style: Theme.of(context).textTheme.errorTextStyle),
            IconButton(
                onPressed: onPressed, icon: const Icon(Icons.arrow_forward))
          ],
        )
      ],
    );
  }
}
