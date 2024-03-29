import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/screens/authentication/auth/authentication_screen.dart';
import 'package:saasify/utils/progress_bar.dart';
import '../../../bloc/authentication/authentication_bloc.dart';
import '../../../bloc/authentication/authentication_event.dart';
import '../../../bloc/authentication/authentication_state.dart';
import '../../../configs/app_colors.dart';
import '../../widgets/custom_dialogs.dart';

class LogOutWidget extends StatelessWidget {
  const LogOutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is LoggingOutOfSession) {
          ProgressBar.show(context);
        } else if (state is LoggedOutOfSession) {
          ProgressBar.dismiss(context);
          Navigator.pop(context);
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  AuthenticationScreen(),
              transitionDuration: Duration.zero, // No animation
            ),
          );
        } else if (state is LoggingOutFailed) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialogs().showAlertDialog(
                  context, 'Failed to logout. Please try again.',
                  onPressed: () => Navigator.pop(context));
            },
          );
        }
      },
      child: IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialogs().showAlertDialog(
                context,
                'Are you sure you want to logout?',
                onPressed: () {
                  context.read<AuthenticationBloc>().add(LogOutOfSession());
                },
              );
            },
          );
        },
        icon: const Icon(
          Icons.logout,
          color: AppColors.red,
        ),
      ),
    );
  }
}
