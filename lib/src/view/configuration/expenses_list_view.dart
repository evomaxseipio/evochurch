import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:evochurch/src/model/expense_type_model.dart';
import 'package:evochurch/src/view/configuration/widgets/add_expense_modal.dart';
import 'package:evochurch/src/view_model/expense_view_model.dart';

import '../../constants/grid_columns.dart';
import '../../widgets/paginateDataTable/paginated_data_table.dart';

class ExpensesListView extends HookWidget {
  const ExpensesListView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ExpensesTypeViewModel>(context, listen: true);

    final isLoading = useState<bool>(true);

    StreamSubscription? expenseSubscription;

    useEffect(() {
      fetchExpenses() async {
        try {
          isLoading.value = true; // Set loading before fetching

          expenseSubscription = viewModel.getExpensesTypeList().listen(
            (expense) {
              if (!context.mounted) return;
              isLoading.value =
                  false; // Set loading to false after data arrives
            },
            onError: (e) {
              if (!context.mounted) return;
              debugPrint('Error loading expense: $e');
              isLoading.value = false; // Set loading to false on error
            },
            onDone: () {
              if (!context.mounted) return;
              isLoading.value = false; // Set loading to false on done
            },
          );
        } catch (e) {
          debugPrint('Failed to load expense: $e');
          isLoading.value = false;
        }
      }

      fetchExpenses();
      return () {
        expenseSubscription!.cancel();
      };
    }, []);

    void _handleExpenseAction(
        BuildContext context, String action, ExpensesTypeModel expense) {
      switch (action) {
        case 'edit':
          viewModel.selectedExpensesType!;
          // context.goNamed(MyAppRouteConstants.fundProfileRouteName,extra: fund);
          break;
        case 'delete':
          // Show delete confirmation
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Confirm Delete'),
              content: Text(
                  'Are you sure you want to delete ${expense.expensesName}?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Handle delete
                    viewModel.deleteExpensesType(expense.expensesTypeId!);
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
          : SingleChildScrollView(
              child: Column(
                children: [
                  CustomPaginatedTable<ExpensesTypeModel>(
                    title: 'expense Directory',
                    data: viewModel.expensesTypeList,
                    columns: expenseTypeColumns,
                    getCells: (expense) => [
                      DataCell(Text(expense.expensesName)),
                      DataCell(Text(expense.expensesCategory)),
                      DataCell(Text(expense.expensesDescription!)),
                      DataCell(Text(expense.isActive.toString())),
                      // DataCell(Text(formatDate(expense.startDate.toString()))),
                      // DataCell(Text(formatDate(expense.endDate.toString()))),
                    ],
                    filterFunction: (expense, query) {
                      final lowercaseQuery = query.toLowerCase();
                      return expense.expensesName
                              .toLowerCase()
                              .contains(lowercaseQuery) ||
                          expense.expensesDescription!
                              .toLowerCase()
                              .contains(lowercaseQuery);
                    },
                    onRowTap: (expense) {
                      // Handle fund selection
                      debugPrint('Selected expense: ${expense.expensesName}');
                    },
                    actionMenuBuilder: (context, expense) => [
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit_outlined),
                          title: Text('Edit Expense'),
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
                            'Delete Expens',
                            style: TextStyle(color: Colors.red),
                          ),
                          dense: true,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ],
                    onActionSelected: (action, expense) {
                      _handleExpenseAction(context, action, expense);
                    },
                    tableButtons: [
                      CustomTableButton(
                        text: 'Add Expense Type',
                        icon: const Icon(
                          FontAwesomeIcons.handHoldingDollar,
                          size: 22,
                        ),
                        onPressed: () {
                          debugPrint('Add Expense Type');
                          callAddExpenseModal(context);
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
