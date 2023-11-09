import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/screens/product/product_list_screen.dart';
import 'package:saasify/utils/constants/string_constants.dart';
import 'package:saasify/widgets/custom_alert_box.dart';
import 'package:saasify/widgets/custom_dropdown.dart';
import 'package:saasify/widgets/custom_text_field.dart';
import 'package:saasify/widgets/secondary_button.dart';
import '../../configs/app_color.dart';
import '../../configs/app_dimensions.dart';
import '../../configs/app_spacing.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/sidebar.dart';

class AddProductScreen extends StatelessWidget {
  static const String routeName = 'AddProductScreen';

  static bool variantToggle = false;

  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(children: [
      const Expanded(child: SideBar(selectedIndex: 1)),
      Expanded(
          flex: 5,
          child: Padding(
              padding: const EdgeInsets.only(
                  top: spacingXXLarge,
                  left: spacingXHuge,
                  right: kHelloSpacingHeight),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        (variantToggle == true)
                            ? StringConstants.kAddVariant
                            : StringConstants.kAddProduct,
                        style: Theme.of(context)
                            .textTheme
                            .xxTiny
                            .copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: spacingXHuge),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text(StringConstants.kCategory,
                                    style: Theme.of(context)
                                        .textTheme
                                        .xxTiniest
                                        .copyWith(fontWeight: FontWeight.w700)),
                                const SizedBox(height: spacingXMedium),
                                const SizedBox(
                                    height: kDropdownHeight,
                                    child: CustomDropdownWidget(
                                        dropdownValue: "",
                                        listItems: [
                                          "Grocery",
                                          "Bakery",
                                          "Clothing",
                                          "Other"
                                        ]))
                              ])),
                          const SizedBox(width: spacingXXHuge),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text(StringConstants.kName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .xxTiniest
                                        .copyWith(fontWeight: FontWeight.w700)),
                                const SizedBox(height: spacingXMedium),
                                CustomTextField(onTextFieldChanged: (value) {})
                              ])),
                          const SizedBox(width: spacingXXHuge),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text(StringConstants.kBrand,
                                    style: Theme.of(context)
                                        .textTheme
                                        .xxTiniest
                                        .copyWith(fontWeight: FontWeight.w700)),
                                const SizedBox(height: spacingXMedium),
                                CustomTextField(onTextFieldChanged: (value) {})
                              ]))
                        ]),
                    const SizedBox(height: spacingHuge),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Wrap(children: [
                                  Text(StringConstants.kProductDescription,
                                      style: Theme.of(context)
                                          .textTheme
                                          .xxTiniest
                                          .copyWith(
                                              fontWeight: FontWeight.w700)),
                                  const SizedBox(width: spacingXSmall),
                                  Text(StringConstants.kMaxLines,
                                      style:
                                          Theme.of(context).textTheme.xTiniest)
                                ]),
                                const SizedBox(height: spacingXMedium),
                                CustomTextField(
                                    maxLines: 5, onTextFieldChanged: (value) {})
                              ])),
                          const SizedBox(width: spacingXXHuge),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text(
                                    (variantToggle == true)
                                        ? StringConstants.kVariantId
                                        : StringConstants.kProductId,
                                    style: Theme.of(context)
                                        .textTheme
                                        .xxTiniest
                                        .copyWith(fontWeight: FontWeight.w700)),
                                const SizedBox(height: spacingXMedium),
                                CustomTextField(
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    onTextFieldChanged: (value) {}),
                                const SizedBox(height: spacingHuge),
                                Row(children: [
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                        Text(StringConstants.kQuantity,
                                            style: Theme.of(context)
                                                .textTheme
                                                .xxTiniest
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w700)),
                                        const SizedBox(height: spacingXMedium),
                                        CustomTextField(
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            onTextFieldChanged: (value) {})
                                      ])),
                                  const SizedBox(width: spacingLarger),
                                  const SizedBox(width: spacingLarger),
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                        Text(StringConstants.kMeasuringQuantity,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .xxTiniest
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w700)),
                                        const SizedBox(height: spacingXMedium),
                                        const SizedBox(
                                            height: kDropdownHeight,
                                            child: CustomDropdownWidget(
                                                dropdownValue: "",
                                                listItems: [
                                                  "kg",
                                                  "l",
                                                  "gm",
                                                  "m"
                                                ]))
                                      ]))
                                ])
                              ])),
                          const SizedBox(width: spacingXXHuge),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Row(children: [
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                        Text(StringConstants.kPrice,
                                            style: Theme.of(context)
                                                .textTheme
                                                .xxTiniest
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w700)),
                                        const SizedBox(height: spacingXMedium),
                                        CustomTextField(
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            onTextFieldChanged: (value) {})
                                      ])),
                                  const SizedBox(width: spacingLarger),
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                        Text(StringConstants.kDiscountPercent,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .xxTiniest
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w700)),
                                        const SizedBox(height: spacingXMedium),
                                        CustomTextField(
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            onTextFieldChanged: (value) {})
                                      ]))
                                ]),
                                const SizedBox(height: spacingHuge),
                                Row(children: [
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                        Text(StringConstants.kStock,
                                            style: Theme.of(context)
                                                .textTheme
                                                .xxTiniest
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w700)),
                                        const SizedBox(height: spacingXMedium),
                                        CustomTextField(
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            onTextFieldChanged: (value) {})
                                      ])),
                                  const SizedBox(width: spacingLarger),
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                        Text(StringConstants.kLowStock,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .xxTiniest
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w700)),
                                        const SizedBox(height: spacingXMedium),
                                        CustomTextField(
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            onTextFieldChanged: (value) {})
                                      ]))
                                ])
                              ]))
                        ]),
                    Row(children: [
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Row(children: [
                              Text(StringConstants.kUploadImages,
                                  style: Theme.of(context)
                                      .textTheme
                                      .xxTiniest
                                      .copyWith(fontWeight: FontWeight.w700)),
                              const SizedBox(width: spacingXSmall),
                              Text(StringConstants.kMinimumOneImage,
                                  style: Theme.of(context).textTheme.xTiniest)
                            ]),
                            const SizedBox(height: spacingLarge),
                            Row(
                                children: List.generate(
                                    6,
                                    (index) => Expanded(
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: spacingXXHuge),
                                            child: AspectRatio(
                                                aspectRatio: 1.2,
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        color: AppColor
                                                            .saasifyLighterGrey,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                spacingSmall))))))))
                          ]))
                    ]),
                    const SizedBox(height: kGeneralButtonHeight),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      PrimaryButton(
                          onPressed: () {},
                          buttonWidth: spacingXXXXHuge,
                          buttonTitle: StringConstants.kSave),
                      const SizedBox(width: spacingLarge),
                      SecondaryButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => Expanded(
                                      child: CustomAlertDialog(
                                        title: (variantToggle == true)
                                            ? StringConstants.kNewVariantAdded
                                            : StringConstants.kNewProductAdded,
                                        message: (variantToggle == true)
                                            ? StringConstants
                                                .kContinueAddingNewVariant
                                            : StringConstants
                                                .kContinueAddingVariant,
                                        primaryButtonTitle: (variantToggle ==
                                                true)
                                            ? StringConstants
                                                .kAddNewVariantButton
                                            : StringConstants.kAddVariantButton,
                                        checkMarkVisible: true,
                                        secondaryButtonTitle:
                                            StringConstants.kNo,
                                        primaryOnPressed: () {
                                          variantToggle = true;
                                          Navigator.pushReplacementNamed(
                                              context,
                                              AddProductScreen.routeName);
                                        },
                                        secondaryOnPressed: () {
                                          Navigator.pushReplacementNamed(
                                              context,
                                              ProductListScreen.routeName);
                                        },
                                        crossIconVisible: false,
                                        sizedBoxVisible: true,
                                      ),
                                    ));
                          },
                          buttonWidth: spacingXXXXHuge,
                          buttonTitle: StringConstants.kPublish),
                    ])
                  ])))
    ]));
  }
}
