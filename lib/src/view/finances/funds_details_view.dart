import 'package:evochurch/src/constants/grid_columns.dart';
import 'package:evochurch/src/model/fund_model.dart';
import 'package:evochurch/src/model/transaction_with_header__details_model.dart';
import 'package:evochurch/src/model/transaction_model.dart';
import 'package:evochurch/src/utils/utils_index.dart';
import 'package:evochurch/src/view/finances/widgets/add_transaction_modal.dart';
import 'package:evochurch/src/view/finances/widgets/fund_header_details.dart';
import 'package:evochurch/src/view/finances/widgets/status_container.dart';
import 'package:evochurch/src/view_model/index_view_model.dart';
import 'package:evochurch/src/widgets/button/button.dart';
import 'package:evochurch/src/widgets/loading.dart';
import 'package:evochurch/src/widgets/paginateDataTable/paginated_data_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class FundsDetailsView extends HookWidget {
  final FinanceViewModel financeViewModel;

  final FundModel fundModel;
  const FundsDetailsView(
      {super.key, required this.financeViewModel, required this.fundModel});

  @override
  Widget build(BuildContext context) {
    // final financeViewModel = Provider.of<FinanceViewModel>(context, listen: true);

    final fundsHeader = useState<HeaderDetails?>(null);
    final transactions = useState<List<TransactionModel>>([]);
    final isLoading = useState<bool>(true);

    // Fetching data
    fetchInitialData() async {
      await financeViewModel.getTransactionList(fundModel.fundId);
      transactions.value = financeViewModel.transactionsList;
      fundsHeader.value = financeViewModel.headerDetails;
      isLoading.value = false;
    }

    useEffect(() {
      // Fetch initial data
      Future.microtask(() {
        fetchInitialData();
      });

      // Suscribe to data changes notifications
      final transactionSubscription =
          financeViewModel.transactionStreamController.listen((_) {
        debugPrint('Transaction Changes Notification');
        fetchInitialData();
      });

      // Clean up the subscription when the widget is disposed
      return () {
        transactionSubscription.cancel();
      };
    }, [financeViewModel, financeViewModel.transactionStreamController]);

    return Scaffold(
        appBar: AppBar(
          title: Text('Transacciones ${fundModel.fundName}'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: EvoButton(
                text: 'Back to List of Funds',
                icon: const Icon(Icons.arrow_back_ios_sharp),
                onPressed: () => context.go('/finances/funds'),
              ),
            ),
          ],
        ),
        body: isLoading.value
            ? simpleLoadingUI(context, 'Loading Fund Details')
            : fundsHeader.value == null
                ? const Center(child: Text('No fund details found'))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        CustomPaginatedTable<TransactionModel>(
                          title: 'Transaction List',
                          header: Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: BalancePaymentCard(
                              totalAmount: fundsHeader.value!.totalContributions
                                  .toString(),
                              totalAmountTransactions: fundsHeader
                                  .value!.approvedTransactions
                                  .toString(),
                              totalAmountPendingTransactions: fundsHeader
                                  .value!.pendingTransactions
                                  .toString(),
                              totalMinusPendingTransactions: fundsHeader
                                  .value!.totalMinusPendingTransactions
                                  .toString(),
                              installments:
                                  fundsHeader.value!.totalTransactions,
                            ),
                          ),
                          data: transactions.value,
                          columns: transactionColumns
                              .where((column) => column.field != 'fundName')
                              .toList(),
                          getCells: (transaction) =>
                              _buildDataCells(transaction),
                          filterFunction: _filterTransactions,
                          onRowTap: (transaction) {
                            debugPrint(
                                'Selected transaction: ${transaction.fundName}');
                          },
                          actionMenuBuilder: (context, transaction) => [
                            const PopupMenuItem<String>(
                              value: 'edit',
                              child: ListTile(
                                leading: Icon(Icons.edit_outlined),
                                title: Text('Edit Transaction'),
                                dense: true,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'donations',
                              child: ListTile(
                                leading: Icon(Icons.attach_money_outlined),
                                title: Text('Add Contributions'),
                                dense: true,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                            const PopupMenuDivider(),
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: ListTile(
                                leading: Icon(Icons.delete_outline,
                                    color: Colors.red),
                                title: Text('Delete Transaction',
                                    style: TextStyle(color: Colors.red)),
                                dense: true,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                          ],
                          onActionSelected: (action, transaction) {
                            _handleTransactionAction(
                                context, action, financeViewModel, transaction);
                          },
                          tableButtons: [
                            CustomTableButton(
                              text: 'Edit Funds',
                              icon: const Icon(Icons.edit_note_outlined,
                                  size: 28),
                              onPressed: () => callAddTransactionModal(
                                  context, 'New', financeViewModel,
                                  fund_id: fundModel.fundId),
                            ),
                            CustomTableButton(
                              text: 'Add Transaction',
                              icon: const Icon(
                                  FontAwesomeIcons.handHoldingDollar,
                                  size: 22),
                              onPressed: () => callAddTransactionModal(
                                  context, 'New', financeViewModel,
                                  fund_id: fundModel.fundId),
                            ),
                            CustomTableButton(
                              text: 'Print',
                              icon: const Icon(Icons.print),
                              onPressed: () => debugPrint('Print PDF'),
                            ),
                            CustomTableButton(
                              text: 'Export',
                              icon: const Icon(Icons.download),
                              onPressed: () => debugPrint('Export PDF'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ));
  }

  List<DataCell> _buildDataCells(TransactionModel transaction) {
    return [
      DataCell(Text(transaction.transactionDescription), placeholder: true),
      DataCell(Align(
        alignment: Alignment.center,
        child: Text(formatCurrency(transaction.transactionAmount.toString())),
      )),
      DataCell(statusButton(status: transaction.transactionStatus)),
      DataCell(Text(transaction.createdBy)),
      DataCell(Text(formatDate(transaction.transactionDate.toString()))),
      DataCell(Text(transaction.authorizedBy ?? '-')),
      DataCell(Text(_formatAuthorizationDate(transaction.authorizationDate))),
    ];
  }

  String _formatAuthorizationDate(DateTime? date) {
    if (date == null) return '-';
    final formattedDate = formatDate(date.toString());
    return formattedDate == formatDate(DateTime.now().toString())
        ? '-'
        : formattedDate;
  }

  bool _filterTransactions(TransactionModel transaction, String query) {
    final lowercaseQuery = query.toLowerCase();
    return transaction.fundName.toLowerCase().contains(lowercaseQuery) ||
        transaction.transactionDescription
            .toLowerCase()
            .contains(lowercaseQuery) ||
        transaction.transactionStatus.toLowerCase().contains(lowercaseQuery) ||
        transaction.transactionAmount
            .toString()
            .toLowerCase()
            .contains(lowercaseQuery) ||
        transaction.createdBy.toLowerCase().contains(lowercaseQuery) ||
        transaction.transactionDate
            .toString()
            .toLowerCase()
            .contains(lowercaseQuery) ||
        (transaction.authorizedBy?.toLowerCase() ?? '')
            .contains(lowercaseQuery) ||
        (transaction.authorizationDate?.toString().toLowerCase() ?? '')
            .contains(lowercaseQuery);
  }

  void _handleTransactionAction(BuildContext context, String action,
      FinanceViewModel financeViewModel, TransactionModel transaction) {
    switch (action) {
      case 'edit':
        callAddTransactionModal(context, 'Edit', financeViewModel,
            transaction: transaction);
        break;
      case 'delete':
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: Text(
                'Are you sure you want to delete ${transaction.fundName}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // Handle delete
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
}
