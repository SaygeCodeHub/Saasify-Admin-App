import 'package:flutter/material.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/models/pos_model.dart';
import 'package:saasify/screens/billing/select_payment_method.dart';
import 'package:saasify/services/service_locator.dart';

class SettleBillSection extends StatelessWidget {
  final List<PosModel> posDataList;
  final BillDetails billDetails = getIt<BillDetails>();

  SettleBillSection({super.key, required this.posDataList});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: ElevatedButton(
                onPressed: () {}, child: const Text('Print KOT'))),
        const SizedBox(width: spacingSmall),
        Expanded(
            child: ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return SelectPaymentMethod(
                            totalAmount: billDetails.grandTotal!,
                            posDataList: posDataList);
                      });
                },
                child: const Text('Settle Bill'))),
      ],
    );
  }
}
