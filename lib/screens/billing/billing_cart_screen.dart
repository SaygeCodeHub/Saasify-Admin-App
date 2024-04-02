import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/product/product_bloc.dart';
import 'package:saasify/bloc/product/product_event.dart';
import 'package:saasify/bloc/product/product_state.dart';
import 'package:saasify/configs/app_colors.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/screens/billing/select_payment_method.dart';
import 'package:saasify/screens/widgets/label_and_textfield_widget.dart';

class BillingCartScreen extends StatelessWidget {
  const BillingCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      buildWhen: (previousState, currentState) =>
          (currentState is ProductsFetched || currentState is BillDataFetched),
      builder: (context, state) {
        if (state is BillDataFetched) {
          return (context.read<ProductBloc>().showCart)
              ? Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Form(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: mobileBodyPadding,
                              vertical: spacingStandard),
                          child: TextField(
                            decoration: const InputDecoration(
                                helperText: 'Enter Customer Contact',
                                prefixIcon: Icon(Icons.phone_android)),
                            onChanged: (value) {},
                          ),
                        )),
                        const Divider(),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: mobileBodyPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                                "Are you sure you want to clear the cart?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    context
                                                        .read<ProductBloc>()
                                                        .add(ClearCart(
                                                            billingList: state
                                                                .billingList));
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Yes')),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('No'))
                                            ],
                                          );
                                        });
                                  },
                                  child: Text('Clear Cart',
                                      style: Theme.of(context)
                                          .textTheme
                                          .errorSubtitleTextStyle
                                          .copyWith(
                                              color: AppColors.errorRed))),
                              Expanded(
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: state.billingList.length,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: spacingXXSmall),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                          padding: const EdgeInsets.all(
                                              spacingSmall),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                child: SizedBox.square(
                                                  dimension: 70,
                                                  child: Image.network(
                                                    "https://media.istockphoto.com/id/1398630614/photo/bacon-cheeseburger-on-a-toasted-bun.jpg?s=1024x1024&w=is&k=20&c=rXM2ry9bme764bKBGagwq4jYdjr7q98UiJLyHrl6BUU=",
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                  width: spacingSmall),
                                              Expanded(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          state
                                                              .billingList[
                                                                  index]
                                                              .name,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .productNameTextStyle),
                                                      Text("description",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .variantNameTextStyle),
                                                      const SizedBox(
                                                          height:
                                                              spacingXSmall),
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Stack(
                                                              children: [
                                                                Container(
                                                                  width: 80,
                                                                  height: 27,
                                                                  decoration: BoxDecoration(
                                                                      color: AppColors
                                                                          .lighterGrey,
                                                                      border: Border.all(
                                                                          color: AppColors
                                                                              .grey),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15)),
                                                                  child: Center(
                                                                      child: Text(state
                                                                          .billingList[
                                                                              index]
                                                                          .count
                                                                          .toString())),
                                                                ),
                                                                Positioned(
                                                                  left: -0.3,
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      context
                                                                          .read<
                                                                              ProductBloc>()
                                                                          .add(DecrementVariantCount(
                                                                              billingList: state.billingList));
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          27,
                                                                      width: 27,
                                                                      decoration: BoxDecoration(
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: AppColors.lighterGrey.withOpacity(0.2),
                                                                              offset: const Offset(4.0, 4.0),
                                                                              blurRadius: 2.0,
                                                                              spreadRadius: 1.0,
                                                                            )
                                                                          ],
                                                                          color: AppColors
                                                                              .white,
                                                                          border:
                                                                              Border.all(color: AppColors.darkGrey),
                                                                          borderRadius: BorderRadius.circular(25)),
                                                                      child: const Icon(
                                                                          Icons
                                                                              .remove,
                                                                          size:
                                                                              15),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  left: 52,
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      context
                                                                          .read<
                                                                              ProductBloc>()
                                                                          .add(IncrementVariantCount(
                                                                              billingList: state.billingList));
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          27,
                                                                      width: 27,
                                                                      decoration: BoxDecoration(
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: AppColors.lighterGrey.withOpacity(0.2),
                                                                              offset: const Offset(4.0, 4.0),
                                                                              blurRadius: 5.0,
                                                                              spreadRadius: 1.0,
                                                                            )
                                                                          ],
                                                                          color: AppColors
                                                                              .white,
                                                                          border:
                                                                              Border.all(color: AppColors.darkGrey),
                                                                          borderRadius: BorderRadius.circular(25)),
                                                                      child: const Icon(
                                                                          Icons
                                                                              .add,
                                                                          size:
                                                                              15,
                                                                          color:
                                                                              AppColors.orange),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            RichText(
                                                                text: TextSpan(
                                                                    text: '₹ ',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .descriptionTextStyle,
                                                                    children: <TextSpan>[
                                                                  TextSpan(
                                                                      text: state
                                                                          .billingList[
                                                                              index]
                                                                          .cost
                                                                          .toString(),
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .productCostTextStyle)
                                                                ]))
                                                          ])
                                                    ]),
                                              ),
                                            ],
                                          ));
                                    }),
                              ),
                              Card(
                                elevation: 0,
                                color: AppColors.grey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: spacingStandard,
                                      vertical: spacingStandard),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 20),
                                        Text("Bill Details",
                                            style: Theme.of(context)
                                                .textTheme
                                                .generalSectionHeadingTextStyle),
                                        const SizedBox(height: spacingSmall),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Net Amount: ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .descriptionTextStyle),
                                              Text(context
                                                  .read<ProductBloc>()
                                                  .billDetailsMap['net_amount']
                                                  .toString()),
                                            ]),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text('Discount: ',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .descriptionTextStyle),
                                                  IconButton(
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                content:
                                                                    SizedBox(
                                                                  width: 200,
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      const Text(
                                                                          'Enter Discount Percent: '),
                                                                      const SizedBox(
                                                                          height:
                                                                              spacingSmall),
                                                                      LabelAndTextFieldWidget(
                                                                        onTextFieldChanged:
                                                                            (value) {
                                                                          context
                                                                              .read<ProductBloc>()
                                                                              .billDetailsMap['discount_percentage'] = double.parse(value!);
                                                                        },
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              spacingSmall),
                                                                      ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                            context.read<ProductBloc>().add(CalculateBill(billingList: state.billingList));
                                                                          },
                                                                          child:
                                                                              const Text('Save'))
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            });
                                                      },
                                                      padding: EdgeInsets.zero,
                                                      icon: const Icon(
                                                          Icons.edit,
                                                          size: 15,
                                                          color:
                                                              AppColors.orange))
                                                ],
                                              ),
                                              Text(context
                                                  .read<ProductBloc>()
                                                  .billDetailsMap[
                                                      'discount_amount']
                                                  .toString()),
                                            ]),
                                        const SizedBox(
                                          width: double.maxFinite,
                                          child: DottedLine(
                                              direction: Axis.horizontal,
                                              lineThickness: 1.0,
                                              dashColor: AppColors.darkGrey),
                                        ),
                                        const SizedBox(height: spacingXSmall),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Sub Total: ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .descriptionTextStyle),
                                              Text(context
                                                  .read<ProductBloc>()
                                                  .billDetailsMap['sub_total']
                                                  .toString()),
                                            ]),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text('Taxes: ',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .descriptionTextStyle),
                                                  IconButton(
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                content:
                                                                    SizedBox(
                                                                  width: 200,
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      const Text(
                                                                          'Enter Tax Percent: '),
                                                                      const SizedBox(
                                                                          height:
                                                                              spacingSmall),
                                                                      TextField(
                                                                        decoration:
                                                                            const InputDecoration(
                                                                          labelText:
                                                                              '',
                                                                        ),
                                                                        onChanged:
                                                                            (value) {
                                                                          context
                                                                              .read<ProductBloc>()
                                                                              .billDetailsMap['tax_percentage'] = double.parse(value);
                                                                        },
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              spacingSmall),
                                                                      ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                            context.read<ProductBloc>().add(CalculateBill(billingList: state.billingList));
                                                                          },
                                                                          child:
                                                                              const Text('Save'))
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            });
                                                      },
                                                      padding: EdgeInsets.zero,
                                                      icon: const Icon(
                                                          Icons.edit,
                                                          size: 15,
                                                          color:
                                                              AppColors.orange))
                                                ],
                                              ),
                                              Text(context
                                                  .read<ProductBloc>()
                                                  .billDetailsMap['tax']
                                                  .toString()),
                                            ]),
                                        const SizedBox(
                                          width: double.maxFinite,
                                          child: DottedLine(
                                              direction: Axis.horizontal,
                                              lineThickness: 1.0,
                                              dashColor: AppColors.darkGrey),
                                        ),
                                        const SizedBox(height: spacingXSmall),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Grand Total: ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .descriptionTextStyle),
                                              Text(context
                                                  .read<ProductBloc>()
                                                  .billDetailsMap['grand_total']
                                                  .toString()),
                                            ])
                                      ]),
                                ),
                              ),
                              const SizedBox(height: spacingSmall),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                        onPressed: () {},
                                        child: const Text('Print KOT')),
                                  ),
                                  const SizedBox(width: spacingSmall),
                                  Expanded(
                                      child: ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return SelectPaymentMethod(
                                                      totalAmount: context
                                                              .read<ProductBloc>()
                                                              .billDetailsMap[
                                                          'total_amount'],
                                                      billDetailsMap: context
                                                          .read<ProductBloc>()
                                                          .billDetailsMap);
                                                });
                                          },
                                          child: const Text('Settle Bill'))),
                                ],
                              )
                            ],
                          ),
                        )),
                        const SizedBox(height: spacingXXXLarge)
                      ]),
                )
              : const SizedBox.shrink();
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
