import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/resetPassword/reset_password_bloc.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/screens/authentication/updatePassword/reset_password_button.dart';
import 'package:saasify/utils/constants/string_constants.dart';
import 'package:saasify/widgets/profile/saasifyLogo.dart';
import 'package:saasify/widgets/text/field_label_widget.dart';

class ForgotPasswordWebScreen extends StatelessWidget {
  const ForgotPasswordWebScreen({super.key, required this.formKey});
  final GlobalKey<FormState> formKey;

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
            const Text(
              "Forgot your password? It happens to the best of us. Enter your email, and we'll send a rescue team to bring it back.",
            ),
            const SizedBox(height: spacingBetweenTextFields),
            LabelAndFieldWidget(
                label: StringConstants.kEmailAddress,
                onTextFieldChanged: (value) {
                  context
                      .read<ResetPasswordBloc>()
                      .userInputAuthenticationMap['email'] = value;
                }),
            const SizedBox(height: spacingBetweenTextFieldAndButton),
            UpdatePasswordButton(formKey: formKey)
          ],
        ),
      ),
    );
  }
}
