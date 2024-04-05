import 'package:flutter/material.dart';
import 'package:saasify/configs/app_theme.dart';

import '../../../configs/app_colors.dart';

class FeatureCardWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget screen;

  const FeatureCardWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.10,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => screen));
          },
          child: Card(
            color: cardColors[1],
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Icon(icon, size: 25),
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.020),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      label,
                      style: Theme.of(context)
                          .textTheme
                          .labelTextStyle
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

List<Color> cardColors = [
  AppColors.ghostWhite,
  AppColors.honeydew,
  AppColors.flowWhite,
  AppColors.antiWhite
];
