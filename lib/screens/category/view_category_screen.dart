import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/category/category_bloc.dart';
import 'package:saasify/bloc/category/category_event.dart';
import 'package:saasify/bloc/category/category_state.dart';
import 'package:saasify/configs/app_colors.dart';
import 'package:saasify/configs/app_theme.dart';

import 'package:saasify/screens/category/add_category_screen.dart';
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
                    horizontal: 20),
                child: const Center(child: CircularProgressIndicator()));
          } else if (state is CategoriesWithProductsFetched) {
            return Padding(
              padding: const EdgeInsets.all(spacingStandard),
              child: Wrap(
                spacing: 20,
                runSpacing: 10.0,
                children: [
                  ...List<Widget>.generate(state.categories.length, (index) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.lighterGrey)),
                          width: MediaQuery.sizeOf(context).width * 0.089,
                          height: MediaQuery.sizeOf(context).height * 0.145,
                          child: Card(
                            borderOnForeground: false,
                            color: AppColors.lightGrey,
                            elevation: 0.0,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: spacingXXExcel),
                                Text(
                                  state.categories[index].name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .gridViewLabelTextStyle,
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
                                imageUrl: state.categories[index].imagePath
                                    .toString(),
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
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
                  })
                ],
              ),
            );
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
