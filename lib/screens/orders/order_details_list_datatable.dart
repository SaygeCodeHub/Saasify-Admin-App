import 'package:flutter/material.dart';
import 'package:saasify/configs/app_theme.dart';

import '../../configs/app_dimensions.dart';
import '../../configs/app_spacing.dart';
import '../../data/models/orders/fetch_orders_model.dart';
import '../../utils/constants/string_constants.dart';

class OrderDetailsListDataTable extends StatelessWidget {
  final OrdersData ordersData;

  const OrderDetailsListDataTable({super.key, required this.ordersData});

  @override
  Widget build(BuildContext context) {
    return ListView(shrinkWrap: true, children: <Widget>[
      DataTable(
          columnSpacing: 0,
          horizontalMargin: 20,
          showCheckboxColumn: true,
          headingRowHeight: 50,
          dataRowMaxHeight: 50,
          columns: [
            DataColumn(
                label: Text(StringConstants.kName,
                    style: Theme.of(context)
                        .textTheme
                        .xTiniest
                        .copyWith(fontWeight: FontWeight.w600))),
            DataColumn(
                label: Expanded(
              child: Text(StringConstants.kCategory,
                  style: Theme.of(context)
                      .textTheme
                      .xTiniest
                      .copyWith(fontWeight: FontWeight.w600)),
            )),
            DataColumn(
                label: Expanded(
              child: Text(StringConstants.kBrand,
                  style: Theme.of(context)
                      .textTheme
                      .xTiniest
                      .copyWith(fontWeight: FontWeight.w600)),
            )),
            DataColumn(
                label: Expanded(
                    child: Center(
                        child: Text(StringConstants.kUnitPrice,
                            style: Theme.of(context)
                                .textTheme
                                .xTiniest
                                .copyWith(fontWeight: FontWeight.w600))))),
            DataColumn(
                label: Expanded(
                    child: Center(
              child: Text(StringConstants.kQuantity,
                  style: Theme.of(context)
                      .textTheme
                      .xTiniest
                      .copyWith(fontWeight: FontWeight.w600)),
            ))),
            DataColumn(
                label: Expanded(
              child: Center(
                child: Text(StringConstants.kDiscount,
                    style: Theme.of(context)
                        .textTheme
                        .xTiniest
                        .copyWith(fontWeight: FontWeight.w600)),
              ),
            )),
            DataColumn(
                label: Expanded(
                    child: Center(
              child: Text(StringConstants.kDiscountedPrice,
                  style: Theme.of(context)
                      .textTheme
                      .xTiniest
                      .copyWith(fontWeight: FontWeight.w600)),
            )))
          ],
          rows: List.generate(
              ordersData.itemsOrdered.length,
              (index) => DataRow(cells: [
                    DataCell(Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            SizedBox(
                                height: kProductImageHeight,
                                width: kProductImageWidth,
                                child: Image.network(ordersData
                                    .itemsOrdered[index].images[0]
                                    .toString())),
                            const SizedBox(width: spacingXXSmall),
                            Text(ordersData.itemsOrdered[index].productName,
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.xxTiniest),
                          ],
                        ))),
                    DataCell(Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            ordersData.itemsOrdered[index].categoryName
                                    .trim()
                                    .substring(0, 1)
                                    .toUpperCase() +
                                ordersData.itemsOrdered[index].categoryName
                                    .trim()
                                    .substring(
                                      1,
                                    )
                                    .toLowerCase(),
                            style: Theme.of(context).textTheme.xxTiniest))),
                    DataCell(Align(
                        alignment: Alignment.centerLeft,
                        child: Text(ordersData.itemsOrdered[index].brandName,
                            style: Theme.of(context).textTheme.xxTiniest))),
                    DataCell(Align(
                        alignment: Alignment.center,
                        child: Text(
                            ordersData.itemsOrdered[index].cost.toString(),
                            style: Theme.of(context).textTheme.xxTiniest))),
                    DataCell(Align(
                        alignment: Alignment.center,
                        child: Text(
                            ordersData.itemsOrdered[index].count.toString(),
                            style: Theme.of(context).textTheme.xxTiniest))),
                    DataCell(Align(
                        alignment: Alignment.center,
                        child: Text(
                            (ordersData.itemsOrdered[index].cost -
                                    (ordersData.itemsOrdered[index].cost) *
                                        (ordersData.itemsOrdered[index]
                                                .discountPercent /
                                            100))
                                .toString(),
                            style: Theme.of(context).textTheme.xxTiniest))),
                    DataCell(Align(
                        alignment: Alignment.center,
                        child: Text(ordersData.totalAmount.toString(),
                            style: Theme.of(context).textTheme.xxTiniest)))
                  ])))
    ]);
  }
}