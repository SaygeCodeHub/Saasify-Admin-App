import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:saasify/configs/app_spacing.dart';

class ResponsiveForm extends StatelessWidget {
  final List<Widget> formWidgets;
  final Widget widget;

  const ResponsiveForm(
      {super.key, required this.formWidgets, required this.widget});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isTablet = constraints.maxWidth >= 600;
      final isMobile = constraints.maxWidth < 600;
      const isWeb = kIsWeb; // Assuming this doesn't change based on context
      int widgetsPerRow = isTablet
          ? 2
          : isMobile
              ? 1
              : isWeb
                  ? 3
                  : 1;

      List<Widget> rows = [];
      for (int i = 0; i < formWidgets.length; i += widgetsPerRow) {
        List<Widget> rowChildren = [];
        for (int j = 0; j < widgetsPerRow && i + j < formWidgets.length; j++) {
          rowChildren.add(Expanded(child: formWidgets[i + j]));
          if (j < widgetsPerRow - 1) {
            rowChildren.add(const SizedBox(
                width: spacingStandard)); // Replace with your spacing value
          }
        }
        rows.add(Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rowChildren,
        ));
        rows.add(const SizedBox(
            height: spacingStandard)); // Replace with your spacing value
      }

      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [widget, ...rows]);
    });
  }
}
