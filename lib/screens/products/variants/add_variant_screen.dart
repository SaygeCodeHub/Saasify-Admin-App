import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/product/product_bloc.dart';
import 'package:saasify/bloc/product/product_event.dart';
import 'package:saasify/bloc/product/product_state.dart';
import 'package:saasify/models/product/product_variant.dart';
import 'package:saasify/models/product/product_model.dart';
import 'package:saasify/screens/products/variants/add_variant_section.dart';
import 'package:saasify/screens/widgets/buttons/primary_button.dart';
import 'package:saasify/screens/widgets/custom_dialogs.dart';
import 'package:saasify/screens/widgets/skeleton_screen.dart';
import 'package:saasify/services/service_locator.dart';
import 'package:saasify/utils/progress_bar.dart';

class AddVariantScreen extends StatelessWidget {
  final Map dataMap;
  final ProductVariant productVariant = getIt<ProductVariant>();
  final formKey = GlobalKey<FormState>();

  AddVariantScreen({super.key, required this.dataMap});

  @override
  Widget build(BuildContext context) {
    // context.read<ProductBloc>().add(FetchProducts(
    //     categoryId: dataMap['category_id'], productId: dataMap['product_id']));
    return SkeletonScreen(
        appBarTitle: 'Add Variant',
        bodyContent: Form(
            key: formKey,
            child: BlocConsumer<ProductBloc, ProductState>(
              buildWhen: (previousState, currentState) =>
                  currentState is FetchingProducts ||
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
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => ProductDetailsScreen(
                          //             categoryId: dataMap['category_id'],
                          //             productId: dataMap['product_id'])));
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
                if (state is FetchingProducts) {
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
                  productVariant.productId = dataMap['product_id'];
                  context
                      .read<ProductBloc>()
                      .add(AddVariant(categoryId: dataMap['category_id']));
                }
              })
        ]);
  }

  Widget _buildForm(BuildContext context, ProductsModel products) {
    return AddVariantSection(products: products);
  }
}
