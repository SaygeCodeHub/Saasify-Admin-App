import 'package:flutter/material.dart';
import 'package:saasify/configs/app_colors.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../configs/app_spacing.dart';

class ProductCardWidget extends StatelessWidget {
  final List<dynamic> list;
  const ProductCardWidget({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 10.0,
      children: List<Widget>.generate(list.length, (index) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.lighterGrey)),
              width: MediaQuery.sizeOf(context).width * 0.089,
              height: MediaQuery.sizeOf(context).height * 0.125,
              child: Card(
                borderOnForeground: false,
                color: AppColors.lightGrey,
                elevation: 0.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: spacingXXExcel),
                    Text(
                      list[index].name,
                      style: Theme.of(context).textTheme.gridViewLabelTextStyle,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -35,
              left: 0,
              right: 0,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: list[index].imagePath.toString(),
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
