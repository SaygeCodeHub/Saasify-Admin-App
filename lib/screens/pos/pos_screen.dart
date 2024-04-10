import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/models/pos_model.dart';
import 'package:saasify/screens/widgets/skeleton_screen.dart';
import 'package:saasify/services/service_locator.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_event.dart';
import 'cart_section.dart';
import 'category_filtered_products.dart';

class PosScreen extends StatelessWidget {
  final BillDetails billDetails = getIt<BillDetails>();

  PosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    billDetails.discountPercentage = 0.0;
    billDetails.taxPercentage = 0.0;
    context.read<CategoryBloc>().add(FetchCategoriesWithProducts());

    return const SkeletonScreen(
        appBarTitle: 'POS',
        bodyContent: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 7, child: CategoryFilteredProducts()),
            VerticalDivider(),
            Expanded(flex: 3, child: CartSection())
          ],
        ),
        bottomBarButtons: []);
  }
}
