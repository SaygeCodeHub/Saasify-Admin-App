import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/resetPassword/reset_password_bloc.dart';
import 'package:saasify/bloc/resetPassword/reset_password_events.dart';
import 'package:saasify/bloc/resetPassword/reset_password_states.dart';
import 'package:saasify/screens/authentication/auth/auhentication_screen.dart';
import 'package:saasify/utils/constants/string_constants.dart';
import 'package:saasify/utils/progress_bar.dart';
import 'package:saasify/widgets/alertDialogs/error_alert_dialog.dart';
import 'package:saasify/widgets/alertDialogs/success_alert_dialog.dart';
import 'package:saasify/widgets/buttons/primary_button.dart';

class UpdatePasswordButton extends StatelessWidget {
  const UpdatePasswordButton({super.key, required this.formKey});
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocListener<ResetPasswordBloc, ResetPasswordStates>(
          listener: (context, state) {
            if (state is PasswordUpdating) {
              return ProgressBar.show(context);
            }
            if (state is PasswordUpdated) {
              ProgressBar.dismiss(context);
              showDialog(
                  context: context,
                  builder: (context) {
                    return SuccessAlertDialog(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, AuthenticationScreen.routeName);
                        },
                        description: state.updatePasswordModel.message);
                  });
            }
            if (state is PasswordUpdatingFailed) {
              ProgressBar.dismiss(context);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ErrorAlertDialog(
                      description: state.errorMessage.toString());
                },
              );
            }
          },
          child: PrimaryButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  context.read<ResetPasswordBloc>().add(UpdatePasswordLink());
                }
              },
              buttonTitle: StringConstants.kUpdatePassword),
        )
      ],
    );
  }
}