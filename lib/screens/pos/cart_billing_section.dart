import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/pos/pos_bloc.dart';
import 'package:saasify/bloc/pos/pos_event.dart';
import 'package:saasify/configs/app_colors.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/models/cart_model.dart';
import 'package:saasify/screens/widgets/label_and_textfield_widget.dart';

class CartBillingSection extends StatelessWidget {
  final List<PosModel> posDataList;
  const CartBillingSection({super.key, required this.posDataList});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: spacingStandard, vertical: spacingStandard),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 20),
          Text("Bill Details",
              style:
                  Theme.of(context).textTheme.generalSectionHeadingTextStyle),
          const SizedBox(height: spacingSmall),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Net Amount: ',
                style: Theme.of(context).textTheme.descriptionTextStyle),
            Text(context
                .read<PosBloc>()
                .billDetailsMap['net_amount']
                .toStringAsFixed(2)),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Discount: ',
                    style: Theme.of(context).textTheme.descriptionTextStyle),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: SizedBox(
                                width: 200,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text('Enter Discount Percent: '),
                                    const SizedBox(height: spacingSmall),
                                    LabelAndTextFieldWidget(
                                      onTextFieldChanged: (value) {
                                        context.read<PosBloc>().billDetailsMap[
                                                'discount_percentage'] =
                                            double.parse(value!);
                                      },
                                    ),
                                    const SizedBox(height: spacingSmall),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          context.read<PosBloc>().add(
                                              CalculateBill(
                                                  posDataList: posDataList));
                                        },
                                        child: const Text('Save'))
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    padding: EdgeInsets.zero,
                    icon:
                        const Icon(Icons.edit, size: 15, color: AppColors.blue))
              ],
            ),
            Text(context
                .read<PosBloc>()
                .billDetailsMap['discount_amount']
                .toStringAsFixed(2)),
          ]),
          const SizedBox(
            width: double.maxFinite,
            child: DottedLine(
                direction: Axis.horizontal,
                lineThickness: 1.0,
                dashColor: AppColors.darkGrey),
          ),
          const SizedBox(height: spacingXSmall),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Sub Total: ',
                style: Theme.of(context).textTheme.descriptionTextStyle),
            Text(context
                .read<PosBloc>()
                .billDetailsMap['sub_total']
                .toStringAsFixed(2)),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                Text('Taxes: ',
                    style: Theme.of(context).textTheme.descriptionTextStyle),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: SizedBox(
                                width: 200,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text('Enter Tax Percent: '),
                                    const SizedBox(height: spacingSmall),
                                    TextField(
                                      decoration: const InputDecoration(
                                        labelText: '',
                                      ),
                                      onChanged: (value) {
                                        context.read<PosBloc>().billDetailsMap[
                                                'tax_percentage'] =
                                            double.parse(value);
                                      },
                                    ),
                                    const SizedBox(height: spacingSmall),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          context.read<PosBloc>().add(
                                              CalculateBill(
                                                  posDataList: posDataList));
                                        },
                                        child: const Text('Save'))
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    padding: EdgeInsets.zero,
                    icon:
                        const Icon(Icons.edit, size: 15, color: AppColors.blue))
              ],
            ),
            Text(context
                .read<PosBloc>()
                .billDetailsMap['tax']
                .toStringAsFixed(2)),
          ]),
          const SizedBox(
            width: double.maxFinite,
            child: DottedLine(
                direction: Axis.horizontal,
                lineThickness: 1.0,
                dashColor: AppColors.darkGrey),
          ),
          const SizedBox(height: spacingXSmall),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Grand Total: ',
                style: Theme.of(context).textTheme.descriptionTextStyle),
            Text(context
                .read<PosBloc>()
                .billDetailsMap['grand_total']
                .toStringAsFixed(2)),
          ])
        ]),
      ),
    );
  }
}
