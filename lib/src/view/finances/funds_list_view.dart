import 'dart:async';

import 'package:evochurch/src/constants/constant_index.dart';
import 'package:evochurch/src/model/fund_model.dart';
import 'package:evochurch/src/routes/app_route_constants.dart';
import 'package:evochurch/src/utils/string_text_utils.dart';
import 'package:evochurch/src/view/finances/contribution_list_view.dart';
import 'package:evochurch/src/view/finances/widgets/add_donations_modal.dart';
import 'package:evochurch/src/view/finances/widgets/add_transaction_modal.dart';
import 'package:evochurch/src/view/message.dart';
import 'package:evochurch/src/view_model/finance_view_model.dart';
import 'package:evochurch/src/widgets/loading.dart';
import 'package:evochurch/src/widgets/maintanceWidgets/status_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/grid_columns.dart';
import '../../widgets/paginateDataTable/paginated_data_table.dart';
import 'widgets/add_fund_modal.dart';

class FundsListView extends HookWidget {
  const FundsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final fundsViewModel = Provider.of<FinanceViewModel>(context, listen: true);
    final isLoading = useState<bool>(true);

    final fundList = useState<List<FundModel>>([]);

    void fetchFunds() async {
      try {
        isLoading.value = true; // Set loading before fetching
        final fundsData = await fundsViewModel.getFundList();

        if (fundsData['status_code'] == 404) {
          debugPrint('No funds found');
          isLoading.value = false;
          return;
        }

        fundList.value = fundsViewModel.fundsList;
        isLoading.value = false; // Set loading to false after data arrives
      } catch (e) {
        debugPrint('Failed to load funds: $e');
        isLoading.value = false;
      }
    }

    useEffect(() {
      // Suscribe to data change notifications
      final fundsSubscription = fundsViewModel.fundStreamController.listen((_) {
        debugPrint('Fetching funds');
        fetchFunds();
      });

      // Fetch funds
      fetchFunds();

      return () {
        fundsSubscription.cancel();
      };
    }, [fundsViewModel, fundsViewModel.fundStreamController]);

    void setPrimaryFund(BuildContext context, FinanceViewModel fundsViewModel,
        String fundId) async {
      final response = await fundsViewModel.setPrimaryFund(fundId);
      if (response['status_code'] == 200) {
        if (!context.mounted) return;
        CupertinoModalOptions.show(
          modalType: ModalTypeMessage.success,
          context: context,
          title: 'Primary Fund',
          message: response['message'],
          actions: [
            ModalAction(
              text: 'OK',
              onPressed: () => true,
            ),
          ],
        );
        fetchFunds();
      } else if (response['status_code'] == 400) {
        if (!context.mounted) return;
        CupertinoModalOptions.show(
          modalType: ModalTypeMessage.warning,
          context: context,
          title: 'Primary Fund',
          message: response['message'],
          actions: [
            ModalAction(
              text: 'OK',
              onPressed: () => true,
            ),
          ],
        );
      } else if (response['status_code'] == 500) {
        if (!context.mounted) return;
        CupertinoModalOptions.show(
          modalType: ModalTypeMessage.error,
          context: context,
          title: 'Primary Fund',
          message: response['message'],
          actions: [
            ModalAction(
              text: 'OK',
              onPressed: () => true,
            ),
          ],
        );
      }
    }

