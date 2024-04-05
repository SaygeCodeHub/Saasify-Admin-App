import 'package:flutter/material.dart';
import 'package:saasify/configs/app_colors.dart';
import 'package:saasify/configs/app_dimensions.dart';
import 'package:saasify/configs/app_spacing.dart';

class MenuListItem extends StatelessWidget {
  const MenuListItem({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(spacingSmallest),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(kBoardTileRadius),
        child: Padding(
          padding: const EdgeInsets.all(kBoardTilePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: spacingXStandard,
                ),
              ),
              const SizedBox(height: kBoardTilePadding),
              const Text(
                'Some description here',
                style: TextStyle(fontSize: spacingStandard),
              ),
              const SizedBox(height: kBoardTilePadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Some other info',
                    style: TextStyle(fontSize: spacingMedium),
                  ),
                  CircleAvatar(
                    backgroundColor: AppColors.blue,
                    child: Text(
                      name.substring(0, 1),
                      style: const TextStyle(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
