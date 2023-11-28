import 'package:flutter/material.dart';
import 'package:saasify/configs/app_theme.dart';

import '../../../configs/app_color.dart';
import '../../../configs/app_dimensions.dart';
import '../../../configs/app_spacing.dart';
import '../../../utils/constants/string_constants.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/secondary_button.dart';

class AddStorePopup extends StatelessWidget {
  const AddStorePopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: SizedBox(
            width: kDialogueWidth,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(StringConstants.kAddNewBranch,
                          style: Theme.of(context)
                              .textTheme
                              .xTiniest
                              .copyWith(fontWeight: FontWeight.w700)),
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Align(
                            alignment: Alignment.topRight,
                            child:
                                Icon(Icons.close, color: AppColor.saasifyGrey),
                          )),
                    ],
                  ),
                  const SizedBox(height: spacingMedium),
                  Text(StringConstants.kBranchName,
                      style: Theme.of(context).textTheme.xTiniest),
                  const SizedBox(height: spacingXXSmall),
                  CustomTextField(onTextFieldChanged: (value) {}),
                  const SizedBox(height: spacingSmall),
                  Row(children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(StringConstants.kCurrency,
                              style: Theme.of(context).textTheme.xTiniest),
                          const SizedBox(height: spacingXXSmall),
                          CustomTextField(onTextFieldChanged: (value) {})
                        ])),
                    const SizedBox(width: spacingMedium),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(StringConstants.kLocation,
                            style: Theme.of(context).textTheme.xTiniest),
                        const SizedBox(height: spacingXXSmall),
                        CustomTextField(onTextFieldChanged: (value) {})
                      ],
                    ))
                  ]),
                  Row(
                    children: [
                      Text(StringConstants.kDoYouWantToDeactivateBranch,
                          style: Theme.of(context).textTheme.xTiniest),
                      Switch(
                          activeColor: AppColor.saasifyLightDeepBlue,
                          value: true,
                          onChanged: (value) {
                            // Map productDetails = productList[index].toJson();
                            // productDetails['variant_active'] = value;
                            // context.read<ProductBloc>().add(
                            //     EditProduct(productDetailsMap: productDetails));
                          })
                    ],
                  ),
                  const SizedBox(
                    height: spacingXMedium,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            buttonTitle: StringConstants.kCancel),
                      ),
                      const SizedBox(
                        width: spacingXXSmall,
                      ),
                      Expanded(
                        child: PrimaryButton(
                            onPressed: () {},
                            buttonTitle: StringConstants.kAdd),
                      )
                    ],
                  )
                ])));
  }
}
