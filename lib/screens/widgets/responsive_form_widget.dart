import 'package:flutter/material.dart';
import 'package:saasify/configs/app_spacing.dart';

class ResponsiveFormFieldRow extends StatelessWidget {
  final List<Widget> childrenWidgets;
  final double spacing;

  const ResponsiveFormFieldRow({
    super.key,
    required this.childrenWidgets,
    this.spacing = spacingXSmall,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 600) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: childrenWidgets
                .map((child) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: spacing),
                        child: child,
                      ),
                    ))
                .toList(),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: childrenWidgets
                .map((child) => Padding(
                      padding: EdgeInsets.only(bottom: spacing),
                      child: child,
                    ))
                .toList(),
          );
        }
      },
    );
  }
}
