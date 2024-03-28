import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/authentication/authentication_bloc.dart';
import '../../../../bloc/authentication/authentication_event.dart';
import '../../../../bloc/authentication/authentication_state.dart';
import '../../../../utils/custom_dialogs.dart';
import '../../../../utils/progress_bar.dart';
import '../../../companyDetails/register_company_screen.dart';
import '../../../home/home_screen.dart';
import '../../../widgets/buttons/primary_button.dart';

class VerifyButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Map authenticationMap;
  final bool isNewUser;
  const VerifyButton(
      {super.key,
      required this.formKey,
      required this.authenticationMap,
      required this.isNewUser});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticatingUser) {
          ProgressBar.show(context);
        } else if (state is UserAuthenticated) {
          ProgressBar.dismiss(context);
          if (!isNewUser) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialogs().showSuccessDialog(
                      context, 'User signed-in successfully',
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen())));
                });
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialogs().showSuccessDialog(
                      context, 'User registered successfully!',
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const RegisterCompanyWebScreen())));
                });
          }
        } else if (state is UserNotAuthenticated) {
          ProgressBar.dismiss(context);
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomDialogs().showAlertDialog(
                    context, state.errorMessage,
                    onPressed: () => Navigator.pop(context));
              });
        }
      },
      child: PrimaryButton(
        buttonTitle: (!isNewUser) ? 'Sign in' : 'Register',
        onPressed: () {
          if (formKey.currentState!.validate()) {
            print(authenticationMap);
            authenticationMap['is_sign_in'] = !isNewUser;
            context
                .read<AuthenticationBloc>()
                .add(AuthenticateUser(authenticationMap: authenticationMap));
          }
        },
      ),
    );
  }
}
