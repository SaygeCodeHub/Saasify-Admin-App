import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/authentication/authentication_bloc.dart';
import '../../../../bloc/authentication/authentication_event.dart';
import '../../../../bloc/authentication/authentication_state.dart';
import '../../../widgets/custom_dialogs.dart';
import '../../../../utils/progress_bar.dart';
import '../../../home/home_screen.dart';
import '../../../userProfile/user_company_setup_screen.dart';
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
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return PrimaryButton(
          buttonTitle: (!isNewUser) ? 'Sign in' : 'Register',
          onPressed: () {
            if (formKey.currentState!.validate()) {
              authenticationMap['is_sign_in'] = !isNewUser;
              context
                  .read<AuthenticationBloc>()
                  .add(AuthenticateUser(authenticationMap: authenticationMap));
            }
          },
        );
      },
      listener: (context, state) {
        if (state is AuthenticatingUser) {

          ProgressBar.show(context);
        } else if (state is UserAuthenticated) {

          ProgressBar.dismiss(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(userName: state.userName)));
        } else if (state is UserAuthenticatedWithoutCompany) {

          ProgressBar.dismiss(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => UserCompanySetupScreen()));
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
    );
  }
}
