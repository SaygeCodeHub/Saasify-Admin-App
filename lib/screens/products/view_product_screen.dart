import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/product/product_bloc.dart';
import 'package:saasify/bloc/product/product_event.dart';
import 'package:saasify/bloc/product/product_state.dart';
import 'package:saasify/configs/app_spacing.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ProductBloc>().add(ViewProducts());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Colors.blue,
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is FetchingProducts) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductsFetched) {
            return Padding(
              padding: const EdgeInsets.all(spacingStandard),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Categories'),
                  Wrap(
                    spacing: spacingSmall,
                    children: state.categories
                        .map((chip) => FilterChip(
                            label: Text(chip.name),
                            selected: chip.categoryId == chip.categoryId,
                            onSelected: (value) {
                              context.read<ProductBloc>().add(SelectCategory(
                                  categoryId: chip.categoryId ?? '',
                                  categories: state.categories));
                            }))
                        .toList(),
                  ),
                  const SizedBox(height: spacingStandard),
                  const Text('Products'),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        // final product = products[index];
                        return ListTile(
                          title: Text(state.products[index].name),
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => ProductDetailsScreen(product: product),
                            //   ),
                            // );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ProductsCouldNotFetch) {
            return Text(state.errorMessage);
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
