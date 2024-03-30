import 'package:flutter/material.dart';
import 'package:saasify/configs/app_theme.dart';

import '../../../cache/cache.dart';

class UserAvatarWidget extends StatelessWidget {
  const UserAvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${CustomerCache.getUserName()} ✌🏻',
          style: Theme.of(context).textTheme.moduleHeadingTextStyle,
        ),
      ],
    );
  }
}
