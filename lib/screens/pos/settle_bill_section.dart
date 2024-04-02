import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/pos/pos_bloc.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/models/cart_model.dart';
import 'package:saasify/screens/billing/select_payment_method.dart';

class SettleBillSection extends StatelessWidget {
  final List<PosModel> posDataList;
  const SettleBillSection({super.key, required this.posDataList});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child:
              ElevatedButton(onPressed: () {}, child: const Text('Print KOT')),
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
                                .read<PosBloc>()
                                .billDetailsMap['grand_total'],
                            billDetailsMap:
                                context.read<PosBloc>().billDetailsMap,
                            posDataList: posDataList);
                      });
                },
                child: const Text('Settle Bill'))),
      ],
    );
  }
}
