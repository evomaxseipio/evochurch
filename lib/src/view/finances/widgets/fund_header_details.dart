import 'package:evochurch/src/constants/constant_index.dart';
import 'package:evochurch/src/utils/utils_index.dart';
import 'package:flutter/material.dart';

class BalancePaymentCard extends StatelessWidget {
  final String totalAmount;
  final String totalAmountTransactions;
  final String totalAmountPendingTransactions;
  final String totalMinusPendingTransactions;
  final int installments;

  const BalancePaymentCard({
    super.key,
    required this.totalAmount,
    required this.totalAmountTransactions,
    required this.totalAmountPendingTransactions,
    required this.totalMinusPendingTransactions,
    required this.installments,
  });

  @override
  Widget build(BuildContext context) {
    // Access the current theme
    final theme = Theme.of(context);
    // final context.isDarkMode = theme.brightness == Brightness.dark;

    return Card(
      color: context.isDarkMode
          ? Colors.blueGrey[400]!.withOpacity(0.5)
          : EvoColor.white, // Use theme card color
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(children: [
              Icon(
                Icons.account_balance,
                color: context.isDarkMode
                    ? Colors.grey[400]
                    : Colors.blueGrey[900], // Adjust icon color for dark mode
              ),
              EvoBox.w10,
              Text(
                'BALANCE DE CUENTA',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.list_alt_rounded,
                        color: theme.colorScheme.primary,
                        size: 20), // Use theme primary color
                    EvoBox.w10,
                    Text(
                      'Total Transacciones: $installments',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontSize: 18), // Use theme text style
                    ),
                  ],
                ),
              ),
            ]),
            const Divider(),
            totalAmountFundDetailsCard(
              context,
              totalAmount,
              totalAmountTransactions,
              totalAmountPendingTransactions,
              totalMinusPendingTransactions,
              cardColor: context.isDarkMode
                  ? Colors.blueGrey[400]!.withOpacity(0.5)
                  : EvoColor.white, // Use theme card color
            ),
            const Divider(),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       EvoBox.w10,
            //       EvoButton(
            //         text: 'Editar',
            //         icon: const Icon(Icons.edit_outlined),
            //         onPressed: () {
            //           // callLoanTicketsListModal(context);
            //         },
            //       ),
            //       EvoBox.w10,
            //       EvoButton(
            //         text: 'Imprimir',
            //         icon: const Icon(Icons.print_outlined),
            //         onPressed: () {
            //           // context.router.push(PrintBlankDocument(
            //           //     title: "Impresion Pagos PDF",
            //           //     imagePath: IconlyBroken.printer));
            //         },
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

Card totalAmountFundDetailsCard(
  BuildContext context, // Add BuildContext as a parameter
  String totalAmount,
  String totalAmountTransactions,
  String totalAmountPendingTransactions,
  String totalMinusPendingTransactions, {
  Color? cardColor,
}) {
  // Access the current theme
  final theme = Theme.of(context);

  return Card(
    elevation: 2,
    color: cardColor ??
        (context.isDarkMode
            ? theme.cardColor
            : EvoColor.boxgreylight), // Use theme card color
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    shadowColor: context.isDarkMode
        ? theme.shadowColor
        : EvoColor.boxgreylight, // Use theme shadow color
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: customColumnTitle(
              'Balance General',
              formatCurrency(totalAmount),
              size: 16,
              fontWeight: FontWeight.bold,
              valueColor: EvoColor.whatsApp, // Use theme primary color
            ),
          ),
          EvoBox.w16,
          Expanded(
            child: customColumnTitle('Transacciones Ejecutadas',
                formatCurrency(totalAmountTransactions),
                size: 16,
                fontWeight: FontWeight.bold,
                valueColor: context.isDarkMode
                    ? EvoColor.redLight
                    : EvoColor.redDarkChartColor // Use theme error color
                ),
          ),
          EvoBox.w16,
          Expanded(
            child: customColumnTitle(
              'Transacciones en Transito',
              formatCurrency(totalAmountPendingTransactions),
              size: 16,
              fontWeight: FontWeight.bold,
              valueColor: context.isDarkMode
                  ? theme.colorScheme.secondary
                  : EvoColor.warningDark, // Use theme secondary color
            ),
          ),
          EvoBox.w16,
          Expanded(
            child: customColumnTitle(
              'Balance - Transacciones Transito',
              formatCurrency(totalMinusPendingTransactions),
              size: 16,
              fontWeight: FontWeight.bold,
              valueColor: context.isDarkMode
                  ? theme.colorScheme.tertiary
                  : EvoColor.infoDark, // Use theme tertiary color
            ),
          ),
        ],
      ),
    ),
  );
}
