import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:saasify/bloc/category/category_bloc.dart';
import 'package:saasify/bloc/category/category_event.dart';
import 'package:saasify/bloc/category/category_state.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/utils/global.dart';

import '../../configs/app_colors.dart';
import '../../configs/app_spacing.dart';
import '../../models/category/product_categories.dart';
import '../widgets/skeleton_screen.dart';

class ViewCategoryScreen extends StatelessWidget {
  const ViewCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<CategoryBloc>().add(FetchCategories());
    late final ValueListenable<Box<ProductCategories>> listenableBox;
    if (kIsOfflineModule) {
      final categoriesBox = Hive.box<ProductCategories>('categories');
      listenableBox = categoriesBox.listenable();
    }

    return SkeletonScreen(
      appBarTitle: 'Categories',
      bodyContent: SingleChildScrollView(
        child: (kIsOfflineModule)
            ? ValueListenableBuilder(
                valueListenable: listenableBox,
                builder: (context, Box<ProductCategories> box, _) {
                  var width = MediaQuery.of(context).size.width;
                  int crossAxisCount = width > 600 ? 5 : 2;

                  return Padding(
                    padding: const EdgeInsets.all(spacingStandard),
                    child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 16.0,
                        ),
                        itemCount: box.length,
                        itemBuilder: (context, index) {
                          final category =
                              box.getAt(index) as ProductCategories;
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.darkGrey, // Border color
                                  width: 1.0 // Border width
                                  ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Image.asset(category.imagePath!,
                                        fit: BoxFit.cover)),
                                const Divider(color: AppColors.darkGrey),
                                Text(category.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .gridViewLabelTextStyle),
                              ],
                            ),
                          );
                        }),
                  );
                },
              )
            : BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is FetchingCategories) {
                    return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.sizeOf(context).width * 0.15,
                            horizontal: 20),
                        child:
                            const Center(child: CircularProgressIndicator()));
                  } else if (state is CategoriesFetched) {
                    return Padding(
                      padding: const EdgeInsets.all(spacingStandard),
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 20,
                          childAspectRatio: 0.95,
                        ),
                        itemCount: state.categories.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 44,
                                  left: 0,
                                  right: 0,
                                  child: Material(
                                    borderRadius:
                                        BorderRadius.circular(spacingSmall),
                                    elevation: 4,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(spacingSmall),
                                      ),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.all(spacingLarge),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
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
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top:
                                      0, // Adjust this value to overlap the previous card
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: ClipOval(
                                      child: SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: Image.asset(
                                          state.categories[index].imagePath.toString(),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state is CategoriesNotFetched) {
                    return Center(child: Text(state.errorMessage));
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
      ),
      bottomBarButtons: const [],
    );
  }
}
