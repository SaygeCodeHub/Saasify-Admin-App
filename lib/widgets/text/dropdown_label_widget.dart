import 'package:flutter/material.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/widgets/custom_dropdown_widget.dart';
import 'package:saasify/widgets/text/label_text_widget.dart';

class DropdownLabelWidget extends StatefulWidget {
  final String? label;
  final double? textFieldSize;
  final String hint;
  final List<CustomDropDownItem> items;
  final dynamic initialValue;
  final String? errorText;
  final ValueChanged<String?> onChanged;

  const DropdownLabelWidget({
    super.key,
    this.label,
    this.textFieldSize,
    this.hint = "",
    required this.items,
    required this.onChanged,
    this.errorText,
    this.initialValue,
  });

  @override
  State<DropdownLabelWidget> createState() => _DropdownLabelWidgetState();
}

class _DropdownLabelWidgetState extends State<DropdownLabelWidget> {
  dynamic selectedValue;

  @override
  void initState() {
    selectedValue = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (widget.label != null) LabelTextWidget(label: widget.label),
      if (widget.label != null) const SizedBox(height: spacingMedium),
      SizedBox(
          width: widget.textFieldSize ?? MediaQuery.sizeOf(context).width,
          child: CustomDropdownButton(
            hint: widget.hint,
            items: widget.items,
            selectedValue: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value;
              });
              widget.onChanged(selectedValue);
            },
          ))
    ]);
  }
}
