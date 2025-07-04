import 'package:evochurch/src/blocs/index_bloc.dart';
import 'package:evochurch/src/constants/constant_index.dart';
import 'package:evochurch/src/utils/utils_index.dart';
import 'package:evochurch/src/widgets/button/button.dart';
import 'package:evochurch/src/widgets/datatable/datatable.dart';
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
      onSelectChanged: (selected) {
        if (selected == true) {
          onRowTap?.call(item);
        }
      },
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}

class CustomTableButton {
  final String text;
  final Icon? icon;
  final VoidCallback onPressed;

  const CustomTableButton({
    required this.text,
    this.icon,
    required this.onPressed,
  });
}

class CustomPaginatedTable<T> extends HookWidget {
  final String? title;
  final Widget? header;
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
    this.title,
    this.header,
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
    final DataTableBloc dataTableBloc = DataTableBloc();
    final searchQuery = useState('');
    final rowsPerPage = useState<int>(10);
    final sortColumnIndex = useState<int>(0);
    final isAscending = useState<bool>(true);
    final page = useState<int>(0);
    final start = useState<int>(0);
    final end = useState<int>(10);

    final filteredAndSortedData = useMemoized(() {
      var newData = searchQuery.value.isEmpty
          ? List<T>.from(data)
          : data
              .where((item) => filterFunction(item, searchQuery.value))
              .toList();

      if (columns[sortColumnIndex.value].getValue != null) {
        final sortColumn = columns[sortColumnIndex.value];
        newData.sort((a, b) {
          final valueA = sortColumn.getValue!(a);
          final valueB = sortColumn.getValue!(b);
          return isAscending.value
              ? Comparable.compare(valueA, valueB)
              : Comparable.compare(valueB, valueA);
        });
      }

      return newData;
    }, [searchQuery.value, data, sortColumnIndex.value, isAscending.value]);

    void updateData() {
      start.value = page.value * rowsPerPage.value;
      end.value = start.value + rowsPerPage.value;
      if (end.value > filteredAndSortedData.length) {
        end.value = filteredAndSortedData.length;
      }
    }

    // Reset page to 0 when search query changes
    useEffect(() {
      page.value = 0;
      updateData();
    }, [searchQuery.value]);

    // Update start and end when page or rowsPerPage changes
    useEffect(() {
      updateData();
    }, [page.value, rowsPerPage.value, filteredAndSortedData]);

