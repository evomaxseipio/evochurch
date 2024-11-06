
import 'dart:async';

import 'package:evochurch/src/constants/grid_columns.dart';
import 'package:evochurch/src/model/fund_model.dart';
import 'package:evochurch/src/view_model/finance_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../routes/app_route_constants.dart';
import '../../widgets/paginateDataTable/paginated_data_table.dart';
import '../members/add_member.dart';

class FundsListView extends HookWidget {
  
const FundsListView({ super.key });

    @override
  Widget build(BuildContext context) {
    final SupabaseClient _supabaseClient = Supabase.instance.client;
    final viewModel = Provider.of<FinanceViewModel>(context, listen: false);
    final fundList = useState<List<FundModel>>([]);
    final isLoading = useState<bool>(true);

    StreamSubscription? fundsSubscription;
    StreamSubscription? realtimeSubscription;

    useEffect(() {
      fetchFunds() async {
        try {
          isLoading.value = true; // Set loading before fetching

          fundsSubscription = viewModel.getFundList().listen(
            (funds) {
              if (!context.mounted) return;
              fundList.value = funds['fund_list'];
              isLoading.value = false; // Set loading to false after data arrives
            },
            onError: (e) {
              if (!context.mounted) return;
              debugPrint('Error loading funds: $e');
              isLoading.value = false; // Set loading to false on error
            },
            onDone: () {
              if (!context.mounted) return;
              isLoading.value = false; // Set loading to false on done
            },
          );
        } catch (e) {
          debugPrint('Failed to load funds: $e');
          isLoading.value = false;
        }
      }     

      fetchFunds();
      return () {
        fundsSubscription!.cancel();
        realtimeSubscription!.cancel();
      };
    }, []);

    void _handlefundAction(
        BuildContext context, String action, FundModel fund) {
      switch (action) {
        case 'edit':
          viewModel.selectedFund!;
          // context.goNamed(MyAppRouteConstants.fundProfileRouteName,extra: fund);
          break;

        case 'donations':
          // Handle donations
          debugPrint('Adding donations for: ${fund.fundId}');
          // Example:
          // showDialog(
          //   context: context,
          //   builder: (context) => AddDonationDialog(fund: fund),
          // );
          break;

        case 'message':
          // Handle messaging
          debugPrint('Sending message to: ${fund.fundId}');
          // Example:
          // showDialog(
          //   context: context,
          //   builder: (context) => SendMessageDialog(fund: fund),
          // );
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
      body: isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : fundList.value.isEmpty
              ? const Center(child: Text('No funds Found'))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomPaginatedTable<FundModel>(
                        title: 'funds Directory',
                        data: fundList.value,
                        columns: contributionColumns,
                        getCells: (fund) => [
                          DataCell(Text(fund.fundName ?? '')),
                          DataCell(Text(fund.description ?? '')),
                          DataCell(Text(fund.targetAmount.toString())),
                          DataCell(Text(fund.startDate.toString())),
                          DataCell(Text(fund.endDate.toString() ?? '')),
                          
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
                            value: 'edit',
                            child: ListTile(
                              leading: Icon(Icons.edit_outlined),
                              title: Text('Edit fund'),
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
                          const PopupMenuItem<String>(
                            value: 'message',
                            child: ListTile(
                              leading: Icon(Icons.message_outlined),
                              title: Text('Send Message'),
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
                            text: 'Add fund',
                            icon: const Icon(Icons.person_add_alt_1_rounded),
                            onPressed: () {
                              debugPrint('Add fund');
                              callAddEmployeeModal(context);

                              // context.goNamed(
                              // MyAppRouteConstants.fundProfileRouteName,
                              // extra: null);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
