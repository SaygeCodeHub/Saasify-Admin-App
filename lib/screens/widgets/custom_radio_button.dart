import 'package:flutter/material.dart';
import 'package:saasify/configs/app_theme.dart';

import '../../configs/app_spacing.dart';

class CustomRadioButton<T> extends StatefulWidget {
  final String? label;
  final List<T> options;
  final T? selectedValue;
  final ValueChanged<T?> onValueChanged;

  const CustomRadioButton({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onValueChanged,
    this.label,
  });

  @override
  CustomRadioButtonState<T> createState() => CustomRadioButtonState<T>();
}

class CustomRadioButtonState<T> extends State<CustomRadioButton<T>> {
  T? _groupValue;

  @override
  void initState() {
    super.initState();
    _groupValue = widget.selectedValue;
  }

  void _handleRadioValueChange(T? value) {
    setState(() {
      _groupValue = value;
    });
    widget.onValueChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(widget.label!,
              style: Theme.of(context).textTheme.fieldLabelTextStyle),
        if (widget.label != null) const SizedBox(height: spacingSmall),
        Row(
          children: widget.options
              .map((option) => Expanded(
                    child: ListTile(
                      title: Text(option.toString()),
                      leading: Radio<T>(
                        value: option,
                        groupValue: _groupValue,
                        onChanged: _handleRadioValueChange,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
