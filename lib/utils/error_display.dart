import 'package:flutter/material.dart';
import 'package:saasify/configs/app_colors.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/screens/widgets/buttons/primary_button.dart';

class ErrorDisplay extends StatelessWidget {
  final bool? pageNotFound;
  final String text;
  final String buttonText;
  final VoidCallback onPressed;

  const ErrorDisplay({
    super.key,
    this.pageNotFound = false,
    required this.text,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        (!pageNotFound!)
            ? Image.asset('assets/no-results.png', height: 150, width: 150)
            : Image.asset('assets/empty-box.png', height: 150, width: 150),
        const SizedBox(height: spacingSmall),
        Text(text, style: Theme.of(context).textTheme.errorTextStyle),
        const SizedBox(height: spacingLarge),
        (!pageNotFound!)
            ? TextButton(
                onPressed: () {},
                child: Text('Report',
                    style: Theme.of(context)
                        .textTheme
                        .errorTextStyle
                        .copyWith(color: AppColors.red)))
            : PrimaryButton(
                buttonWidth: 100, onPressed: onPressed, buttonTitle: buttonText)
      ],
    );
  }
}
