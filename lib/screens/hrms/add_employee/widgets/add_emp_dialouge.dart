import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/employee/employee_bloc.dart';
import 'package:saasify/bloc/employee/employee_event.dart';
import 'package:saasify/bloc/employee/employee_states.dart';
import 'package:saasify/configs/app_colors.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/data/enums/employee_type_enum.dart';
import 'package:saasify/screens/hrms/add_employee/add_employee_screen.dart';
import 'package:saasify/screens/hrms/hrms_dashboard_screen.dart';
import 'package:saasify/utils/constants/string_constants.dart';
import 'package:saasify/utils/progress_bar.dart';
import 'package:saasify/widgets/alertDialogs/error_alert_dialog.dart';
import 'package:saasify/widgets/alertDialogs/success_alert_dialog.dart';
import 'package:saasify/widgets/buttons/primary_button.dart';
import 'package:saasify/widgets/text/field_label_widget.dart';
import 'package:saasify/widgets/userInput/custom_checkbox.dart';

showAddEmployeeDialog(BuildContext context) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AlertDialog alert = AlertDialog(
      actions: [
        BlocListener<EmployeeBloc, EmployeeStates>(
          listener: (context, state) {
            if (state is InvitingEmployee) {
              return ProgressBar.show(context);
            }
            if (state is InvitationSent) {
              ProgressBar.dismiss(context);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SuccessAlertDialog(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, HRMSDashboardScreen.routeName);
                      },
                      description:
                          '${state.inviteEmployeeModel.message} on ${context.read<EmployeeBloc>().inviteDetails['user_email']} ✅');
                },
              );
            }
            if (state is InvitingFailed) {
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
          child: Padding(
            padding: const EdgeInsets.all(spacingStandard),
            child: PrimaryButton(
                backgroundColor: AppColors.darkBlue,
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    context
                        .read<EmployeeBloc>()
                        .add(InviteEmployee(inviteDetails: {
                          "user_email": context
                              .read<EmployeeBloc>()
                              .inviteDetails['user_email'],
                          "roles": [3],
                          "approvers": []
                        }));
                  }
                },
                buttonWidth: spacingXXXHuge,
                buttonTitle: 'Invite'),
          ),
        )
      ],
      title: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.30,
          child:
              OverflowBar(alignment: MainAxisAlignment.spaceBetween, children: [
            const Text(StringConstants.kInviteMember),
            InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, AddEmployeeScreen.routeName);
              },
              child: Text("Add Manually",
                  style: Theme.of(context)
                      .textTheme
                      .drawerModuleTextStyle
                      .copyWith(color: AppColors.orange)),
            )
          ])),
      content: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.30,
          child: Form(
            key: formKey,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: spacingHuge),
                  LabelAndFieldWidget(
                      label: StringConstants.kEmailAddress,
                      onTextFieldChanged: (value) {
                        context
                            .read<EmployeeBloc>()
                            .inviteDetails['user_email'] = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return StringConstants.kFieldCannotBeEmpty;
                        }
                        return null;
                      }),
                  const SizedBox(height: spacingHuge),
                  Text(StringConstants.kAssignRole,
                      style: Theme.of(context).textTheme.userNameTextStyle),
                  const SizedBox(height: spacingMedium),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.30,
                    child: SingleChildScrollView(
                      child: Column(
                          children: List.generate(
                              EmployeeType.values.length,
                              (index) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: spacingSmall),
                                  child: CustomCheckbox(
                                      checkBoxTitle:
                                          EmployeeType.values[index].name)))),
                    ),
                  )
                ]),
          )));
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}
