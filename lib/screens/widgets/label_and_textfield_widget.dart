import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saasify/configs/app_theme.dart';

import '../../configs/app_colors.dart';
import '../../configs/app_spacing.dart';
import '../../utils/constants/string_constants.dart';

class LabelAndTextFieldWidget extends StatelessWidget {
  final String? label;
  final String? hintText;
  final String? errorText;
  final void Function()? onTap;
  final bool isRequired;
  final void Function(String?)? onTextFieldChanged;
  final bool readOnly;
  final String? Function(String?)? validator;
  final bool? enabled;
  final TextEditingController? textFieldController;
  final bool obscureText;
  final Widget? suffix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final dynamic initialValue;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;

  const LabelAndTextFieldWidget({
    super.key,
    this.label,
    this.hintText,
    this.errorText,
    this.onTextFieldChanged,
    this.readOnly = false,
    this.enabled,
    this.textFieldController,
    this.obscureText = false,
    this.suffix,
    this.prefixIcon,
    this.suffixIcon,
    this.initialValue,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
    this.isRequired = false,
    this.onTap,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(label!, style: Theme.of(context).textTheme.fieldLabelTextStyle),
        if (label != null) const SizedBox(height: spacingSmall),
        TextFormField(
          key: key,
          onTap: onTap,
          enabled: enabled,
          readOnly: readOnly,
          obscuringCharacter: "*",
          obscureText: obscureText,
          onChanged: onTextFieldChanged,
          controller: textFieldController,
          maxLines: maxLines ?? 1,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          cursorWidth: 0.6,
          validator: (value) {
            if ((value == null || value.isEmpty) && isRequired) {
              return errorText ?? StringConstants.kFieldCannotBeEmpty;
            }
            if (validator != null) {
              if (!(value == null || value.isEmpty)) {
                return validator!(value);
              }
            }
            return null;
          },
          style: const TextStyle(color: AppColors.black),
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          ),
        ),
      ],
    );
  }
}
