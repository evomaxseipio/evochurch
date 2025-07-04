// Responsive row builder that switches between Row and Column based on screen width
import 'package:flutter/material.dart';

Widget buildResponsiveRow(List<Widget> children) {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        // For small screen (mobile), use Column
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children
              .expand((widget) => [widget, const SizedBox(height: 12)])
              .toList()
            ..removeLast(),
        );
      } else {
        // For larger screens, use Row
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children
              .expand((widget) =>
                  [Expanded(child: widget), const SizedBox(width: 10)])
              .toList()
            ..removeLast(),
        );
      }
    },
  );
}
