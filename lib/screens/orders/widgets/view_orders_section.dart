import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:saasify/configs/app_colors.dart';
import 'package:saasify/configs/app_dimensions.dart';
import 'package:saasify/configs/app_spacing.dart';

class ViewOrdersSection extends StatelessWidget {
  final List ordersList;

  const ViewOrdersSection({super.key, required this.ordersList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(spacingMedium),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: ordersList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(spacingSmall),
              leading: CachedNetworkImage(
                  width: kNetworkImageWidth,
                  height: kNetworkImageHeight,
                  imageUrl: ordersList[index]['image'] ?? '',
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Container(
                      color: AppColors.lighterGrey,
                      height: kNetworkImageContainerHeight,
                      child:
                          const Icon(Icons.image, size: kNetworkImageIconSize)),
                  fit: BoxFit.cover),
              title: Text(ordersList[index]['name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: spacingXXSmall),
                  Text('Description: ${ordersList[index]['description']}'),
                  Text('Quantity:  ${ordersList[index]['count']}'),
                  Text('Amount:  ₹ ${ordersList[index]['cost']}')
                ],
              ),
            ),
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 15,
            childAspectRatio: 1.75),
      ),
    );
  }
}
