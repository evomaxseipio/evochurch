import 'package:evochurch/src/constants/grid_columns.dart';
import 'package:evochurch/src/constants/icons.dart';
import 'package:evochurch/src/model/transaction_model.dart';
import 'package:evochurch/src/model/transaction_with_header__details_model.dart';
import 'package:evochurch/src/utils/utils_index.dart';
import 'package:evochurch/src/view/finances/widgets/add_transaction_modal.dart';
import 'package:evochurch/src/view/finances/widgets/fund_header_details.dart';
import 'package:evochurch/src/view/finances/widgets/status_container.dart';
import 'package:evochurch/src/view/message.dart';
import 'package:evochurch/src/view_model/finance_view_model.dart';
import 'package:evochurch/src/widgets/loading.dart';
import 'package:evochurch/src/widgets/paginateDataTable/paginated_data_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class TransactionListView extends HookWidget {
  const TransactionListView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<FinanceViewModel>(context, listen: true);
    final fundsHeader = useState<HeaderDetails?>(null);
    final transactions = useState<List<TransactionModel>>([]);
    final isLoading = useState<bool>(false);

    // Fetch initial data
    getTransactions() async {
      isLoading.value = true;
      await viewModel.getTransactionList(null);
      transactions.value = viewModel.transactionsList;
      fundsHeader.value = viewModel.headerDetails;
      isLoading.value = false;
    }

    useEffect(() {
      // Fetch initial data
      Future.microtask(() {
        getTransactions();
      });

      // Suscribe to data changes notifications
      final transactionSubscription =
          viewModel.transactionStreamController.listen((_) {
        debugPrint('Transaction Changes Notification');
        getTransactions();
      });

      return () {
        // Cleanup
        transactionSubscription.cancel();
        debugPrint('Transaction Changes Notification Cancelled');
      };
    }, [viewModel, viewModel.transactionStreamController]);

    void _handletransacAction(BuildContext context, String action,
        FinanceViewModel fundsViewModel, TransactionModel transac) async {
      switch (action) {
        case 'edit':
          debugPrint('Editing transac: ${transac.fundName}');
          debugPrint('  - transac ID: ${transac.transactionDescription}');
          viewModel.setFundSelected = null;
          // Show edit dialog
          callAddTransactionModal(
            context,
            'Edit',
            fundsViewModel,
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
          CupertinoModalOptions.show(
            context: context,
            title: 'Delete transac',
            message:
                'Are you sure you want to delete ${transac.transactionDescription}?',
            modalType: ModalTypeMessage.deletion,
            actions: [
              ModalAction(
                text: 'Cancel',
                isDefaultAction: true,
                onPressed: () => false,
              ),
              ModalAction(
                text: 'Delete',
                isDestructiveAction: true,
                onPressed: () {
                  // Handle delete
                  viewModel.deleteTransaction(transac.transactionId).then((_) {
                    /// Delay notifying listeners to avoid calling setState during build
                    Future.delayed(Duration.zero, () {
                      viewModel.getTransactionList(null);
                      viewModel.notifyDataChanged();
                    });

                    // Show success message
                    if (!context.mounted) return;
                    CupertinoModalOptions.show(
                      context: context,
                      title: 'Success',
                      message: 'Transaction deleted successfully.',
                      modalType: ModalTypeMessage.success,
                    );
                  });
                  return false;
                },
              ),
            ],
          );        
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transactions List',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: isLoading.value
          ? simpleLoadingUI(context, 'Loading transactions...')
          : viewModel.transactionsList.isEmpty
              ? const Center(child: Text('No transactions found'))
              : viewModel.error != null
                  ? const Center(
                      child: Text('An error occurred. Please try again later'))
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          CustomPaginatedTable<TransactionModel>(
                            // title: 'Transaction List',
                            header: Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: BalancePaymentCard(
                                totalAmount: viewModel
                                    .headerDetails!.totalContributions
                                    .toString(),
                                totalAmountTransactions: viewModel
                                    .headerDetails!.approvedTransactions
                                    .toString(),
                                totalAmountPendingTransactions: viewModel
                                    .headerDetails!.pendingTransactions
                                    .toString(),
                                totalMinusPendingTransactions: viewModel
                                    .headerDetails!
                                    .totalMinusPendingTransactions
                                    .toString(),
                                installments:
                                    viewModel.headerDetails!.totalTransactions,
                              ),
                            ),
                            data: viewModel.transactionsList,
                            columns: transactionColumns,
                            getCells: (transac) => [
                              DataCell(Text(transac.fundName)),
                              DataCell(Text(transac.transactionDescription)),
                              DataCell(Align(
                                  alignment: Alignment.center,
                                  child: Text(formatCurrency(
                                      transac.transactionAmount.toString())))),
                              DataCell(statusButton(
                                  status: transac.transactionStatus)),
                              // DataCell(Text(transac.transactionStatus)),
                              DataCell(Text(transac.createdBy)),
                              DataCell(Text(formatDate(
                                  transac.transactionDate.toString()))),
                              DataCell(Text(transac.authorizedBy!)),
                              DataCell(Text(formatDate(transac.authorizationDate
                                          .toString()) ==
                                      formatDate(DateTime.now().toString())
                                  ? '-'
                                  : formatDate(
                                      transac.authorizationDate.toString()))),
                            ],
                            filterFunction: (transac, query) {
                              final lowercaseQuery = query.toLowerCase();
                              return transac.fundName
                                      .toLowerCase()
                                      .contains(lowercaseQuery) ||
                                  transac.transactionDescription
                                      .toLowerCase()
                                      .contains(lowercaseQuery) ||
                                  transac.transactionStatus
                                      .toLowerCase()
                                      .contains(lowercaseQuery) ||
                                  transac.transactionAmount
                                      .toString()
                                      .toLowerCase()
                                      .contains(lowercaseQuery) ||
                                  transac.createdBy
                                      .toLowerCase()
                                      .contains(lowercaseQuery) ||
                                  transac.transactionDate
                                      .toString()
                                      .toLowerCase()
                                      .contains(lowercaseQuery) ||
                                  transac.authorizedBy!
                                      .toLowerCase()
                                      .contains(lowercaseQuery) ||
                                  transac.authorizationDate
                                      .toString()
                                      .toLowerCase()
                                      .contains(lowercaseQuery);
                            },
                            onRowTap: (transac) {
                              // Handle transac selection
                              debugPrint(
                                  'Selected transac: ${transac.fundName}');
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
                              PopupMenuItem<String>(
                                value: 'donations',
                                child: ListTile(
                                  leading: Icon(EvoIcons.offering.icon),
                                  title: const Text('Add Contributions'),
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
                              _handletransacAction(
                                  context, action, viewModel, transac);
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
                                  callAddTransactionModal(
                                      context, 'New', viewModel);
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
                    ),
    );
  }
}
