import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/pos/billing_bloc.dart';
import 'package:saasify/bloc/pos/billing_event.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/utils/constants/string_constants.dart';
import 'package:saasify/widgets/custom_alert_box.dart';
import '../../../configs/app_color.dart';
import '../../../configs/app_spacing.dart';
import '../../../widgets/primary_button.dart';
import 'payment_dialogue.dart';

class BillingSectionFooter extends StatelessWidget {
  const BillingSectionFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Center(
          child: InkWell(
              onTap: () {
                if (context.read<BillingBloc>().customer.customerContact !=
                    '') {
                  context.read<BillingBloc>().add(AddOrderToPayLater());
                } else {
                  showDialog(
                      context: context,
                      builder: (context) => CustomAlertDialog(
                          title: StringConstants.kWarning,
                          message: 'Mobile No haas not been added',
                          primaryButtonTitle: StringConstants.kOk,
                          primaryOnPressed: () {
                            Navigator.pop(context);
                          }));
                }
              },
              child: Text(
                StringConstants.kPayLater,
                style: Theme.of(context).textTheme.tiniest.copyWith(
                      color: AppColor.saasifyGreyBlue,
                      decoration: TextDecoration.underline,
                    ),
              ))),
      const SizedBox(height: spacingMedium),
      PrimaryButton(
        onPressed: () {
          if (context.read<BillingBloc>().customer.customerContact != '') {
            showDialog(
                context: context,
                builder: (context) => const PaymentDialogue());
          } else {
            showDialog(
                context: context,
                builder: (context) => CustomAlertDialog(
                    title: StringConstants.kWarning,
                    message: 'Mobile No haas not been added',
                    primaryButtonTitle: StringConstants.kOk,
                    primaryOnPressed: () {
                      Navigator.pop(context);
                    }));
          }
        },
        buttonTitle: StringConstants.kSettleBill,
      )
    ]);
  }
}
