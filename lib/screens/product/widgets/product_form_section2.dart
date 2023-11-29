import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/product/product_bloc.dart';
import 'package:saasify/bloc/product/product_event.dart';
import 'package:saasify/configs/app_dimensions.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/data/models/products/fetch_all_categories_model.dart';
import 'package:saasify/utils/constants/string_constants.dart';
import 'package:saasify/widgets/custom_dropdown.dart';
import 'package:saasify/widgets/custom_text_field.dart';
import '../../../configs/app_color.dart';

class ProductFormSection2 extends StatelessWidget {
  const ProductFormSection2({
    super.key,
    required this.isVariant,
    required this.isEdit,
    required this.dataMap,
    required this.isProductDetail,
    required this.categoryList,
  });

  final bool isVariant;
  final bool isEdit;
  final bool isProductDetail;
  final Map dataMap;
  final List<ProductCategory> categoryList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(StringConstants.kName,
          style: Theme.of(context)
              .textTheme
              .xxTiniest
              .copyWith(fontWeight: FontWeight.w700)),
      const SizedBox(height: spacingXMedium),
      (isProductDetail == true)
          ? Container(
              height: kTextFieldHeight,
              width: double.maxFinite,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(spacingXSmall),
                  border: Border.all(color: AppColor.saasifyPaleGrey)),
              child: Padding(
                  padding: const EdgeInsets.all(spacingSmall),
                  child: Text(dataMap['product_name'])))
          : CustomTextField(
              validator: (value) {
                if (value == null || value.trim() == '') {
                  return 'Please Enter the Product Name';
                }
                return null;
              },
              enabled: !(isVariant && !isEdit),
              initialValue: dataMap['product_name'] ?? '',
              onTextFieldChanged: (value) {
                dataMap['product_name'] = value;
              }),
      const SizedBox(height: spacingHuge),
      Text(StringConstants.kBarcode,
          style: Theme.of(context)
              .textTheme
              .xxTiniest
              .copyWith(fontWeight: FontWeight.w700)),
      const SizedBox(height: spacingXMedium),
      (isProductDetail == true)
          ? Container(
              height: kTextFieldHeight,
              width: double.maxFinite,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(spacingXSmall),
                  border: Border.all(color: AppColor.saasifyPaleGrey)),
              child: Padding(
                  padding: const EdgeInsets.all(spacingSmall),
                  child: Text(dataMap['barcode'].toString())))
          : CustomTextField(
              validator: (value) {
                if (value == null || value.trim() == '') {
                  return 'Please Enter the Product Barcode';
                }
                return null;
              },
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              initialValue: dataMap['barcode'] ?? '',
              onTextFieldChanged: (value) {
                dataMap['barcode'] = value;
              }),
      const SizedBox(height: spacingHuge),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(StringConstants.kQuantity,
              style: Theme.of(context)
                  .textTheme
                  .xxTiniest
                  .copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: spacingXMedium),
          (isProductDetail == true)
              ? Container(
                  height: kTextFieldHeight,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(spacingXSmall),
                      border: Border.all(color: AppColor.saasifyPaleGrey)),
                  child: Padding(
                      padding: const EdgeInsets.all(spacingSmall),
                      child: Text(dataMap['quantity'].toString())))
              : CustomTextField(
                  validator: (value) {
                    if ((value == null || value.trim() == '') &&
                        dataMap['draft'] == false) {
                      return 'This field cannot be blank';
                    }
                    return null;
                  },
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  initialValue: dataMap['quantity'] ?? '',
                  onTextFieldChanged: (value) {
                    dataMap['quantity'] = value;
                  })
        ])),
        const SizedBox(width: spacingLarger),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(StringConstants.kUnit,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .xxTiniest
                  .copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: spacingXMedium),
          (isProductDetail == true)
              ? Container(
                  height: kTextFieldHeight,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(spacingXSmall),
                      border: Border.all(color: AppColor.saasifyPaleGrey)),
                  child: Padding(
                      padding: const EdgeInsets.all(spacingSmall),
                      child: Text(dataMap['unit'] ?? "nos")))
              : CustomDropdownWidget(
                  onChanges: () {
                    context
                        .read<ProductBloc>()
                        .add(LoadForm(categoryList: categoryList));
                  },
                  initialValue: dataMap['unit'] ?? "nos",
                  listItems: ["nos", "kg", "l", "gm", "m"] +
                      ((dataMap['unit'] != null &&
                              !["nos", "kg", "l", "gm", "m"]
                                  .contains(dataMap['unit']))
                          ? [dataMap['unit']]
                          : []),
                  dataMap: dataMap,
                  mapKey: 'unit')
        ]))
      ]),
      const SizedBox(height: spacingXXLarge),
      Text(StringConstants.kGST,
          style: Theme.of(context)
              .textTheme
              .xxTiniest
              .copyWith(fontWeight: FontWeight.w700)),
      const SizedBox(height: spacingXMedium),
      (isProductDetail == true)
          ? Container(
              height: kTextFieldHeight,
              width: double.maxFinite,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(spacingXSmall),
                  border: Border.all(color: AppColor.saasifyPaleGrey)),
              child: Padding(
                padding: const EdgeInsets.all(spacingSmall),
                child: Text(
                    '${(dataMap['CGST'] + dataMap['SGST']).toInt().toString()} %'),
              ))
          : CustomDropdownWidget(
              onChanges: () {
                dataMap['CGST'] = int.parse(dataMap['GST']) / 2;
                dataMap['SGST'] = int.parse(dataMap['GST']) / 2;
                context
                    .read<ProductBloc>()
                    .add(LoadForm(categoryList: categoryList));
              },
              initialValue: (dataMap['CGST'] != null)
                  ? (dataMap['CGST'] + dataMap['SGST']).toInt().toString()
                  : '0',
              listItems: const ['0', '5', '12', '18', '28'],
              dataMap: dataMap,
              mapKey: 'GST'),
      const SizedBox(height: spacingXXSmall),
      (isProductDetail == true)
          ? Text(
              'CGST : ${(dataMap['CGST'] != null) ? dataMap['CGST'] : '0'} % and SGST : ${(dataMap['SGST'] != null) ? dataMap['SGST'] : '0'} %',
              style: Theme.of(context).textTheme.xxxTiniest)
          : Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                  'CGST : ${(dataMap['CGST'] != null) ? dataMap['CGST'] : '0'} % and SGST : ${(dataMap['SGST'] != null) ? dataMap['SGST'] : '0'} %',
                  style: Theme.of(context).textTheme.xxxTiniest),
            ),
    ]));
  }
}
