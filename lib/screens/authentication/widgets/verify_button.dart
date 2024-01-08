import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/authentication/authentication_event.dart';
import '../../../bloc/authentication/authentication_bloc.dart';
import '../../../bloc/authentication/authentication_states.dart';
import '../../../utils/constants/string_constants.dart';
import '../../../widgets/primary_button.dart';

class AuthVerifyButton extends StatelessWidget {
  const AuthVerifyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationStates>(
      builder: (context, state) {
        if (state is TextFieldChanged) {
          return PrimaryButton(
              onPressed: (context.read<AuthenticationBloc>().loginButtonEnabled)
                  ? () {
                      context.read<AuthenticationBloc>().add(SignIn());
                    }
                  : null,
              buttonTitle: StringConstants.kVerify);
        } else if (state is AuthenticationLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const PrimaryButton(
              onPressed: null, buttonTitle: StringConstants.kVerify);
        }
      },
    );
  }
}
