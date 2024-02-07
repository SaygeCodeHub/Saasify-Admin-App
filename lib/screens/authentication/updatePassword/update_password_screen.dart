import 'package:flutter/material.dart';
import 'package:saasify/screens/authentication/updatePassword/update_password_mobile_screen.dart';
import 'package:saasify/screens/authentication/updatePassword/update_password_web_screen.dart';
import 'package:saasify/widgets/layoutWidgets/responsive_layout.dart';

class UpdatePasswordScreen extends StatelessWidget {
  static const routeName = 'UpdatePasswordScreen';

  UpdatePasswordScreen({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
            body: Form(
                key: formKey,
                child: ResponsiveLayout(
                    mobileBody: UpdatePasswordMobileScreen(formKey: formKey),
                    desktopBody: UpdatePasswordWebScreen(formKey: formKey)))));
  }
}