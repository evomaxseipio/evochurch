

import 'package:evochurch/src/utils/utils_index.dart';
import 'package:flutter/material.dart';
Widget chartCardAmount(
  BuildContext context, {
  required String title,
  required String amount,
  required Gradient gradient,
  required IconData icon,
}) {
  return Card(
    elevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    child: Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(icon,
              size: Responsive.isMobile(context) || Responsive.isTablet(context)
                  ? 40
                  : 60,
              color: Colors.white),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatCurrency(amount.toString()),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.isMobile(context) ||
                                Responsive.isTablet(context)
                            ? 20
                            : 24,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
