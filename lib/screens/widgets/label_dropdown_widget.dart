import 'package:flutter/material.dart';
import 'package:saasify/configs/app_dimensions.dart';
import 'package:saasify/configs/app_theme.dart';

import '../../configs/app_spacing.dart';

class LabelDropdownWidget<T> extends StatefulWidget {
  final String label;
  final T? initialValue;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry contentPadding;
  final double borderRadius;

  const LabelDropdownWidget(
      {super.key,
      required this.label,
      this.initialValue,
      required this.items,
      required this.onChanged,
      this.labelStyle,
      this.contentPadding = const EdgeInsets.symmetric(
          vertical: kLabelDropdownVerticalPadding,
          horizontal: kLabelDropdownHorizontalPadding),
      this.borderRadius = kLabelDropdownBorderRadius});

  @override
  LabelDropdownWidgetState<T> createState() => LabelDropdownWidgetState<T>();
}

class LabelDropdownWidgetState<T> extends State<LabelDropdownWidget<T>> {
  T? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: widget.labelStyle ??
                Theme.of(context).textTheme.fieldLabelTextStyle),
        const SizedBox(height: spacingSmall),
        DropdownButtonHideUnderline(
          child: DropdownButtonFormField<T>(
            decoration: InputDecoration(
              contentPadding: widget.contentPadding,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
            ),
            value: selectedValue,
            hint: Text("Select ${widget.label}"),
            items: widget.items,
            onChanged: (T? newValue) {
              setState(() {
                selectedValue = newValue;
              });
              widget.onChanged(newValue);
            },
          ),
        ),
      ],
    );
  }
}
