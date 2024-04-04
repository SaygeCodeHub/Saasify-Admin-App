import 'package:flutter/material.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/configs/app_theme.dart';
import '../../../cache/user_cache.dart';

class UserAvatarWidget extends StatelessWidget {
  const UserAvatarWidget({super.key});

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
          '${UserCache.getUsername()}',
          style: Theme.of(context).textTheme.moduleHeadingTextStyle,
        ),
      ],
    );
  }
}
