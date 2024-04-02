import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/screens/widgets/skeleton_screen.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_event.dart';
import 'cart_section.dart';
import 'category_filtered_products.dart';

class PosScreen extends StatelessWidget {
  const PosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<CategoryBloc>().add(FetchCategories());

    return const SkeletonScreen(
        appBarTitle: 'POS',
        bodyContent: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 7,
              child: CategoryFilteredProducts(),
            ),
            VerticalDivider(),
            Expanded(
              flex: 3,
              child: CartSection(),
            )
          ],
        ),
        bottomBarButtons: []);
  }
}
