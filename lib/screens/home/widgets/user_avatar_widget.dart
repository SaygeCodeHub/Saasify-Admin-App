import 'package:flutter/material.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/configs/app_theme.dart';

class UserAvatarWidget extends StatelessWidget {
  final String userName;
  const UserAvatarWidget({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          child: Image.asset(
            'assets/male.jpg',
            fit: BoxFit.scaleDown,
          ),
        ),
        const SizedBox(width: spacingXSmall),
        Text(
          userName,
          style: Theme.of(context).textTheme.moduleHeadingTextStyle,
        ),
      ],
    );
  }
}
