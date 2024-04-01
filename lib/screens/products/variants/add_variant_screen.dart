import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/product/product_bloc.dart';
import 'package:saasify/bloc/product/product_event.dart';
import 'package:saasify/bloc/product/product_state.dart';
import 'package:saasify/models/product/products.dart';
import 'package:saasify/screens/products/product_detail.dart';
import 'package:saasify/screens/products/variants/add_variant_section.dart';
import 'package:saasify/screens/widgets/buttons/primary_button.dart';
import 'package:saasify/screens/widgets/custom_dialogs.dart';
import 'package:saasify/screens/widgets/skeleton_screen.dart';
import 'package:saasify/utils/progress_bar.dart';

class AddVariantScreen extends StatelessWidget {
  final Map dataMap;

  AddVariantScreen({super.key, required this.dataMap});

  final formKey = GlobalKey<FormState>();
  final Map variantMap = {};
  static Map soldByMap = {'selected_value': 'Each', 'selected_quantity': 'kg'};

  @override
  Widget build(BuildContext context) {
    context.read<ProductBloc>().add(FetchProduct(
        categoryId: dataMap['category_id'], productId: dataMap['product_id']));
    return SkeletonScreen(
        appBarTitle: 'Add Variant',
        bodyContent: Form(
            key: formKey,
            child: BlocConsumer<ProductBloc, ProductState>(
              buildWhen: (previousState, currentState) =>
                  currentState is FetchingProduct ||
                  currentState is ProductFetched ||
                  currentState is ProductNotFetched,
              listener: (context, state) {
                if (state is AddingVariant) {
                  ProgressBar.show(context);
                } else if (state is VariantAdded) {
                  ProgressBar.dismiss(context);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialogs().showSuccessDialog(
                            context, state.successMessage, onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductDetails(
                                      categoryId: dataMap['category_id'],
                                      productId: dataMap['product_id'])));
                        });
                      });
                } else if (state is VariantNotAdded) {
                  ProgressBar.dismiss(context);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialogs().showAlertDialog(
                            context, state.errorMessage,
                            onPressed: () => Navigator.pop(context));
                      });
                }
              },
              builder: (context, state) {
                if (state is FetchingProduct) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProductFetched) {
                  return SingleChildScrollView(
                      child: _buildForm(context, state.products));
                } else if (state is ProductNotFetched) {
                  return Text(state.errorMessage);
                } else {
                  return const SizedBox.shrink();
                }
              },
            )),
        bottomBarButtons: [
          PrimaryButton(
              buttonTitle: 'Add Variant',
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  variantMap['category_id'] = dataMap['category_id'];
                  variantMap['product_id'] = dataMap['product_id'];
                  context
                      .read<ProductBloc>()
                      .add(AddVariant(variantMap: variantMap));
                }
              })
        ]);
  }

  Widget _buildForm(BuildContext context, Products products) {
    return AddVariantSection(variantMap: variantMap, products: products);
  }
}
