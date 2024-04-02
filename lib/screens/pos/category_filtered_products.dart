import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_state.dart';
import '../../configs/app_colors.dart';
import '../../configs/app_spacing.dart';
import '../widgets/product_card_widget.dart';

class CategoryFilteredProducts extends StatelessWidget {
  final List<String> _chipLabels = [
    "Chip 1",
    "Chip 2",
    "Really Long Chip Number 3",
    "Chip 4",
    "Chip 5",
    "Another Long Chip 6",
    "Chip 4",
    "Chip 5",
    "Another Long Chip 6",
  ];

  CategoryFilteredProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(spacingSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: _chipLabels
                .map((label) => Chip(
              label: Text(label),
              backgroundColor:
              Colors.grey[200], // Light grey background color
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(5), // Rounded corners of 10
                side: const BorderSide(
                    color: AppColors.lighterGrey,
                    width: 1), // Blue border
              ),
            ))
                .toList(),
          ),
          const Divider(),
          const SizedBox(height: spacingXHuge),
          SingleChildScrollView(child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is FetchingCategories) {
                  return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.width * 0.15,
                          horizontal: 20),
                      child: const Center(child: CircularProgressIndicator()));
                } else if (state is CategoriesFetched) {
                  return InkWell(
                    onTap: () {
                      _showGridDialog(context);
                    },
                    child: ProductCardWidget(
                      list: state.categories,
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              })),
        ],
      ),
    );
  }

  void _showGridDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.35,
            child: GridView.count(
              crossAxisCount: 4,
              children: List.generate(4, (index) {
                return Container(
                  margin: const EdgeInsets.all(
                      8), // Adjust spacing between containers
                  decoration: BoxDecoration(
                    color: Colors.blue[(index + 1) *
                        100], // Just as an example to differentiate containers
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  child: Center(
                    child: Text(
                      'Container ${index + 1}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
