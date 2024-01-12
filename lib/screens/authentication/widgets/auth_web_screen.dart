import 'package:flutter/material.dart';
import 'package:saasify/screens/authentication/commonMethods/textfield_methods.dart';
import 'package:saasify/screens/authentication/widgets/verify_button.dart';
import '../../../configs/spacing.dart';
import '../../../utils/constants/string_constants.dart';
import '../../../widgets/field_label_widget.dart';
import '../../../widgets/saasifyLogo.dart';

class AuthWebScreen extends StatelessWidget {
  const AuthWebScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SaasifyLogo(),
              const SizedBox(height: spacingBetweenTextFieldAndButton),
              LabelAndFieldWidget(
                  label: StringConstants.kEmailAddress,
                  onTextFieldChanged: (value) {
                    onEmailChanged(value, context);
                  }),
              const SizedBox(height: spacingBetweenTextFields),
              LabelAndFieldWidget(
                  label: StringConstants.kPassword,
                  onTextFieldChanged: (value) {
                    onPasswordChanged(value, context);
                  },
                  obscureText: true),
              const SizedBox(height: spacingBetweenTextFieldAndButton),
              const AuthVerifyButton()
            ],
          ),
        ));
  }
}
