import 'package:flutter/material.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/screens/widgets/skeleton_screen.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonScreen(
      appBarTitle: 'Product Details',
      bodyContent: Padding(
        padding: const EdgeInsets.all(spacingMedium),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: Image.asset(
                  'assets/category3.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: spacingMedium),
              _buildDetailRow('Product Name:', 'Product ABC'),
              _buildDetailRow('Category:', 'Category XYZ'),
              _buildDetailRow(
                'Description:',
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
              ),
              _buildDetailRow('Supplier:', 'Supplier XYZ'),
              _buildDetailRow('Tax:', '10%'),
              _buildDetailRow('Minimum Stock Level:', '50'),
            ],
          ),
        ),
      ),
      bottomBarButtons: const [],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: spacingSmall),
        Text(value),
        const SizedBox(height: spacingMedium),
      ],
    );
  }
}
