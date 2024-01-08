import 'package:flutter/material.dart';
import 'package:saasify/configs/app_theme.dart';
import '../configs/app_colors.dart';
import '../configs/app_spacing.dart';

class LabelAndFieldWidget extends StatelessWidget {
  final String? label;
  final String? hintText;
  final void Function(String)? onTextFieldChanged;
  final bool? readOnly;
  final bool? enabled;
  final TextEditingController? controller;
  final bool? obscureText;
  final Widget? suffix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? autofocus;
  final dynamic initialValue;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry? contentPadding;

  const LabelAndFieldWidget({
    super.key,
    this.label,
    this.hintText,
    this.onTextFieldChanged,
    this.readOnly,
    this.enabled,
    this.controller,
    this.obscureText,
    this.suffix,
    this.prefixIcon,
    this.suffixIcon,
    this.autofocus,
    this.initialValue,
    this.keyboardType,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    if (initialValue != null && controller.text.isEmpty) {
      controller.text = initialValue.toString();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label!,
            style: Theme.of(context)
                .textTheme
                .tiniest
                .copyWith(fontWeight: FontWeight.w700),
          ),
        if (label != null) const SizedBox(height: spacingMedium),
        TextFormField(
          obscureText: obscureText ?? false,
          cursorColor: AppColors.orange,
          decoration: InputDecoration(
            suffix: suffix,
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            counterText: "",
          ),
          validator: (_) {
            return null;
          },
          readOnly: readOnly ?? false,
          controller: controller,
          onChanged: onTextFieldChanged,
          enabled: enabled ?? true,
          autofocus: autofocus ?? false,
          keyboardType: keyboardType,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}