    // create a custom Pagination widget
    List<Widget> pagination() {
      int totalPages =
          (filteredAndSortedData.length / (rowsPerPage.value)).ceil();

      return [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: page.value > 0
                    ? () {
                        page.value = page.value - 1;
                        dataTableBloc.add(const DataTableEvent.rebuild());
                      }
                    : null, // Disable button if no previous page
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(0.0), // Rectangular shape
                  ),
                  backgroundColor: page.value > 0
                      ? context.isDarkMode
                          ? Theme.of(context).scaffoldBackgroundColor
                          : EvoColor.white // Enabled color
                      : Colors.grey, // Disabled color
                ),
                child: Text(
                  'Previous',
                  style: TextStyle(
                      color: page.value > 0
                          ? context.isDarkMode
                              ? null
                              : Theme.of(context).colorScheme.onPrimaryContainer
                          : context.isDarkMode
                              ? Colors.white.withOpacity(0.5)
                              : Colors.black.withOpacity(0.4)),
                ),
              ),
              EvoBox.w4,
              Wrap(
                spacing: 4,
                children: List.generate(
                  totalPages,
                  (index) => ElevatedButton(
                    onPressed: () {
                      page.value = index;
                      updateData();
                      dataTableBloc.add(const DataTableEvent.rebuild());
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(0.0), // Rectangular shape
                      ),
                      backgroundColor: page.value == index
                          ? context.isDarkMode
                              ? EvoColor.primary
                              : Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer // Enabled color
                          : Theme.of(context)
                              .scaffoldBackgroundColor, // Disabled color
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: page.value == index
                            ? EvoColor.white
                            : context.isDarkMode
                                ? EvoColor.white
                                : Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
              ),
              EvoBox.w4,
              ElevatedButton(
                onPressed: page.value < totalPages - 1
                    ? () {
                        page.value = page.value + 1;
                        dataTableBloc.add(const DataTableEvent.rebuild());
                        updateData();
                      }
                    : null, // Disable button if no next page
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(0.0), // Rectangular shape
                  ),
                  backgroundColor: page.value < totalPages - 1
                      ? context.isDarkMode
                          ? Theme.of(context).scaffoldBackgroundColor
                          : EvoColor.white // Enabled color
                      : Colors.grey, // Disabled color
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                    color: page.value < totalPages - 1
                        ? context.isDarkMode
                            ? null
                            : Theme.of(context).colorScheme.onPrimaryContainer
                        : context.isDarkMode
                            ? Colors.white.withOpacity(0.5)
                            : Colors.black.withOpacity(0.4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ];
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (header != null) header!,
              EvoBox.h20,
              Row(
                children: [
                  if (title != null)
                    Text(title!, style: Theme.of(context).textTheme.titleLarge),
                  const Spacer(),
                  if (tableButtons != null)
                    ...tableButtons!.map(
                      (button) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: EvoButton(
                          text: button.text,
                          height: 45,
                          icon: button.icon,
                          onPressed: button.onPressed,
                        ),
                      ),
                    ),
                  SizedBox(
                    width: 250,
                    height: 40,
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        searchQuery.value = value;
                      },
                    ),
                  ),
                ],
              ),
              data.isEmpty ? EvoBox.h36 : EvoBox.h20,
              if (data.isEmpty)
                SizedBox(
                    height: MediaQuery.of(context).size.height /
                        2, // Adjust for padding if needed
                    child: Center(
                      child: Text(
                        "No Record Found",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ))
              else ...[
                DataTable3(
                  showCheckboxColumn: false,
                  showBottomBorder: true,
                  minWidth: !Responsive.isMobile(context) ? 1000 : 1100,
                  dividerThickness: 1.0,
                  headingRowHeight: 56.0,
                  dataRowHeight: 56.0,
                  columnSpacing: 20.0,
                  headingRowColor: WidgetStateProperty.all(
                      const Color(0XFFB8B8B8).withOpacity(0.2)),
                  columns: [
                    const DataColumn(label: Text('Actions')),
                    ...columns.map(
                      (column) => DataColumn(
                        label: Text(column.label),
                        numeric: column.numeric,
                        onSort: (columnIndex, ascending) {
                          sortColumnIndex.value = columnIndex - 1;
                          isAscending.value = ascending;
                        },
                      ),
                    ),
                  ],
                  rows: filteredAndSortedData
                      .sublist(start.value, end.value)
                      .map(
                        (item) => DataRow2(
                          color: WidgetStateProperty.all(
                            filteredAndSortedData.indexOf(item) % 2 != 0
                                ? const Color(0XFFB8B8B8).withOpacity(0.2)
                                : null,
                          ),
                          cells: [
                            DataCell(
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.menu_outlined),
                                onSelected: (value) =>
                                    onActionSelected?.call(value, item),
                                itemBuilder: (context) =>
                                    actionMenuBuilder(context, item),
                              ),
                            ),
                            ...getCells(item),
                          ],
                          onSelectChanged: (selected) {
                            if (selected == true) {
                              onRowTap?.call(item);
                            }
                          },
                        ),
                      )
                      .toList(),
                ),
                if (filteredAndSortedData.isEmpty)
                  const Center(child: Text("No Record Found")),
                EvoBox.h20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Showing ${start.value + 1} to ${filteredAndSortedData.length >= 10 ? end.value : filteredAndSortedData.length} of ${filteredAndSortedData.length} entries",
                      ),
                    ),
                    const Spacer(),
                    if (!Responsive.isMobile(context))
                      Row(children: pagination()),
                  ],
                ),
                EvoBox.h20,
                if (Responsive.isMobile(context))
                  Column(children: pagination()),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
