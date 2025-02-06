import 'package:evochurch/src/widgets/button/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SortColumn {
  final String label;
  final String field;
  final bool numeric;
  final Comparable Function(dynamic item)? getValue;

  const SortColumn({
    required this.label,
    required this.field,
    this.numeric = false,
    this.getValue,
  });
}

class CustomDataTableSource<T> extends DataTableSource {
  final List<T> data;
  final List<DataCell> Function(T) getCells;
  final void Function(T)? onRowTap;
  final List<PopupMenuEntry<String>> Function(BuildContext, T)
      actionMenuBuilder;
  final void Function(String, T)? onActionSelected;

  CustomDataTableSource({
    required this.data,
    required this.getCells,
    this.onRowTap,
    required this.actionMenuBuilder,
    this.onActionSelected,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final item = data[index];
    final actionMenu = DataCell(
      Builder(
        builder: (context) => PopupMenuButton<String>(
          icon: const Icon(Icons.menu_outlined),
          onSelected: (value) => onActionSelected?.call(value, item),
          itemBuilder: (context) => actionMenuBuilder(context, item),
        ),
      ),
    );
    return DataRow(
      cells: [actionMenu, ...getCells(item)],
      onSelectChanged: (selected) =>
          selected == true ? onRowTap?.call(item) : null,
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => data.length;
  @override
  int get selectedRowCount => 0;
}

class CustomPaginatedTable<T> extends HookWidget {
  final String title;
  final List<T> data;
  final List<SortColumn> columns;
  final List<DataCell> Function(T) getCells;
  final bool Function(T, String) filterFunction;
  final void Function(T)? onRowTap;
  final List<PopupMenuEntry<String>> Function(BuildContext, T)
      actionMenuBuilder;
  final void Function(String, T)? onActionSelected;
  final List<CustomTableButton>? tableButtons;

  const CustomPaginatedTable({
    super.key,
    required this.title,
    required this.data,
    required this.columns,
    required this.getCells,
    required this.filterFunction,
    required this.actionMenuBuilder,
    this.onActionSelected,
    this.onRowTap,
    this.tableButtons,
  });

  @override
  Widget build(BuildContext context) {
    final searchQuery = useState('');
    final rowsPerPage = useState<int>(10);
    final sortColumnIndex = useState<int>(0);
    final isAscending = useState<bool>(true);

    final filteredAndSortedData = useMemoized(() {
      var newData = searchQuery.value.isEmpty
          ? List<T>.from(data)
          : data
              .where((item) => filterFunction(item, searchQuery.value))
              .toList();
      if (columns[sortColumnIndex.value].getValue != null) {
        final sortColumn = columns[sortColumnIndex.value];
        newData.sort((a, b) => isAscending.value
            ? Comparable.compare(
                sortColumn.getValue!(a), sortColumn.getValue!(b))
            : Comparable.compare(
                sortColumn.getValue!(b), sortColumn.getValue!(a)));
      }
      return newData;
    }, [searchQuery.value, data, sortColumnIndex.value, isAscending.value]);

    return Card(
      elevation: 2,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                  const Spacer(),
                  if (tableButtons != null)
                    ...tableButtons!.map((button) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: EvoButton(
                            text: button.text,
                            height: 45,
                            icon: button.icon,
                            onPressed: button.onPressed,
                          ),
                        )),
                  SizedBox(
                    width: 250,
                    height: 40,
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => searchQuery.value = value,
                    ),
                  ),
                ],
              ),
            ),
            PaginatedDataTable(
              columns: [
                const DataColumn(label: Text('Actions')),
                ...columns.map((column) => DataColumn(
                      label: Text(column.label),
                      numeric: column.numeric,
                      onSort: (columnIndex, ascending) {
                        sortColumnIndex.value = columnIndex - 1;
                        isAscending.value = ascending;
                      },
                    )),
              ],
              source: CustomDataTableSource<T>(
                data: filteredAndSortedData,
                getCells: getCells,
                onRowTap: onRowTap,
                actionMenuBuilder: actionMenuBuilder,
                onActionSelected: onActionSelected,
              ),
              rowsPerPage: rowsPerPage.value,
              availableRowsPerPage: const [10, 20, 50],
              onRowsPerPageChanged: (value) => rowsPerPage.value = value ?? 10,
              sortColumnIndex: sortColumnIndex.value + 1,
              sortAscending: isAscending.value,
              showCheckboxColumn: false,
              showFirstLastButtons: true,
              columnSpacing: 12.0,
              horizontalMargin: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTableButton {
  final String text;
  final Icon? icon;
  final VoidCallback onPressed;
  const CustomTableButton(
      {required this.text, this.icon, required this.onPressed});
}
