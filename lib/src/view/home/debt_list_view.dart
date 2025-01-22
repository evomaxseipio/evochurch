import 'dart:developer';

import 'package:evochurch/src/blocs/index_bloc.dart';
import 'package:evochurch/src/utils/utils_index.dart';
import 'package:evochurch/src/view/home/short_data.dart';
import 'package:evochurch/src/widgets/datatable/datatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/constant_index.dart';
import '../../widgets/widget_index.dart';


class DebtListView extends StatefulWidget {
  const DebtListView({super.key});

  @override
  State<DebtListView> createState() => _DebtListViewState();
}

List<Map<String, dynamic>> ls = [];

int _dropValue = 5;
int _page = 0;

int _start = 0;
int _end = 5;

class _DebtListViewState extends State<DebtListView> {
  final DataTableBloc _dataTableBloc = DataTableBloc();
  final _tabNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    ls = newCustomerContract;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _dataTableBloc,
      child: EvoWhiteCard(
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                       " EvoString.recentTransactions",
                        style: EvoTheme.title(context)
                            .copyWith(fontSize: 18.0),
                      ),
                      _searchBar(
                        onChanged: (searchTerm) async {
                          log("search $searchTerm");
                          await Future.delayed(
                              const Duration(milliseconds: 500), () {
                            log("search1 $searchTerm");
                            ls = newCustomerContract
                                .where((employee) =>
                                    employee['client_name']
                                        .toString()
                                        .toLowerCase()
                                        .contains(searchTerm.toLowerCase()) ||
                                    employee['route_name']
                                        .toString()
                                        .toLowerCase()
                                        .contains(searchTerm.toLowerCase()) ||
                                    employee['debt_collector']
                                        .toString()
                                        .toLowerCase()
                                        .contains(searchTerm.toLowerCase()))
                                .toList();
                            log("search2 $ls");
                            _end =
                                ls.length > _dropValue ? _dropValue : ls.length;
                            _start = 0;
                            _page = 0;
                          }).then((value) {
                            _dataTableBloc.add(const DataTableEvent.rebuild());
                          });
                        },
                      ),
                    ],
                  ),
                  EvoBox.h24,
                  ValueListenableBuilder<int>(
                      valueListenable: _tabNotifier,
                      builder: (context, tabNotifier, _) {
                        return ConstrainedBox(
                          constraints: const BoxConstraints(
                              maxHeight: (56.0 * 10) + 72.0),
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
                                  color: context.isDarkMode
                                      ? EvoColor.white.withOpacity(0.25)
                                      : Colors.grey.shade200,
                                ),
                                horizontalInside: BorderSide(
                                  width: 1,
                                  color: context.isDarkMode
                                      ? EvoColor.white.withOpacity(0.25)
                                      : Colors.grey.shade50,
                                ),
                              ),
                              columns: [
                                DataColumn2(
                                  label: _tableHeader('Ruta'),
                                  size: ColumnSize.M,
                                ),
                                DataColumn2(
                                  label: _tableHeader('Cliente'),
                                  size: ColumnSize.L,
                                ),
                                DataColumn2(
                                  label: _tableHeader('Monto Prestamo'),
                                  size: ColumnSize.M,
                                ),
                                DataColumn2(
                                  label: _tableHeader('Cobrador'),
                                  size: ColumnSize.L,
                                ),
                              ],
                              rows: ls.getRange(_start, _end).map(
                          (loan) {
                            int index = ls.indexOf(loan);
                            return DataRow2(
                              color: index % 2 != 0
                                  ? WidgetStateProperty.all(
                                      const Color(0XFFB8B8B8).withOpacity(0.2))
                                  : null,
                                // return DataRow(
                                  onSelectChanged: (value) {},
                                  cells: [
                                    DataCell(_tableRow( loan['route_name'])),
                                    DataCell(_tableRow(loan['client_name'])),
                                    DataCell(_tableRow(
                                        formatCurrency(loan['loan_amount'].toString()))),
                                    DataCell(_tableRow(
                                        loan['debt_collector'].toString())),
                                    // DataCell(_slider(
                                    //     loan['status'], loan['progress'])),
                                  ],
                                );
                              }).toList()),
                        );
                      }),
                  if (ls.isEmpty) const Center(child: Text("No Record Found")),
                  EvoBox.h20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                            "Showing ${_start + 1} to $_end of ${ls.length} entries"),
                      ),
                      const Spacer(),
                      if (!EvoResponsive.isMobile(context))
                        Row(
                          children: _paggination(),
                        )
                    ],
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  // Widget _slider(String text, double percentage) {
  //   return CustomeSlider(
  //     percentageColor: boxColor(text),
  //     percentage: percentage,
  //   );
  // }

  Widget _tableRowImage(
    String text, {
    void Function()? onTap,
    required int index,
  }) {
    return ValueListenableBuilder<int>(
      valueListenable: _tabNotifier,
      builder: (context, tabNotifier, _) {
        return InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const CircleAvatar(
                maxRadius: 15,
                // backgroundImage: AssetImage(Images.profileImage),
              ),
              EvoBox.w10,
              Text(
                text,
                style: EvoTheme.title(context).copyWith(
                  fontSize: 14.0,
                  color: context.isDarkMode
                      ? _tabNotifier.value == index
                          ? EvoColor.darkTextHeader
                          : Colors.grey.shade500
                      : _tabNotifier.value == index
                          ? EvoColor.lightTextHeader
                          : Colors.grey.shade500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statusBox(String text) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: boxColor(text).withOpacity(0.2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12.0,
            color: boxColor(text),
          ),
        ));
  }

  Color boxColor(String text) {
    if (text == 'Rejected') {
      return Colors.red;
    } else if (text == 'In Progress') {
      return const Color(0XFF049669);
    } else if (text == 'UAT' || text == 'On Hold') {
      return const Color(0XFFD97705);
    } else {
      return const Color(0XFF4F46E6);
    }
  }

  Widget _tableHeader(String text) {
    return Text(
      text,
      style: EvoTheme.title(context).copyWith(fontSize: 14.0),
    );
  }

  Widget _tableRow(String text) {
    return Text(
      text,
      style: EvoTheme.title(context)
          .copyWith(fontSize: 14.0, fontWeight: FontWeight.w500),
    );
  }

  Widget _searchBar({void Function(String)? onChanged}) {
    return Container(
      height: 35,
      width: 200,
      decoration: BoxDecoration(
        border: Border.all(
          color: context.isDarkMode
              ? EvoColor.white.withOpacity(0.19)
              : EvoColor.black.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CupertinoSearchTextField(
        onChanged: onChanged,
        backgroundColor: Colors.transparent,
        style: TextStyle(
          color: context.isDarkMode ? Colors.white : Colors.black,
          fontSize: 15,
        ),
      ),
    );
  }

  List<Widget> _paggination() {
    int totalPages = (ls.length / (_dropValue)).ceil();

    return [
      SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _page > 0
                  ? () {
                      _page = _page - 1;
                      _dataTableBloc.add(const DataTableEvent.rebuild());
                      updateData();
                    }
                  : null, // Disable button if no previous page
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0), // Rectangular shape
                ),
                backgroundColor: _page > 0
                    ? context.isDarkMode
                        ? Theme.of(context).scaffoldBackgroundColor
                        : EvoColor.white // Enabled color
                    : Colors.grey, // Disabled color
              ),
              child: Text(
                'Previous',
                style: TextStyle(
                  color: _page > 0
                      ? context.isDarkMode
                          ? null
                          : EvoColor.primary
                      : context.isDarkMode
                          ? Colors.white.withOpacity(0.5)
                          : EvoColor.primary,
                ),
              ),
            ),
            EvoBox.w4,
            Wrap(
              spacing: 4,
              children: List.generate(
                totalPages,
                (index) => ElevatedButton(
                  onPressed: () {
                    _page = index;
                    updateData();
                    _dataTableBloc.add(const DataTableEvent.rebuild());
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(0.0), // Rectangular shape
                    ),
                    backgroundColor: _page == index
                        ? context.isDarkMode
                            ? EvoColor.primary
                            : EvoColor.primary // Enabled color
                        : Theme.of(context)
                            .scaffoldBackgroundColor, // Disabled color
                  ),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: _page == index
                          ? EvoColor.white
                          : context.isDarkMode
                              ? EvoColor.white
                              : EvoColor.primary,
                    ),
                  ),
                ),
              ),
            ),
            EvoBox.w4,
            ElevatedButton(
              onPressed: _page < totalPages - 1
                  ? () {
                      _page = _page + 1;
                      _dataTableBloc.add(const DataTableEvent.rebuild());
                      updateData();
                    }
                  : null, // Disable button if no next page
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0), // Rectangular shape
                ),
                backgroundColor: _page < totalPages - 1
                    ? context.isDarkMode
                        ? null
                        : EvoColor.white // Enabled color
                    : Colors.grey, // Disabled color
              ),
              child: Text(
                'Next',
                style: TextStyle(
                  color: _page < totalPages - 1
                      ? context.isDarkMode
                          ? null
                          : EvoColor.primary
                      : context.isDarkMode
                          ? Colors.white.withOpacity(0.5)
                          : EvoColor.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  void updateData() {
    if (_page == 0) {
      _start = 0;
      _end = ls.length < _dropValue ? ls.length : _dropValue;
    } else {
      _start = _page * _dropValue;
      _end = _start + (ls.length < _dropValue ? ls.length : _dropValue);
      _end = _end < ls.length ? _end : ls.length;
    }
  }
}
