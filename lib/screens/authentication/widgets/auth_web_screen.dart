import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saasify/screens/authentication/widgets/verify_button.dart';
import '../../../configs/spacing.dart';
import '../../../utils/constants/string_constants.dart';
import '../../../widgets/field_label_widget.dart';

class AuthWebScreen extends StatelessWidget {
  const AuthWebScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        SvgPicture.asset("assets/gradient.svg", fit: BoxFit.fill),
        Padding(
          padding: const EdgeInsets.all(webBodyPadding),
          child: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/saasify_logo.svg",
                        width: 50, height: 50),
                    const SizedBox(height: spacingBetweenTextFieldAndButton),
                    const LabelAndFieldWidget(label: StringConstants.kLoginId),
                    const SizedBox(height: spacingBetweenTextFields),
                    const LabelAndFieldWidget(
                        label: StringConstants.kPassword, obscureText: true),
                    const SizedBox(height: spacingBetweenTextFieldAndButton),
                    AuthVerifyButton()
                  ],
                ),
              )),
        ),
      ],
    );
  }
}