    // Function to handle fund actions
    void _handlefundAction(
        BuildContext context, String action, FundModel fund) {
      switch (action) {
        case 'edit_funds':
          fundsViewModel.selectFund(fund);
          // Navigate to edit fund screen
          callAddFundModal(context, 'edit', fund);
          break;
        case 'view_transactions':
          // Handle transactions
          //  viewModel.selectMember(member);
          debugPrint('Showing transactions for: ${fund.fundId}');
          context.goNamed(MyAppRouteConstants.fundDetailsRouteName, extra: {
            'financeViewModel': fundsViewModel,
            'fundModel': fund,
          });
          break;
        case 'view_contributions':
          // Handle contributions
          debugPrint('Adding contributions for: ${fund.fundId}');
          context.goNamed(
            MyAppRouteConstants.fundContributionsRouteName,
            extra: {
              'fund': fund,
            },
          );
          break;
        case 'make_prymary':
          // Handle make primary
          debugPrint('Making fund primary: ${fund.fundId}');
          setPrimaryFund(context, fundsViewModel, fund.fundId);
          break;
        case 'add_transaction':
          // Handle donations
          debugPrint('Adding Transaction for: ${fund.fundId}');
          callAddTransactionModal(context, 'New', fundsViewModel,
              fund_id: fund.fundId);

          break;
        case 'delete':
          // Show delete confirmation
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Confirm Delete'),
              content:
                  Text('Are you sure you want to delete ${fund.fundName}?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Handle delete
                    fundsViewModel.deleteFund(fund.fundId);
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
        appBar: AppBar(
          title: const Text(
            'Funds List',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        body: isLoading.value
            ? simpleLoadingUI(context, 'Loading funds...')
            : fundList.value.isEmpty
                ? const Center(child: Text('No funds found'))
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        CustomPaginatedTable<FundModel>(
                          // title: 'funds Directory',
                          data: fundList.value,
                          columns: contributionColumns
                              .where((column) => column.label != 'Description')
                              .toList(),
                          getCells: (fund) => [
                            DataCell(Text(fund.fundName)),
                            // DataCell(Text(fund.description!)),
                            DataCell(StatusChip(
                                status: fund.isPrimary
                                    ? 'Primaria'
                                    : 'Secundaria')),
                            DataCell(StatusChip(
                                status: fund.isActive ? 'Activo' : 'Inactiva')),
                            DataCell(Text(
                                formatCurrency(fund.targetAmount.toString()))),
                            DataCell(Text(formatCurrency(
                                fund.totalContributions.toString()))),
                            DataCell(
                                Text(formatDate(fund.startDate.toString()))),
                            DataCell(Text(formatDate(fund.endDate.toString()))),
                          ],
                          filterFunction: (fund, query) {
                            final lowercaseQuery = query.toLowerCase();
                            return fund.fundName
                                    .toLowerCase()
                                    .contains(lowercaseQuery) ||
                                fund.description!
                                    .toLowerCase()
                                    .contains(lowercaseQuery);
                          },
                          onRowTap: (fund) {
                            // Handle fund selection
                            debugPrint('Selected fund: ${fund.fundName}');
                          },
                          actionMenuBuilder: (context, fund) => [
                            const PopupMenuItem<String>(
                              value: 'edit_funds',
                              child: ListTile(
                                leading: Icon(Icons.edit_outlined),
                                title: Text('Edit fund'),
                                dense: true,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'view_transactions',
                              child: ListTile(
                                leading: Icon(Icons.list_alt_outlined),
                                title: Text('View Transactions'),
                                dense: true,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'view_contributions',
                              child: ListTile(
                                leading: Icon(Icons.money),
                                title: Text('View Contributions'),
                                dense: true,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'add_transaction',
                              child: ListTile(
                                leading: Icon(Icons.money_off_csred_outlined),
                                title: Text('Add Transaction'),
                                dense: true,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'make_prymary',
                              child: ListTile(
                                leading: Icon(Icons.star_border),
                                title: Text('Make primary'),
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
                                  'Delete fund',
                                  style: TextStyle(color: Colors.red),
                                ),
                                dense: true,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                          ],
                          onActionSelected: (action, fund) {
                            _handlefundAction(context, action, fund);
                          },
                          tableButtons: [
                            CustomTableButton(
                              text: 'Add Fund',
                              icon: const Icon(
                                FontAwesomeIcons.handHoldingDollar,
                                size: 22,
                              ),
                              onPressed: () {
                                debugPrint('Add fund');
                                callAddFundModal(context, 'add', null);
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
                  ));
  }
}
