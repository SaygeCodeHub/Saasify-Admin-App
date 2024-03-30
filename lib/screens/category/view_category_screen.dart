import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/category/category_bloc.dart';
import 'package:saasify/bloc/category/category_event.dart';
import 'package:saasify/bloc/category/category_state.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/screens/category/add_category_screen.dart';
import 'package:saasify/utils/error_display.dart';

import '../../configs/app_spacing.dart';
import '../widgets/skeleton_screen.dart';

class ViewCategoryScreen extends StatelessWidget {
  const ViewCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<CategoryBloc>().add(FetchCategories());
    var width = MediaQuery.of(context).size.width;
    int crossAxisCount = width > 600 ? 5 : 2;
    return SkeletonScreen(
      appBarTitle: 'Categories',
      bodyContent: SingleChildScrollView(child:
          BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
        if (state is FetchingCategories) {
          return Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.sizeOf(context).width * 0.15,
                  horizontal: 20),
              child: const Center(child: CircularProgressIndicator()));
        } else if (state is CategoriesFetched) {
          return Padding(
            padding: const EdgeInsets.all(spacingStandard),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.95),
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Stack(children: [
                      Positioned(
                        top: 44,
                        left: 0,
                        right: 0,
                        child: Material(
                          borderRadius: BorderRadius.circular(spacingSmall),
                          elevation: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(spacingSmall),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(spacingLarge),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 60),
                                  Text(
                                    state.categories[index].name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .gridViewLabelTextStyle,
                                  ),
                                  Text(
                                    "",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                              child: ClipOval(
                                  child: SizedBox(
                            height: 100,
                            width: 100,
                            child: CachedNetworkImage(
                                imageUrl: state.categories[index].imagePath
                                    .toString(),
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.cover),
                          ))))
                    ]));
              },
            ),
          );
        } else if (state is CategoriesNotFetched) {
          return Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.sizeOf(context).width * 0.2),
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
      bottomBarButtons: const [],
    );
  }
}
