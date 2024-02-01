import 'package:flutter/material.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/data/enums/leave_type.dart';
import 'package:saasify/data/models/leaves/load_apply_leave_screen_model.dart';
import 'package:saasify/screens/hrms/leaves/applyLeave/apply_leave_button.dart';
import 'package:saasify/screens/hrms/leaves/applyLeave/apply_leave_screen.dart';
import 'package:saasify/screens/hrms/leaves/widgets/leave_statistic_card.dart';
import 'package:saasify/utils/constants/string_constants.dart';
import 'package:saasify/widgets/layoutWidgets/background_card_widget.dart';
import 'package:saasify/widgets/layoutWidgets/multifield_row.dart';
import 'package:saasify/widgets/text/calendar_popup_label_widget.dart';
import 'package:saasify/widgets/text/dropdown_label_widget.dart';
import 'package:saasify/widgets/text/textfield_label_widget.dart';

class ApplyLeaveWebScreen extends StatelessWidget {
  final bool? isDetailScreen;
  final ApplyLeaveData applyLeaveData;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ApplyLeaveWebScreen(
      {super.key, this.isDetailScreen = false, required this.applyLeaveData});

  @override
  Widget build(BuildContext context) {
    TextEditingController fromDateController = TextEditingController();
    // TextEditingController toDateController = TextEditingController();
    return BackgroundCardWidget(
        childScreen: Form(
      key: formKey,
      child: Column(children: [
        Padding(
            padding: const EdgeInsets.all(spacingMedium),
            child: MultiFieldRow(childrenWidgets: [
              LeaveStatisticsCard(
                  applyLeaveData: applyLeaveData,
                  iconData: Icons.medical_services_outlined,
                  title: StringConstants.kBalanceMedicalLeaves,
                  trailingData: applyLeaveData.medicalLeaves.toString()),
              LeaveStatisticsCard(
                  applyLeaveData: applyLeaveData,
                  iconData: Icons.medical_services_outlined,
                  title: StringConstants.kBalanceCasualLeaves,
                  trailingData: applyLeaveData.casualLeaves.toString())
            ])),
        const Divider(),
        Padding(
            padding: const EdgeInsets.all(spacingMedium),
            child: MultiFieldRow(childrenWidgets: [
              DropdownLabelWidget(
                  label: StringConstants.kLeaveType,
                  hint: StringConstants.kLeaveType,
                  items: List.generate(LeaveTypeEnum.values.length,
                      (index) => LeaveTypeEnum.values.elementAt(index).type),
                  onChanged: (String? value) {
                    dynamic leaveId = LeaveTypeEnum.values
                        .elementAt(LeaveTypeEnum.values
                            .indexWhere((element) => element.type == value))
                        .typeId;
                    ApplyLeaveScreen.leavesMap["leave_type"] = leaveId;
                  }),
              CalendarPopUpLabelWidget(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a date';
                    }
                    return null;
                  },
                  text: StringConstants.kFromDate,
                  hintText: StringConstants.kFromDate,
                  dateController: fromDateController),
              // CalendarPopUpLabelWidget(
              //     text: StringConstants.kToDate,
              //     hintText: StringConstants.kToDate,
              //     dateController: toDateController),
              DropdownLabelWidget(
                  label: StringConstants.kApprovers,
                  hint: StringConstants.kApprovers,
                  items: List.generate(applyLeaveData.approvers.length,
                      (index) => applyLeaveData.approvers[index].approverName),
                  onChanged: (String? value) {
                    dynamic approverId = applyLeaveData
                        .approvers[applyLeaveData.approvers.indexWhere(
                            (element) => element.approverName == value)]
                        .id;
                    ApplyLeaveScreen.leavesMap["Approvers"] = approverId;
                  })
            ])),
        const SizedBox(height: spacingXMedium),
        Padding(
            padding: const EdgeInsets.all(spacingMedium),
            child: TextfieldLabelWidget(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                label: StringConstants.kReasonForLeave,
                maxLines: 5,
                onTextFieldChanged: (text) {
                  ApplyLeaveScreen.leavesMap["leave_reason"] = text;
                })),
        const SizedBox(height: spacingXMedium),
        Padding(
            padding: const EdgeInsets.all(spacingMedium),
            child: Align(
                alignment: Alignment.centerRight,
                child: ApplyLeaveButton(formKey: formKey)))
      ]),
    ));
  }
}
