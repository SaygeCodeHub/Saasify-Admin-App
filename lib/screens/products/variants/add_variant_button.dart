import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/product/product_bloc.dart';
import 'package:saasify/bloc/product/product_event.dart';
import 'package:saasify/models/product/product_variant.dart';
import '../../../models/product/product_model.dart';
import '../../../services/service_locator.dart';
import '../../widgets/buttons/primary_button.dart';

class AddVariantButton extends StatelessWidget {
  final ProductsModel productsModel;

  const AddVariantButton({super.key, required this.productsModel});

  @override
  Widget build(BuildContext context) {
    ProductVariant productVariant = getIt<ProductVariant>();

    return PrimaryButton(
        onPressed: () {
          context.read<ProductBloc>().add(AddVariant(
              productVariant: productVariant, productsModel: productsModel));
        },
        buttonTitle: 'Add Variant');
  }
}
