import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/category/category_bloc.dart';
import 'package:saasify/bloc/category/category_event.dart';
import 'package:saasify/bloc/category/category_state.dart';

import 'package:saasify/screens/category/add_category_screen.dart';
import 'package:saasify/screens/category/widgets/view_category_section.dart';
import 'package:saasify/utils/error_display.dart';

import '../../configs/app_spacing.dart';
import '../widgets/skeleton_screen.dart';

class ViewCategoryScreen extends StatelessWidget {
  const ViewCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<CategoryBloc>().add(FetchCategoriesWithProducts());

    return SkeletonScreen(
        appBarTitle: 'All Categories',
        bodyContent: SingleChildScrollView(child:
            BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
          if (state is FetchingCategoriesWithProducts) {
            return Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.width * 0.15,
                    horizontal: spacingLarge),
                child: const Center(child: CircularProgressIndicator()));
          } else if (state is CategoriesWithProductsFetched) {
            return ViewCategorySection(categories: state.categories);
          } else if (state is CategoriesWithProductsNotFetched) {
            return Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.width * 0.2),
              child: Center(
                child: ErrorDisplay(
                  text: state.errorMessage,
                  buttonText: 'Add Category',
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddCategoryScreen()));
                  },
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        })),
        bottomBarButtons: const []);
  }
}
