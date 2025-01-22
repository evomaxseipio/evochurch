import 'dart:async';

import 'package:evochurch/main.dart';
import 'package:evochurch/src/constants/grid_columns.dart';
import 'package:evochurch/src/model/transaction_model.dart';
import 'package:evochurch/src/utils/utils_index.dart';
import 'package:evochurch/src/view/finances/widgets/add_transaction_modal.dart';
import 'package:evochurch/src/view/finances/widgets/status_container.dart';
import 'package:evochurch/src/view_model/finance_view_model.dart';
import 'package:evochurch/src/widgets/paginateDataTable/paginated_data_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class TransactionListView extends HookWidget {
  const TransactionListView({super.key});

  @override
  Widget build(BuildContext context) {
    // final viewModel = Provider.of<FinanceViewModel>(context, listen: false);

    final isLoading = useState<bool>(true);

    void _handletransacAction(
        BuildContext context, String action, TransactionModel transac) {
      switch (action) {
        case 'edit':
          debugPrint('Editing transac: ${transac.fundName}');
          debugPrint('  - transac ID: ${transac.transactionDescription}');
          // Show edit dialog
           callAddTransactionModal(
            context,
            'Edit',
            transaction: transac,
          );
          break;

        case 'donations':
          // Handle donations
          debugPrint('Adding donations for: ${transac.transactionId}');
          // Example:
          // showDialog(
          //   context: context,
          //   builder: (context) => AddDonationDialog(transac: transac),
          // );
          break;
        case 'delete':
          // Show delete confirmation
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Confirm Delete'),
              content:
                  Text('Are you sure you want to delete ${transac.fundName}?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Handle delete
                    // viewModel.deletetransac(transac.transacId);
                    Navigator.pop(context);
                  },
                  child:
                      const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
          break;
      }
    }

    return Scaffold(
      body: Consumer<FinanceViewModel>(
            builder: (context, viewmodel, child) {
              if (viewmodel.isLoadingTransactions) {
                return const Center(child: CircularProgressIndicator());
              }

              if (viewmodel.error != null) {
                return Text('Error: ${viewmodel.error}');
              }
             
              if (viewmodel.transactionsList.isEmpty) {
                return const Center(
                  child: Text('No transactions found'),
                );
              }
              return SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomPaginatedTable<TransactionModel>(
                        title: 'Transaction List',
                        data: viewmodel.transactionsList,
                        columns: transactionColumns,
                        getCells: (transac) => [
                          DataCell(Text(transac.fundName)),
                          DataCell(Text(transac.transactionDescription)),
                          DataCell(Align(
                              alignment: Alignment.center,
                              child: Text(formatCurrency(
                                  transac.transactionAmount.toString())))),
                          DataCell(statusButton(status: transac.transactionStatus)),
                          // DataCell(Text(transac.transactionStatus)),
                          DataCell(Text(transac.createdBy)),
                          DataCell(
                              Text(formatDate(transac.transactionDate.toString()))),
                          DataCell(Text(transac.authorizedBy!)),
                          DataCell(Text(formatDate(
                                      transac.authorizationDate.toString()) ==
                                  formatDate(DateTime.now().toString())
                              ? '-'
                              : formatDate(transac.authorizationDate.toString()))),
                        ],
                        filterFunction: (transac, query) {
                          final lowercaseQuery = query.toLowerCase();
                          return transac.fundName
                                  .toLowerCase()
                                  .contains(lowercaseQuery) ||
                              transac.transactionDescription!
                                  .toLowerCase()
                                  .contains(lowercaseQuery);
                        },
                        onRowTap: (transac) {
                          // Handle transac selection
                          debugPrint('Selected transac: ${transac.fundName}');
                        },
                        actionMenuBuilder: (context, transac) => [
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: ListTile(
                              leading: Icon(Icons.edit_outlined),
                              title: Text('Edit transac'),
                              dense: true,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'donations',
                            child: ListTile(
                              leading: Icon(Icons.attach_money_outlined),
                              title: Text('Add Donations'),
                              dense: true,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                          const PopupMenuDivider(),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: ListTile(
                              leading: Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              title: Text(
                                'Delete transac',
                                style: TextStyle(color: Colors.red),
                              ),
                              dense: true,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                        ],
                        onActionSelected: (action, transac) {
                          _handletransacAction(context, action, transac);
                        },
                        tableButtons: [
                          CustomTableButton(
                            text: 'Add transac',
                            icon: const Icon(
                              FontAwesomeIcons.handHoldingDollar,
                              size: 22,
                            ),
                            onPressed: () {
                              debugPrint('Add transac');
                              callAddTransactionModal(context, 'New',);
                            },
                          ),
                          CustomTableButton(
                            text: 'Print',
                            icon: const Icon(Icons.print),
                            onPressed: () async {
                              debugPrint('Print PDF');
                              // final viewModel = FinanceViewModel();
                              // final user = await viewModel.updateUserMetaData();
                              // debugPrint(user.toString());
                            },
                          ),
                          CustomTableButton(
                            text: 'Export',
                            icon: const Icon(Icons.download),
                            onPressed: () {
                              debugPrint('debugPrint PDF');
                            },
                          ),
                          // Add more buttons as needed
                        ],
                      ),
                    ],
                  ),
                );
            }
          ),
    );
  }
}
