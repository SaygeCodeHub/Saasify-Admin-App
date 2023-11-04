import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/screens/onboarding/widgets/company_list_gridview.dart';
import 'package:saasify/utils/constants/string_constants.dart';
import '../../configs/app_color.dart';
import '../../configs/app_dimensions.dart';
import '../../configs/app_spacing.dart';
import '../../widgets/custom_text_field.dart';

class CompanyListScreen extends StatelessWidget {
  CompanyListScreen({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
          flex: 4,
          child: Form(
              key: formKey,
              child: Padding(
                  padding: const EdgeInsets.only(
                      left: spacingXXXHuge,
                      right: spacingXXXHuge,
                      top: spacingXXXHuge),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset("assets/SaaSify.svg",
                            height: kGeneralButtonHeight, width: kLogoWidth),
                        const SizedBox(height: spacingXXHuge),
                        Text(StringConstants.kCompanies,
                            style: Theme.of(context)
                                .textTheme
                                .xxTiny
                                .copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: spacingMedium),
                        CustomTextField(
                            hintText: StringConstants.kSearchCompanies,
                            hintStyle: Theme.of(context)
                                .textTheme
                                .xTiniest
                                .copyWith(fontWeight: FontWeight.w500),
                            keyboardType: TextInputType.text,
                            onTextFieldChanged: (value) {}),
                        const SizedBox(height: spacingXXHuge),
                        const CompanyListGridview()
                      ])))),
      Expanded(
          flex: 6,
          child: Container(
            color: AppColor.saasifyLightDeepBlue,
          ))
    ]));
  }
}