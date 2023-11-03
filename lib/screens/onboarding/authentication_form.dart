import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saasify/bloc/authentication/authentication_bloc.dart';
import 'package:saasify/bloc/authentication/authentication_event.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/screens/onboarding/company_screen.dart';
import '../../configs/app_color.dart';
import '../../configs/app_dimensions.dart';
import '../../utils/constants/string_constants.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';

class AuthenticationBody extends StatelessWidget {
  final bool isLogin;
  final bool passwordHidden;

  AuthenticationBody({
    super.key,
    required this.isLogin,
    required this.passwordHidden,
  });

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(
              left: spacingXXXHuge, right: spacingXXXHuge, top: kButtonHeight),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset("assets/SaaSify.svg",
                    height: kGeneralButtonHeight, width: kLogoWidth),
                const SizedBox(height: spacingStandard),
                (isLogin)
                    ? Text(StringConstants.kWelcomeBack,
                        style: Theme.of(context)
                            .textTheme
                            .xxTiny
                            .copyWith(fontWeight: FontWeight.w700))
                    : Text(StringConstants.kHello,
                        style: Theme.of(context)
                            .textTheme
                            .xxTiny
                            .copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: kHelloSpacingHeight),
                Visibility(
                    visible: !isLogin,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(StringConstants.kName,
                              style: Theme.of(context)
                                  .textTheme
                                  .tiniest
                                  .copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: spacingMedium),
                          CustomTextField(
                              hintText: StringConstants.kWhatsYourName,
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .xTiniest
                                  .copyWith(fontWeight: FontWeight.w500),
                              keyboardType: TextInputType.text,
                              onTextFieldChanged: (value) {}),
                          const SizedBox(height: spacingXXHuge),
                        ])),
                Text(StringConstants.kContactNumber,
                    style: Theme.of(context)
                        .textTheme
                        .tiniest
                        .copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: spacingMedium),
                CustomTextField(
                    hintText: StringConstants.kAddYourContactNumber,
                    hintStyle: Theme.of(context)
                        .textTheme
                        .xTiniest
                        .copyWith(fontWeight: FontWeight.w500),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return StringConstants.kPleaseAddYourContactNumber;
                      }
                      return null;
                    },
                    maxLength: 10,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onTextFieldChanged: (value) {}),
                const SizedBox(height: spacingXXHuge),
                PrimaryButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pushNamed(context, CompanyForm.routeName);
                    }
                  },
                  buttonWidth: double.maxFinite,
                  buttonTitle: (isLogin) ? 'Login' : 'SignUp',
                ),
                const SizedBox(height: spacingXXLarge),
                Row(children: [
                  Text(StringConstants.kHaveAnAccountYet,
                      style: Theme.of(context)
                          .textTheme
                          .tiniest
                          .copyWith(fontWeight: FontWeight.w400)),
                  const SizedBox(width: 4),
                  (isLogin)
                      ? TextButton(
                          onPressed: () {
                            context.read<AuthenticationBloc>().add(
                                SwitchAuthentication(
                                    passwordHidden: passwordHidden,
                                    isLogin: isLogin));
                          },
                          child: Text(StringConstants.kSingUp,
                              style: Theme.of(context)
                                  .textTheme
                                  .tiniest
                                  .copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColor.saasifyDarkBlue)))
                      : TextButton(
                          onPressed: () {
                            context.read<AuthenticationBloc>().add(
                                SwitchAuthentication(
                                    passwordHidden: passwordHidden,
                                    isLogin: isLogin));
                          },
                          child: Text(StringConstants.kLogin,
                              style: Theme.of(context)
                                  .textTheme
                                  .tiniest
                                  .copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColor.saasifyDarkBlue)))
                ])
              ]),
        ));
  }
}
