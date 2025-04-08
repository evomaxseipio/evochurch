import 'package:evochurch/src/constants/constant_index.dart';
import 'package:evochurch/src/model/member_finance_model.dart';
import 'package:evochurch/src/model/member_model.dart';
import 'package:evochurch/src/utils/utils_index.dart';
import 'package:evochurch/src/view/finances/widgets/add_donations_modal.dart';
import 'package:evochurch/src/widgets/button/button.dart';
import 'package:evochurch/src/widgets/custom_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../blocs/datatable/data_table_bloc.dart';
import '../../view/home/short_data.dart';
import '../datatable/datatable.dart';

class TaskQueue extends HookWidget {
  final List<CollectionList> collectionTransaction;
  final Member member;
  const TaskQueue(this.collectionTransaction, this.member, {super.key});

  @override
  Widget build(BuildContext context) {
    final dataTableBloc = useMemoized(() => DataTableBloc(), []);
    final tabNotifier = useState<int>(0);

    // Convert state variables to hooks
    final contribution = useState<List<CollectionList>>([]);
    final rowsPerPage = useState<int>(5);
    final currentPage = useState<int>(0);
    final startIndex = useState<int>(0);
    final endIndex = useState<int>(5);

    // Helper functions
    void updatePaginationIndices(
        List<CollectionList> contributionList,
        int currentPageValue,
        int rowsPerPageValue,
        ValueNotifier<int> startIndexNotifier,
        ValueNotifier<int> endIndexNotifier) {
      if (currentPageValue == 0) {
        startIndexNotifier.value = 0;
        endIndexNotifier.value = contributionList.length < rowsPerPageValue
            ? contributionList.length
            : rowsPerPageValue;
      } else {
        startIndexNotifier.value = currentPageValue * rowsPerPageValue;
        endIndexNotifier.value = startIndexNotifier.value + rowsPerPageValue;
        endIndexNotifier.value =
            endIndexNotifier.value < contributionList.length
                ? endIndexNotifier.value
                : contributionList.length;
      }
    }

    void searchTransaction(String searchTerm) async {
      await Future.delayed(const Duration(milliseconds: 300), () {
        contribution.value = contribution.value
            .where((contributionItem) =>
                contributionItem.collectionTypeName
                    .toString()
                    .toLowerCase()
                    .contains(searchTerm.toLowerCase()) ||
                contributionItem.collectionAmount
                    .toString()
                    .toLowerCase()
                    .contains(searchTerm.toLowerCase()) ||
                contributionItem.collectionDate
                    .toString()
                    .toLowerCase()
                    .contains(searchTerm.toLowerCase()) ||
                contributionItem.comments
                    .toString()
                    .toLowerCase()
                    .contains(searchTerm.toLowerCase()) ||
                contributionItem.paymentMethod
                    .toString()
                    .toLowerCase()
                    .contains(searchTerm.toLowerCase()))
            .toList();
        currentPage.value = 0;
        updatePaginationIndices(contribution.value, currentPage.value,
            rowsPerPage.value, startIndex, endIndex);
      });
      dataTableBloc.add(const DataTableEvent.rebuild());
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Replace initState with useEffect
    useEffect(() {
      contribution.value = collectionTransaction;
      updatePaginationIndices(contribution.value, currentPage.value,
          rowsPerPage.value, startIndex, endIndex);
      return;
    }, [collectionTransaction]);

    return BlocProvider(
      create: (context) => dataTableBloc,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: BlocBuilder<DataTableBloc, DataTableState>(
                builder: (context, state) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildHeader(context, searchTransaction),
                    EvoBox.h24,
                    buildDataTable(context, isDark, tabNotifier,
                        contribution.value, startIndex.value, endIndex.value),
                    if (contribution.value.isEmpty)
                      const Center(
                          child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text("No Record Found"),
                      )),
                    EvoBox.h20,
                    buildPaginationControls(
                        context,
                        isDark,
                        contribution.value,
                        currentPage,
                        rowsPerPage.value,
                        startIndex,
                        endIndex,
                        dataTableBloc,
                        updatePaginationIndices),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context, Function(String) searchLoans) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Member Contributions",
          style: EvoTheme.title(context).copyWith(fontSize: 18.0),
        ),
        buildSearchBar(
          context: context,
          onChanged: searchLoans,
        ),
      ],
    );
  }

  Widget buildDataTable(
      BuildContext context,
      bool isDark,
      ValueNotifier<int> tabNotifier,
      List<CollectionList> contribution,
      int startIndex,
      int endIndex) {
    return ValueListenableBuilder<int>(
        valueListenable: tabNotifier,
        builder: (context, tabNotifierValue, _) {
          return ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: (56.0 * 10) + 72.0),
            child: DataTable3(
              showCheckboxColumn: false,
              showBottomBorder: true,
              columnSpacing: 20.0,
              minWidth: 728.0,
              dataRowHeight: 56.0,
              headingRowHeight: 54.0,
              headingRowColor: WidgetStateProperty.all(
                  const Color(0XFFB8B8B8).withOpacity(0.2)),
              border: TableBorder(
                bottom: BorderSide(
                  width: 1,
                  color: isDark
                      ? EvoColor.white.withOpacity(0.25)
                      : Colors.grey.shade200,
                ),
                horizontalInside: BorderSide(
                  width: 1,
                  color: isDark
                      ? EvoColor.white.withOpacity(0.25)
                      : Colors.grey.shade50,
                ),
              ),
              columns: [
                DataColumn2(
                  label: tableHeader(context, 'Tipo de Contribucion'),
                  size: ColumnSize.L,
                ),
                DataColumn2(
                  label: tableHeader(context, 'Fecha de Contribucion'),
                  size: ColumnSize.S,
                ),
                DataColumn2(
                  label: tableHeader(context, 'Monto Contribuccion'),
                  size: ColumnSize.M,
                ),
                DataColumn2(
                  label: tableHeader(context, 'Comentario'),
                  size: ColumnSize.L,
                ),
                DataColumn2(
                  label: tableHeader(context, 'Via de Contribucion'),
                  size: ColumnSize.S,
                ),
              ],
              rows: contribution.isEmpty
                  ? []
                  : buildTableRows(context, contribution, startIndex, endIndex),
            ),
          );
        });
  }

  List<DataRow2> buildTableRows(BuildContext context,
      List<CollectionList> contribution, int startIndex, int endIndex) {
    final visibleLoans = contribution.length <= endIndex
        ? contribution.sublist(startIndex)
        : contribution.sublist(startIndex, endIndex);

    return visibleLoans.asMap().entries.map((entry) {
      final index = entry.key + startIndex;
      final contributionItem = entry.value;

      return DataRow2(
        color: index % 2 != 0
            ? WidgetStateProperty.all(const Color(0XFFB8B8B8).withOpacity(0.2))
            : null,
        onSelectChanged: (_) {},
        cells: [
          DataCell(tableRowWithAvatar(
              context,
              contributionItem.collectionTypeName,
              contributionItem.collectionType)),
          DataCell(tableRow(
              context, formatDate(contributionItem.collectionDate.toString()))),
          DataCell(tableRow(context,
              formatCurrency(contributionItem.collectionAmount.toString()))),
          DataCell(tableRow(context, contributionItem.comments.toString())),
          DataCell(
              tableRow(context, contributionItem.paymentMethod.toString())),
        ],
      );
    }).toList();
  }

  Widget buildPaginationControls(
      BuildContext context,
      bool isDark,
      List<CollectionList> contribution,
      ValueNotifier<int> currentPage,
      int rowsPerPage,
      ValueNotifier<int> startIndex,
      ValueNotifier<int> endIndex,
      DataTableBloc dataTableBloc,
      Function updatePaginationIndices) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
              "Showing ${startIndex.value + 1} to ${endIndex.value} of ${contribution.length} entries"),
        ),
        if (!EvoResponsive.isMobile(context))
          buildPagination(
              context,
              isDark,
              contribution,
              currentPage,
              rowsPerPage,
              startIndex,
              endIndex,
              dataTableBloc,
              updatePaginationIndices),
      ],
    );
  }

  Widget buildPagination(
      BuildContext context,
      bool isDark,
      List<CollectionList> contribution,
      ValueNotifier<int> currentPage,
      int rowsPerPage,
      ValueNotifier<int> startIndex,
      ValueNotifier<int> endIndex,
      DataTableBloc dataTableBloc,
      Function updatePaginationIndices) {
    final totalPages = (contribution.length / rowsPerPage).ceil();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildPaginationButton(
            context: context,
            label: 'Previous',
            isEnabled: currentPage.value > 0,
            isDark: isDark,
            onPressed: () {
              if (currentPage.value > 0) {
                currentPage.value--;
                updatePaginationIndices(contribution, currentPage.value,
                    rowsPerPage, startIndex, endIndex);
                dataTableBloc.add(const DataTableEvent.rebuild());
              }
            },
          ),
          EvoBox.w4,
          Wrap(
            spacing: 4,
            children: List.generate(
              totalPages,
              (index) => buildPageNumberButton(
                context: context,
                pageNumber: index + 1,
                isActive: currentPage.value == index,
                isDark: isDark,
                onPressed: () {
                  currentPage.value = index;
                  updatePaginationIndices(contribution, currentPage.value,
                      rowsPerPage, startIndex, endIndex);
                  dataTableBloc.add(const DataTableEvent.rebuild());
                },
              ),
            ),
          ),
          EvoBox.w4,
          buildPaginationButton(
            context: context,
            label: 'Next',
            isEnabled: currentPage.value < totalPages - 1,
            isDark: isDark,
            onPressed: () {
              if (currentPage.value < totalPages - 1) {
                currentPage.value++;
                updatePaginationIndices(contribution, currentPage.value,
                    rowsPerPage, startIndex, endIndex);
                dataTableBloc.add(const DataTableEvent.rebuild());
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildPaginationButton({
    required BuildContext context,
    required String label,
    required bool isEnabled,
    required bool isDark,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        backgroundColor: isEnabled
            ? isDark
                ? Theme.of(context).scaffoldBackgroundColor
                : EvoColor.white
            : Colors.grey.withOpacity(0.3),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isEnabled
              ? isDark
                  ? Colors.white
                  : EvoColor.primary
              : isDark
                  ? Colors.white.withOpacity(0.5)
                  : EvoColor.primary.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget buildPageNumberButton({
    required BuildContext context,
    required int pageNumber,
    required bool isActive,
    required bool isDark,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        backgroundColor: isActive
            ? EvoColor.primary
            : isDark
                ? Theme.of(context).scaffoldBackgroundColor
                : EvoColor.white,
      ),
      child: Text(
        '$pageNumber',
        style: TextStyle(
          color: isActive
              ? EvoColor.white
              : isDark
                  ? EvoColor.white
                  : EvoColor.primary,
        ),
      ),
    );
  }

  Widget buildSearchBar(
      {required BuildContext context,
      required void Function(String) onChanged}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        // create button call new contribution modal
        EvoButton(
          text: 'Add Tithes',
          onPressed: () {
            callDonationModal(context, member, 'Diezmos');
          },
          icon: Icon(EvoIcons.tithes.icon),
        ),
        EvoBox.w16,
        EvoButton(
          text: 'Add Contributions',
          onPressed: () {
            callDonationModal(context, member, 'Ofrendas');
          },
          icon: Icon(EvoIcons.offering.icon),
        ),
        EvoBox.w16,
        EvoButton(
            text: 'Exportar',
            onPressed: () async {
              try {
                final filePath = await CollectionExportService.exportToExcel(
                  data: collectionTransaction
                      .map((transaction) => {
                            'collection_date': transaction.collectionDate,
                            'collection_type_name':
                                transaction.collectionTypeName,
                            'collection_amount': transaction.collectionAmount,
                            'payment_method': transaction.paymentMethod,
                            'comments': transaction.comments,
                            'is_anonymous': transaction.isAnonymous,
                          })
                      .toList(),
                  headers: [
                    'collection_date',
                    'collection_type_name',
                    'collection_amount',
                    'payment_method',
                    'comments',
                    'is_anonymous',
                  ],
                  columnFormats: {
                    'collection_date': 'date',
                    'collection_amount': 'currency',
                  },
                  fileName: 'collection_list.xlsx',
                );

                // Open or share the file
                // CollectionExportService.handleExportedFile(context, filePath);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Export failed: ${e.toString()}')),
                );
              }
            }),
      ],
    );
  }

  Widget tableHeader(BuildContext context, String text) {
    return Text(
      text,
      style: EvoTheme.title(context).copyWith(fontSize: 14.0),
    );
  }

  Widget tableRow(BuildContext context, String text) {
    return Text(
      text,
      style: EvoTheme.title(context)
          .copyWith(fontSize: 14.0, fontWeight: FontWeight.w500),
    );
  }

  Widget tableRowWithAvatar(
      BuildContext context, String text, int collectionType) {
    IconData iconData;
    Color iconColor;

    switch (collectionType) {
      case 1:
        iconData = Icons.church;
        iconColor = Colors.blue;
        break;
      case 2:
        iconData = Icons.handshake;
        iconColor = Colors.green;
        break;
      case 3:
        iconData = Icons.favorite;
        iconColor = Colors.orange;
        break;
      default:
        iconData = Icons.attach_money;
        iconColor = Colors.grey;
    }

    return ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.2),
          child: Icon(iconData, color: iconColor),
        ),
        title: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ));
  }
}
