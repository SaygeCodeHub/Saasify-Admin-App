import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:saasify/bloc/employee/employee_bloc.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/data/generalData/india_states_and_cities.dart';
import 'package:saasify/utils/constants/string_constants.dart';
import 'package:saasify/widgets/custom_dropdown_widget.dart';
import 'package:saasify/widgets/form/form_input_fields.dart';
import 'package:saasify/widgets/layoutWidgets/multifield_row.dart';
import 'package:saasify/widgets/text/dropdown_label_widget.dart';
import 'package:saasify/widgets/text/field_label_widget.dart';

class EmployeeBasicDetails extends StatelessWidget {
  const EmployeeBasicDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          MultiFieldRow(
            childrenWidgets: [
              LabelAndFieldWidget(
                  isRequired: true,
                  label: StringConstants.kFirstName,
                  initialValue: context
                      .read<EmployeeBloc>()
                      .employeeDetails['personal_info']['first_name'],
                  onTextFieldChanged: (value) {
                    context
                        .read<EmployeeBloc>()
                        .employeeDetails['personal_info']['first_name'] = value;
                  }),
              LabelAndFieldWidget(
                  label: StringConstants.kMiddleName,
                  initialValue: context
                      .read<EmployeeBloc>()
                      .employeeDetails['personal_info']['middle_name'],
                  onTextFieldChanged: (value) {
                    context
                            .read<EmployeeBloc>()
                            .employeeDetails['personal_info']['middle_name'] =
                        value;
                  }),
              LabelAndFieldWidget(
                  isRequired: true,
                  label: StringConstants.kLastName,
                  initialValue: context
                      .read<EmployeeBloc>()
                      .employeeDetails['personal_info']['last_name'],
                  onTextFieldChanged: (value) {
                    context
                        .read<EmployeeBloc>()
                        .employeeDetails['personal_info']['last_name'] = value;
                  }),
            ],
          ),
          const SizedBox(height: spacingLarge),
          MultiFieldRow(
            childrenWidgets: [
              EmailTextField(
                  isRequired: true,
                  initialValue: context
                      .read<EmployeeBloc>()
                      .employeeDetails['personal_info']['user_email'],
                  onTextFieldChanged: (value) {
                    context
                        .read<EmployeeBloc>()
                        .employeeDetails['personal_info']['user_email'] = value;
                  }),
              ContactTextField(
                  label: StringConstants.kMobileNumber,
                  initialValue: context
                      .read<EmployeeBloc>()
                      .employeeDetails['personal_info']['user_mobile'],
                  onTextFieldChanged: (value) {
                    context
                            .read<EmployeeBloc>()
                            .employeeDetails['personal_info']['user_mobile'] =
                        value;
                  }),
              ContactTextField(
                  label: StringConstants.kAlternateMobileNumber,
                  initialValue: context
                      .read<EmployeeBloc>()
                      .employeeDetails['personal_info']['alternate_mobile'],
                  onTextFieldChanged: (value) {
                    context
                            .read<EmployeeBloc>()
                            .employeeDetails['personal_info']
                        ['alternate_mobile'] = value;
                  }),
            ],
          ),
          const SizedBox(height: spacingLarge),
          MultiFieldRow(
            childrenWidgets: [
              DatePickerField(
                  label: StringConstants.kDateOfBirth,
                  initialDate: DateFormat('dd-mm-yyyy').tryParse(context
                          .read<EmployeeBloc>()
                          .employeeDetails['personal_info']['date_of_birth'] ??
                      ""),
                  onTextFieldChanged: (value) {
                    context
                            .read<EmployeeBloc>()
                            .employeeDetails['personal_info']['date_of_birth'] =
                        value;
                  }),
              NumberTextField(
                  label: StringConstants.kAge,
                  initialValue: context
                      .read<EmployeeBloc>()
                      .employeeDetails['personal_info']['age'],
                  maxLength: 3,
                  onTextFieldChanged: (value) {
                    context
                        .read<EmployeeBloc>()
                        .employeeDetails['personal_info']['age'] = value;
                  }),
              DropdownLabelWidget(
                label: StringConstants.kGender,
                initialValue: context
                    .read<EmployeeBloc>()
                    .employeeDetails['personal_info']['gender'],
                onChanged: (value) {
                  context.read<EmployeeBloc>().employeeDetails['personal_info']
                      ['gender'] = value;
                },
                hint: '',
                items: stringListToDropdownItems(const ["Male", "Female"]),
              ),
              DropdownLabelWidget(
                label: StringConstants.kNationality,
                initialValue: context
                    .read<EmployeeBloc>()
                    .employeeDetails['personal_info']['nationality'],
                onChanged: (value) {
                  context.read<EmployeeBloc>().employeeDetails['personal_info']
                      ['nationality'] = value;
                },
                hint: '',
                items: stringListToDropdownItems(const ["Indian"]),
              ),
              DropdownLabelWidget(
                label: StringConstants.kMaritalStatus,
                initialValue: context
                    .read<EmployeeBloc>()
                    .employeeDetails['personal_info']['marital_status'],
                onChanged: (value) {
                  context.read<EmployeeBloc>().employeeDetails['personal_info']
                      ['marital_status'] = value;
                },
                hint: '',
                items: stringListToDropdownItems(
                    const ["Married", "Unmarried", "Widowed"]),
              ),
            ],
          ),
          const SizedBox(height: spacingLarge),
          MultiFieldRow(
            childrenWidgets: [
              LabelAndFieldWidget(
                  label: StringConstants.kCurrentAddress,
                  initialValue: context
                      .read<EmployeeBloc>()
                      .employeeDetails['personal_info']['current_address'],
                  maxLines: 5,
                  onTextFieldChanged: (value) {
                    context
                            .read<EmployeeBloc>()
                            .employeeDetails['personal_info']
                        ['current_address'] = value;
                  }),
              LabelAndFieldWidget(
                  label: StringConstants.kPermanentAddress,
                  initialValue: context
                      .read<EmployeeBloc>()
                      .employeeDetails['personal_info']['permanent_address'],
                  maxLines: 5,
                  onTextFieldChanged: (value) {
                    context
                            .read<EmployeeBloc>()
                            .employeeDetails['personal_info']
                        ['permanent_address'] = value;
                  }),
            ],
          ),
          const SizedBox(height: spacingLarge),
          MultiFieldRow(
            childrenWidgets: [
              DropdownLabelWidget(
                label: StringConstants.kCity,
                initialValue: context
                    .read<EmployeeBloc>()
                    .employeeDetails['personal_info']['city'],
                hint: '',
                items: [],
                onChanged: (String? value) {
                  context.read<EmployeeBloc>().employeeDetails['personal_info']
                      ['city'] = value;
                },
              ),
              DropdownLabelWidget(
                label: StringConstants.kState,
                initialValue: context
                    .read<EmployeeBloc>()
                    .employeeDetails['personal_info']['state'],
                hint: '',
                items: stringListToDropdownItems(indiaStatesAndCities
                    .map((e) => e['state'])
                    .toList()
                    .cast<String>()),
                onChanged: (String? value) {
                  context.read<EmployeeBloc>().employeeDetails['personal_info']
                      ['state'] = value;
                  context.read<EmployeeBloc>().employeeDetails['personal_info']
                      ['city'] = null;
                },
              ),
              NumberTextField(
                  label: StringConstants.kPinCode,
                  initialValue: context
                      .read<EmployeeBloc>()
                      .employeeDetails['personal_info']['pin_code'],
                  maxLength: 6,
                  onTextFieldChanged: (value) {
                    context
                        .read<EmployeeBloc>()
                        .employeeDetails['personal_info']['pin_code'] = value;
                  }),
            ],
          ),
        ],
      ),
    );
  }
}

List<CustomDropDownItem> stringListToDropdownItems(List<String> list) {
  return list
      .map((e) => CustomDropDownItem(label: e, value: e))
      .toList()
      .cast<CustomDropDownItem>();
}
