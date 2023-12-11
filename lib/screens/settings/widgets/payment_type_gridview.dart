import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/payment/payments_bloc.dart';
import 'package:saasify/bloc/payment/payments_event.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/data/models/payment/fetch_all_payment_method.dart';
import 'package:saasify/widgets/alert_dialogue_box.dart';
import '../../../configs/app_color.dart';
import '../../../configs/app_dimensions.dart';
import '../../../configs/app_spacing.dart';
import '../../../utils/constants/string_constants.dart';
import '../../../widgets/toggle_switch_widget.dart';
import 'add_payment_method_popup.dart';

class PaymentTypeGridView extends StatelessWidget {
  const PaymentTypeGridView({
    super.key,
    required this.paymentType,
  });

  final List<PaymentData> paymentType;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        itemCount: paymentType.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              height: spacingStandard,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kCircularRadius),
                  boxShadow: const [
                    BoxShadow(
                        color: AppColor.saasifyLightPaleGrey, blurRadius: 5.0)
                  ],
                  color: AppColor.saasifyWhite),
              child: Padding(
                  padding: const EdgeInsets.all(kCircularRadius),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(paymentType[index].paymentName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .tiniest
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppColor.saasifyDarkGrey)),
                              const SizedBox(height: spacingXMedium),
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: (paymentType[index].isActive)
                                          ? AppColor.saasifyLighterGreen
                                          : AppColor.saasifyLighterRed),
                                  child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.circle,
                                            size: 8,
                                            color: (paymentType[index].isActive)
                                                ? AppColor.saasifyGreen
                                                : AppColor.saasifyRed),
                                        const SizedBox(width: spacingXSmall),
                                        Text(
                                            (paymentType[index].isActive)
                                                ? StringConstants
                                                    .kPaymentTypeEnabled
                                                : StringConstants
                                                    .kPaymentTypeDisabled,
                                            style: Theme.of(context)
                                                .textTheme
                                                .xxTiniest
                                                .copyWith(
                                                    color:
                                                    (paymentType[index].isActive)
                                                        ? AppColor.saasifyGreen
                                                        : AppColor.saasifyRed))
                                      ]))
                            ]),
                        Row(children: [
                          ToggleSwitchWidget(
                              value: paymentType[index].isActive,
                              onChanged: (value) {
                                Map paymentTypeDetailsMap = paymentType[index].toJson();
                                paymentTypeDetailsMap["is_active"] = value;
                                context.read<PaymentBloc>().add(EditPayment(paymentDetailsMap: paymentTypeDetailsMap));
                              }),
                          const SizedBox(width: spacingXSmall),
                          PopupMenuButton(
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) =>
                                                AddNewPaymentTypePopup(savePaymentDetailsMap: paymentType[index].toJson(), isEdit: true));
                                      },
                                      child: const Text(StringConstants.kEdit)),
                                  PopupMenuItem(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) =>
                                            AlertDialogueBox(
                                                title: StringConstants.kWarning,
                                                message: "Do you want to Delete payment method - ${paymentType[index].paymentName}",
                                                primaryButtonTitle: StringConstants.kConfirm,
                                                primaryOnPressed: (){
                                                  Navigator.pop(context);
                                                  context.read<PaymentBloc>().add(DeletePayment(paymentId: paymentType[index].paymentId));
                                                }));
                                      },
                                      child: const Text(StringConstants.kDelete)),
                                ];
                              },
                              child: const Icon(Icons.more_vert))
                        ]),
                      ])));
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 4,
            crossAxisSpacing: spacingLarge,
            mainAxisSpacing: spacingLarge));
  }
}
