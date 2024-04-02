import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/configs/app_spacing.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_event.dart';
import 'cart_section.dart';
import 'category_filtered_products.dart';

class PosScreen extends StatelessWidget {
  const PosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<CategoryBloc>().add(FetchCategories());

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(spacingStandard),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 7,
              child: CategoryFilteredProducts(),
            ),
            const VerticalDivider(),
            const Expanded(
              flex: 3,
              child: CartSection(),
            ),
          ],
        ),
      ),
    );
  }
}
