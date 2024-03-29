import 'package:flutter/material.dart';

class ResponsiveFormRow extends StatelessWidget {
  final List<Widget> formWidgets;
  final double spacingStandard;

  const ResponsiveFormRow({
    super.key,
    required this.formWidgets,
    this.spacingStandard = 16.0, // Default spacing, adjust as needed
  });

  @override
  Widget build(BuildContext context) {
    int widgetsPerRow = ResponsiveLayoutUtils.widgetsPerRow(context);
    List<Widget> rows = [];

    for (int i = 0; i < formWidgets.length; i += widgetsPerRow) {
      List<Widget> rowChildren = [];
      for (int j = 0; j < widgetsPerRow && i + j < formWidgets.length; j++) {
        rowChildren.add(Expanded(child: formWidgets[i + j]));
        if (j < widgetsPerRow - 1) {
          rowChildren.add(SizedBox(width: spacingStandard));
        }
      }
      rows.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rowChildren,
      ));
      rows.add(SizedBox(height: spacingStandard));
    }

    return Column(children: rows);
  }
}

class ResponsiveLayoutUtils {
  static const double mobileBreakPoint = 600;
  static const double tabBreakPoint = 1024;

  static int widgetsPerRow(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < mobileBreakPoint) {
      return 1;
    } else if (screenWidth >= mobileBreakPoint && screenWidth < tabBreakPoint) {
      return 2;
    } else {
      return 3;
    }
  }
}
