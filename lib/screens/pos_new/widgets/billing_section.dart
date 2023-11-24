import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/pos/billing_bloc.dart';
import 'package:saasify/data/models/billing/fetch_products_by_category_model.dart';
import '../../../configs/app_color.dart';
import '../../../configs/app_spacing.dart';
import 'bill_details.dart';
import 'billing_products_list.dart';
import 'billing_section_footer.dart';
import 'billing_section_header.dart';

class BillingSection extends StatelessWidget {
  const BillingSection(
      {super.key,
      required this.productsByCategories,
      required GlobalKey<FormState> formKey})
      : _formKey = formKey;

  final List<CategoryWithProductsDatum> productsByCategories;

  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(spacingMedium),
        decoration: const BoxDecoration(color: AppColor.saasifyLightGreyBlue),
        child: Column(children: [
          BillingSectionHeader(formKey: _formKey),
          BillingProductsList(productsByCategories: productsByCategories),
          const SizedBox(height: spacingSmall),
          BillDetails(
              billDetails: context.read<BillingBloc>().customer.billDetails),
          const SizedBox(height: spacingMedium),
          const BillingSectionFooter()
        ]));
  }
}