import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/screens/billing/select_payment_method.dart';

import '../../configs/app_colors.dart';
import '../../configs/app_spacing.dart';
import '../../models/cart_model.dart';
import 'billing_screen.dart';

class CartScreen extends StatefulWidget {
  final List<Billing> cart;

  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static Map<String, dynamic> billDetailsMap = {};

  void calculateBillDetails(List<Billing> cart) {
    double netAmount = 0.0;
    double totalCost = 0.0;

    for (var cartItem in cart) {
      totalCost += cartItem.cost;
    }

    netAmount = totalCost;
    double discountPercent = billDetailsMap['discount_percentage'] ?? 0.0;
    double discountAmount = (netAmount * discountPercent) / 100;
    double subTotal = netAmount - discountAmount;

    double taxPercent = billDetailsMap['tax_percentage'] ?? 0.0;
    double taxes = (subTotal * taxPercent) / 100;

    double grandTotal = subTotal + taxes;

    billDetailsMap['net_amount'] = netAmount;
    billDetailsMap['discount_amount'] = discountAmount;
    billDetailsMap['sub_total'] = subTotal;
    billDetailsMap['tax'] = taxes;
    billDetailsMap['grand_total'] = grandTotal;
  }

  @override
  void initState() {
    calculateBillDetails(widget.cart);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Form(
            child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: mobileBodyPadding, vertical: spacingStandard),
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
          padding: const EdgeInsets.symmetric(horizontal: mobileBodyPadding),
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
                                    setState(() {
                                      widget.cart.clear();
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const BillingScreen()));
                                    });
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
                          .copyWith(color: AppColors.errorRed))),
              Expanded(
                child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: widget.cart.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: spacingXXSmall),
                    itemBuilder: (context, index) {
                      calculateBillDetails(widget.cart);
                      return Padding(
                          padding: const EdgeInsets.all(spacingSmall),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: SizedBox.square(
                                  dimension: 70,
                                  child: Image.network(
                                    "https://media.istockphoto.com/id/1398630614/photo/bacon-cheeseburger-on-a-toasted-bun.jpg?s=1024x1024&w=is&k=20&c=rXM2ry9bme764bKBGagwq4jYdjr7q98UiJLyHrl6BUU=",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: spacingSmall),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.cart[index].name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .productNameTextStyle),
                                      Text("description",
                                          style: Theme.of(context)
                                              .textTheme
                                              .variantNameTextStyle),
                                      const SizedBox(height: spacingXSmall),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Stack(
                                              children: [
                                                Container(
                                                  width: 80,
                                                  height: 27,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          AppColors.lighterGrey,
                                                      border: Border.all(
                                                          color:
                                                              AppColors.grey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  child: Center(
                                                      child: Text(widget
                                                          .cart[index].count
                                                          .toString())),
                                                ),
                                                Positioned(
                                                  left: -0.3,
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        (widget.cart[index]
                                                            .count--);
                                                        widget.cart[index]
                                                            .cost = (widget
                                                                .cart[index]
                                                                .variantCost *
                                                            widget.cart[index]
                                                                .count);
                                                        calculateBillDetails(
                                                            widget.cart);
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 27,
                                                      width: 27,
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: AppColors
                                                                  .lighterGrey
                                                                  .withOpacity(
                                                                      0.2),
                                                              offset:
                                                                  const Offset(
                                                                      4.0, 4.0),
                                                              blurRadius: 2.0,
                                                              spreadRadius: 1.0,
                                                            )
                                                          ],
                                                          color:
                                                              AppColors.white,
                                                          border: Border.all(
                                                              color: AppColors
                                                                  .darkGrey),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      25)),
                                                      child: const Icon(
                                                          Icons.remove,
                                                          size: 15),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 52,
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        (widget.cart[index]
                                                            .count++);
                                                        widget.cart[index]
                                                            .cost = (widget
                                                                .cart[index]
                                                                .variantCost *
                                                            widget.cart[index]
                                                                .count);
                                                        calculateBillDetails(
                                                            widget.cart);
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 27,
                                                      width: 27,
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: AppColors
                                                                  .lighterGrey
                                                                  .withOpacity(
                                                                      0.2),
                                                              offset:
                                                                  const Offset(
                                                                      4.0, 4.0),
                                                              blurRadius: 5.0,
                                                              spreadRadius: 1.0,
                                                            )
                                                          ],
                                                          color:
                                                              AppColors.white,
                                                          border: Border.all(
                                                              color: AppColors
                                                                  .darkGrey),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      25)),
                                                      child: const Icon(
                                                          Icons.add,
                                                          size: 15,
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
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .descriptionTextStyle,
                                                    children: <TextSpan>[
                                                  TextSpan(
                                                      text: widget
                                                          .cart[index].cost
                                                          .toString(),
                                                      style: Theme.of(context)
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
                      horizontal: spacingStandard, vertical: spacingStandard),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Bill Details",
                            style: Theme.of(context)
                                .textTheme
                                .generalSectionHeadingTextStyle),
                        const SizedBox(height: spacingSmall),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Net Amount: ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .descriptionTextStyle),
                              Text(billDetailsMap['net_amount'].toString()),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                content: SizedBox(
                                                  width: 200,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Text(
                                                          'Enter Discount Percent: '),
                                                      const SizedBox(
                                                          height: spacingSmall),
                                                      TextField(
                                                        decoration:
                                                            const InputDecoration(
                                                          labelText: '',
                                                        ),
                                                        onChanged: (value) {
                                                          billDetailsMap[
                                                                  'discount_percentage'] =
                                                              double.parse(
                                                                  value);
                                                        },
                                                      ),
                                                      const SizedBox(
                                                          height: spacingSmall),
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              calculateBillDetails(
                                                                  widget.cart);
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          },
                                                          child: const Text(
                                                              'Save'))
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(Icons.edit,
                                          size: 15, color: AppColors.orange))
                                ],
                              ),
                              Text(
                                  billDetailsMap['discount_amount'].toString()),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Sub Total: ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .descriptionTextStyle),
                              Text(billDetailsMap['sub_total'].toString()),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                content: SizedBox(
                                                  width: 200,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Text(
                                                          'Enter Tax Percent: '),
                                                      const SizedBox(
                                                          height: spacingSmall),
                                                      TextField(
                                                        decoration:
                                                            const InputDecoration(
                                                          labelText: '',
                                                        ),
                                                        onChanged: (value) {
                                                          billDetailsMap[
                                                                  'tax_percentage'] =
                                                              double.parse(
                                                                  value);
                                                        },
                                                      ),
                                                      const SizedBox(
                                                          height: spacingSmall),
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              calculateBillDetails(
                                                                  widget.cart);
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          },
                                                          child: const Text(
                                                              'Save'))
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(Icons.edit,
                                          size: 15, color: AppColors.orange))
                                ],
                              ),
                              Text(billDetailsMap['tax'].toString()),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Grand Total: ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .descriptionTextStyle),
                              Text(billDetailsMap['grand_total']
                                  .toStringAsFixed(2)),
                            ])
                      ]),
                ),
              ),
              const SizedBox(height: spacingSmall),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {}, child: const Text('Print KOT')),
                  ),
                  const SizedBox(width: spacingSmall),
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  billDetailsMap['cart_items'] = widget.cart;
                                  return SelectPaymentMethod(
                                      totalAmount:
                                          billDetailsMap['grand_total'],
                                      billDetailsMap: billDetailsMap);
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
    );
  }
}
