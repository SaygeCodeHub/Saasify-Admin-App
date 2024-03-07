import 'package:flutter/material.dart';
import 'package:saasify/data/models/form/form_structure_model.dart';
import 'package:saasify/widgets/formWidgets/label_and_checkbox_widget.dart';
import 'package:saasify/widgets/formWidgets/label_and_datepicker_widget.dart';
import 'package:saasify/widgets/formWidgets/label_and_dropdown_widget.dart';
import 'package:saasify/widgets/formWidgets/label_and_radio_widget.dart';
import 'package:saasify/widgets/formWidgets/label_and_textfield_widget.dart';

class FormWidgetUtil {
  Widget getWidget(Field fieldData) {
    switch (fieldData.fieldType) {
      case 'textField':
        return LabelAndTextFieldWidget(
            label: fieldData.label,
            errorText: fieldData.errorText,
            initialValue: fieldData.userSelection?.textValue,
            maxLines: fieldData.textField?.maxLines,
            isRequired: fieldData.required ?? false,
            hintText: fieldData.placeholder,
            onTextFieldChanged: (value) {
              fieldData.userSelection?.textValue = value;
            });
      case 'datePicker':
        return LabelAndDatePickerWidget(
            label: fieldData.label,
            errorText: fieldData.errorText,
            isRequired: fieldData.required ?? false,
            initialDate: DateTime.tryParse(
                fieldData.userSelection?.userSelectedDate ?? ""),
            firstDate: fieldData.datePickerField?.minDate,
            lastDate: fieldData.datePickerField?.maxDate,
            onTextFieldChanged: (value) {
              fieldData.userSelection?.userSelectedDate = value;
            });
      case 'dropDown':
        return LabelAndDropdownWidget(
            label: fieldData.label,
            errorText: fieldData.errorText,
            isRequired: fieldData.required ?? false,
            initialValue: fieldData.userSelection?.userSelectedOptionId,
            items: fieldData.dropdownField!.options!
                .map((e) =>
                    CustomDropDownItem(label: e.label ?? "", value: e.value))
                .toList(),
            onChanged: (value) {
              fieldData.userSelection?.userSelectedOptionId = value;
            });
      case 'radio':
        return LabelAndRadioWidget(
            label: fieldData.label,
            isRequired: fieldData.required ?? false,
            errorText: fieldData.errorText,
            options: fieldData.radioField!.options!,
            initialValue: fieldData.userSelection?.textValue,
            onChanged: (value) {
              fieldData.userSelection?.textValue = value;
            });
      case 'timePicker':
        return LabelAndDatePickerWidget(
            label: fieldData.label,
            isRequired: fieldData.required ?? false,
            errorText: fieldData.errorText,
            initialDate:
                DateTime(fieldData.userSelection?.userSelectedDate ?? ""),
            firstDate: fieldData.datePickerField?.minDate,
            lastDate: fieldData.datePickerField?.maxDate,
            onTextFieldChanged: (value) {
              fieldData.userSelection?.userSelectedDate = value;
            });
      case 'checkbox':
        return LabelAndCheckBoxWidget(
            options: fieldData.checkboxField!.options!,
            label: fieldData.label,
            errorText: fieldData.errorText,
            isRequired: fieldData.required ?? false,
            initialValue: fieldData.userSelection?.userSelectedOptionId ?? [],
            onChanged: (values) {
              fieldData.userSelection?.userSelectedOptionId = values;
            });
      default:
        return const Text('Unknown Widget');
    }
  }
}
