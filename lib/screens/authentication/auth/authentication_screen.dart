import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saasify/screens/authentication/auth/widgets/verify_button.dart';
import 'package:saasify/screens/widgets/label_and_textfield_widget.dart';
import 'package:saasify/utils/authentication_validators.dart';
import 'package:saasify/utils/constants/string_constants.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/app_spacing.dart';

class AuthenticationScreen extends StatelessWidget {
  static const routeName = 'AuthenticationScreen';

  final bool isSignIn;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Map<dynamic, dynamic> authenticationMap = {};

  AuthenticationScreen({super.key, this.isSignIn = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(spacingStandard),
          child: Form(
            key: formKey,
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.height * 0.50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.20),
                    SvgPicture.asset(
                      'assets/saasify_logo.svg',
                      semanticsLabel: 'Saasify Logo',
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    if (!isSignIn)
                      LabelAndTextFieldWidget(
                        prefixIcon: const Icon(Icons.person),
                        label: StringConstants.kName,
                        isRequired: true,
                        onTextFieldChanged: (value) {
                          authenticationMap['name'] = value!;
                        },
                      ),
                    if (!isSignIn) const SizedBox(height: spacingMedium),
                    LabelAndTextFieldWidget(
                      prefixIcon: const Icon(Icons.email_outlined),
                      label: StringConstants.kEmailAddress,
                      isRequired: true,
                      onTextFieldChanged: (value) {
                        authenticationMap['email'] = value!;
                      },
                    ),
                    const SizedBox(height: spacingMedium),
                    LabelAndTextFieldWidget(
                      prefixIcon: const Icon(Icons.lock_outline),
                      label: StringConstants.kPassword,
                      isRequired: true,
                      onTextFieldChanged: (value) {
                        authenticationMap['password'] = value!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        } else if (AuthenticationValidators()
                            .isValidPassword(value)) {
                          return 'Password must be at least 6 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    VerifyButton(
                      formKey: formKey,
                      authenticationMap: authenticationMap,
                      isNewUser: !isSignIn,
                    ),
                    const SizedBox(height: spacingMedium),
                    Center(
                      child: InkWell(
                        onTap: () {
                          authenticationMap['is_sign_in'] = isSignIn;
                          Navigator.of(context).pushReplacement(
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  AuthenticationScreen(isSignIn: !isSignIn),
                              transitionDuration: Duration.zero, // No animation
                            ),
                          );
                        },
                        child: Text(
                          isSignIn
                              ? 'Create a new account. Register!'
                              : 'Already have an account? Sign in!',
                          style: const TextStyle(color: AppColors.blue),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
