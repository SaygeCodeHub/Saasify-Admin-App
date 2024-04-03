import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:saasify/configs/app_colors.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/enums/product_by_quantity_enum.dart';
import 'package:saasify/models/product/products.dart';
import 'package:saasify/screens/products/variants/add_variant_screen.dart';
import 'package:saasify/screens/widgets/label_and_textfield_widget.dart';
import 'package:saasify/utils/responsive_form.dart';

class AddVariantSection extends StatelessWidget {
  final Map variantMap;
  final Products products;

  const AddVariantSection(
      {super.key, required this.variantMap, required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: spacingStandard),
      ListTile(
          leading: (products.imageUrl.isNotEmpty)
              ? CachedNetworkImage(
                  imageUrl: products.imageUrl,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => ClipOval(
                        child: Container(
                            color: AppColors.lighterGrey,
                            height: 50,
                            child: const Icon(Icons.image, size: 20)),
                      ),
                  fit: BoxFit.fitHeight)
              : const Icon(Icons.image, size: 40),
          title: Text(
            products.category,
            style: Theme.of(context)
                .textTheme
                .fieldLabelTextStyle
                .copyWith(fontSize: 17),
          ),
          subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(products.name),
                Text(products.description),
                Text(products.soldBy)
              ])),
      const SizedBox(height: spacingSmall),
      const Divider(),
      const SizedBox(height: spacingSmall),
      ResponsiveForm(formWidgets: [
        if (products.soldBy == 'Each')
          LabelAndTextFieldWidget(
            prefixIcon: const Icon(Icons.ad_units_outlined),
            label: 'Quantity',
            keyboardType: TextInputType.number,
            onTextFieldChanged: (String? value) {
              variantMap['quantity'] = value;
            },
          ),
        if (products.soldBy == 'Quantity')
          SoldByQuantityDropdown(
              soldByMap: AddVariantScreen.soldByMap, products: products),
        if (products.soldBy == 'Quantity')
          LabelAndTextFieldWidget(
              prefixIcon: const Icon(Icons.ad_units_outlined),
              label: 'Quantity',
              keyboardType: TextInputType.number,
              onTextFieldChanged: (String? value) {
                variantMap['quantity'] = value;
              }),
        LabelAndTextFieldWidget(
            prefixIcon: const Icon(Icons.price_change_rounded),
            label: 'Price',
            isRequired: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
            keyboardType: TextInputType.number,
            onTextFieldChanged: (String? value) {
              variantMap['price'] = value;
            }),
        LabelAndTextFieldWidget(
            prefixIcon: const Icon(Icons.supervisor_account),
            label: 'Supplier',
            onTextFieldChanged: (String? value) {
              variantMap['supplier'] = value;
            }),
        if (products.unit == 'None')
          LabelAndTextFieldWidget(
              prefixIcon: const Icon(Icons.ad_units_outlined),
              label: 'Tax',
              keyboardType: TextInputType.number,
              onTextFieldChanged: (String? value) {
                variantMap['tax'] = value;
              }),
        LabelAndTextFieldWidget(
            prefixIcon: const Icon(Icons.local_shipping),
            label: 'Minimum Stock Level',
            keyboardType: TextInputType.number,
            onTextFieldChanged: (String? value) {
              variantMap['stock_level'] = value;
            })
      ])
    ]);
  }
}

class SoldByQuantityDropdown extends StatefulWidget {
  final Map soldByMap;
  final Products products;

  const SoldByQuantityDropdown(
      {super.key, required this.soldByMap, required this.products});

  @override
  State<SoldByQuantityDropdown> createState() => _SoldByQuantityDropdownState();
}

class _SoldByQuantityDropdownState extends State<SoldByQuantityDropdown> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Quantity',
            style: Theme.of(context).textTheme.fieldLabelTextStyle),
        const SizedBox(height: spacingSmall),
        DropdownButtonHideUnderline(
          child: DropdownButtonFormField<String>(
            value: widget.products.unit,
            hint: const Text("Select an item"),
            items: ProductByQuantityEnum.values.map((soldBy) {
              return DropdownMenuItem<String>(
                value: soldBy.quantity.toString(),
                child: Text(soldBy.quantity.toString()),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                widget.soldByMap['selected_quantity'] = newValue!;
                widget.soldByMap['unit'] =
                    widget.soldByMap['selected_quantity'];
              });
            },
          ),
        ),
      ],
    );
  }
}