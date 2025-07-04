// import 'package:evochurch/src/blocs/index_bloc.dart';
// import 'package:evochurch/src/constants/constant_index.dart';
// import 'package:evochurch/src/utils/utils_index.dart';
// import 'package:evochurch/src/view_model/index_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:data_table_2/data_table_2.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:provider/provider.dart';

// class GenericDataTable extends HookWidget {
//   final List<Map<String, dynamic>> data;
//   final List<DataColumn> columns;
//   final bool isPaginated;
//   final int rowsPerPage;

//   const GenericDataTable({
//     Key? key,
//     required this.data,
//     required this.columns,
//     this.isPaginated = true,
//     this.rowsPerPage = 10,
//   }) : super(key: key);

//   Widget build(BuildContext context) {
//      final DataTableBloc _dataTableBloc = DataTableBloc();
//     final fundsViewModel = Provider.of<ConfigurationsViewModel>(context, listen: false);
//     return BlocProvider(
//       create: (context) => _dataTableBloc,
//       child: Padding(
//         padding: const EdgeInsets.all(0),
//         child: Card(
//           elevation: 0,
//           child: Container(
//             padding: const EdgeInsets.all(20),
//             child: BlocBuilder<DataTableBloc, DataTableState>(
//               builder: (context, state) {
//                 return SingleChildScrollView(
//                   physics: const ClampingScrollPhysics(),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       if (Responsive.isMobile(context)) ...{
//                         EvoBox.h6,
//                         _searchBar(
//                           onChanged: (searchTerm) async {
//                             await Future.delayed(
//                                 const Duration(milliseconds: 500), () {
//                               ls = accountsPayableList
//                                   .where((loanQuote) =>
//                                       loanQuote['client_name']
//                                           .toString()
//                                           .toLowerCase()
//                                           .contains(searchTerm.toLowerCase()) ||
//                                       loanQuote['final_date']
//                                           .toString()
//                                           .toLowerCase()
//                                           .contains(searchTerm.toLowerCase()) ||
//                                       loanQuote['loan_amount']
//                                           .toString()
//                                           .toLowerCase()
//                                           .contains(searchTerm.toLowerCase()))
//                                   .toList();
//                               _end = ls.length > _dropValue
//                                   ? _dropValue
//                                   : ls.length;
//                               _start = 0;
//                               _page = 0;
//                             }).then((value) {
//                               _dataTableBloc
//                                   .add(const DataTableEvent.rebuild());
//                             });
//                           },
//                         ),
//                       },
//                       EvoBox.h6,
//                       budgetTotalBar(context, ls.length),
//                       EvoBox.h6,
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                       EvoBox.h20,
//                       SizedBox(
//                           height: ls.length < _dropValue
//                               ? ((ls.length + 1) * 80)
//                               : (_dropValue + 1) * 48,
//                           child: ValueListenableBuilder(
//                               valueListenable: _statusNotifier,
//                               builder: (context, state, child) {
//                                 return DataTable3(
//                                   showCheckboxColumn: false,
//                                   showBottomBorder: true,
//                                   minWidth: !Responsive.isMobile(context)
//                                       ? 1000
//                                       : 1100,
//                                   dividerThickness: 1.0,
//                                   headingRowHeight: 56.0,
//                                   dataRowHeight: 56.0,
//                                   columnSpacing: 20.0,
//                                   headingRowColor: WidgetStateProperty.all(
//                                       const Color(0XFFB8B8B8).withOpacity(0.2)),
//                                   columns: [
//                                     DataColumn2(
//                                       size: ColumnSize.S,
//                                       label: sizedBox(
//                                         text: "Actions",
//                                       ),
//                                     ),
//                                     DataColumn2(
//                                       size: ColumnSize.L,
//                                       label: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           sizedBox(
//                                             text: "Cliente",
//                                           ),
//                                           EvoBox.w2,
//                                           filterButton(
//                                             onPressed: () {
//                                               _nameFilter = !_nameFilter;
//                                               ls.sort((a, b) => _nameFilter
//                                                   ? a['client_name']!.compareTo(
//                                                       b['client_name']!)
//                                                   : b['client_name']!.compareTo(
//                                                       a['client_name']!));
//                                               _dataTableBloc.add(
//                                                   const DataTableEvent
//                                                       .rebuild());
//                                             },
//                                             icon: _nameFilter
//                                                 ? CupertinoIcons
//                                                     .arrow_up_arrow_down_circle_fill
//                                                 : CupertinoIcons
//                                                     .arrow_up_arrow_down_circle,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     DataColumn2(
//                                       size: ColumnSize.M,
//                                       numeric: true,
//                                       label: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           sizedBox(
//                                             text: "Quota",
//                                           ),
//                                           EvoBox.w2,
//                                           filterButton(
//                                             onPressed: () {
//                                               _quoteFilter = !_quoteFilter;
//                                               ls.sort((a, b) => _quoteFilter
//                                                   ? a['loan_quote']!.compareTo(
//                                                       b['loan_quote']!)
//                                                   : b['loan_quote']!.compareTo(
//                                                       a['loan_quote']!));
//                                               _dataTableBloc.add(
//                                                   const DataTableEvent
//                                                       .rebuild());
//                                             },
//                                             icon: _quoteFilter
//                                                 ? CupertinoIcons
//                                                     .arrow_up_arrow_down_circle_fill
//                                                 : CupertinoIcons
//                                                     .arrow_up_arrow_down_circle,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     DataColumn2(
//                                       numeric: true,
//                                       size: ColumnSize.M,
//                                       label: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           sizedBox(
//                                             text: "Monto",
//                                           ),
//                                           EvoBox.w2,
//                                           filterButton(
//                                             onPressed: () {
//                                               _amountFilter = !_amountFilter;
//                                               ls.sort((a, b) => _amountFilter
//                                                   ? a['loan_amount']!.compareTo(
//                                                       b['loan_amount']!)
//                                                   : b['loan_amount']!.compareTo(
//                                                       a['loan_amount']!));
//                                               _dataTableBloc.add(
//                                                   const DataTableEvent
//                                                       .rebuild());
//                                             },
//                                             icon: _amountFilter
//                                                 ? CupertinoIcons
//                                                     .arrow_up_arrow_down_circle_fill
//                                                 : CupertinoIcons
//                                                     .arrow_up_arrow_down_circle,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     DataColumn2(
//                                       numeric: true,
//                                       size: ColumnSize.M,
//                                       label: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             sizedBox(
//                                               text: "Atrasos",
//                                             ),
//                                             EvoBox.w2,
//                                           ]),
//                                     ),
//                                     DataColumn2(
//                                       numeric: true,
//                                       size: ColumnSize.M,
//                                       label: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           sizedBox(
//                                             text: "Restante",
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     DataColumn2(
//                                       size: ColumnSize.M,
//                                       label: Row(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           sizedBox(
//                                             text: "Entrega",
//                                           ),
//                                           EvoBox.w2,
//                                           filterButton(
//                                             onPressed: () {
//                                               _initalDateFilter =
//                                                   !_initalDateFilter;
//                                               ls.sort((a, b) => _initalDateFilter
//                                                   ? a['initial_date']!
//                                                       .compareTo(
//                                                           b['initial_date']!)
//                                                   : b['initial_date']!
//                                                       .compareTo(
//                                                           a['initial_date']!));
//                                               _dataTableBloc.add(
//                                                   const DataTableEvent
//                                                       .rebuild());
//                                             },
//                                             icon: _initalDateFilter
//                                                 ? CupertinoIcons
//                                                     .arrow_up_arrow_down_circle_fill
//                                                 : CupertinoIcons
//                                                     .arrow_up_arrow_down_circle,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     DataColumn2(
//                                       size: ColumnSize.M,
//                                       label: Row(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           sizedBox(
//                                             text: "Vence",
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     DataColumn2(
//                                       size: ColumnSize.M,
//                                       label: Row(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           sizedBox(
//                                             text: "Ultimo P.",
//                                           ),
//                                           EvoBox.w2,
//                                           filterButton(
//                                             onPressed: () {
//                                               _lastPaymentFilter =
//                                                   !_lastPaymentFilter;
//                                               ls.sort((a, b) => _lastPaymentFilter
//                                                   ? a['loan_last_payment']!
//                                                       .compareTo(b[
//                                                           'loan_last_payment']!)
//                                                   : b['loan_last_payment']!
//                                                       .compareTo(a[
//                                                           'loan_last_payment']!));
//                                               _dataTableBloc.add(
//                                                   const DataTableEvent
//                                                       .rebuild());
//                                             },
//                                             icon: _lastPaymentFilter
//                                                 ? CupertinoIcons
//                                                     .arrow_up_arrow_down_circle_fill
//                                                 : CupertinoIcons
//                                                     .arrow_up_arrow_down_circle,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                   rows: ls
//                                       .getRange(_start,
//                                           ls.length >= 10 ? _end : ls.length)
//                                       .map(
//                                     (e) {
//                                       int index = ls.indexOf(e);
//                                       return DataRow2(
//                                         color: index % 2 != 0
//                                             ? WidgetStateProperty.all(
//                                                 const Color(0XFFB8B8B8)
//                                                     .withOpacity(0.2))
//                                             : null,
//                                         onSelectChanged: (value) {},
//                                         cells: [
//                                           // DataCell(titleText(
//                                           //     text: e['loan_actual_quote']
//                                           //         .toString())),
//                                           DataCell(_popUpMenu(() {}, e)),

//                                           DataCell(Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               titleText(text: e['client_name']),
//                                               EvoBox.h2,
//                                               Align(
//                                                   alignment:
//                                                       Alignment.centerLeft,
//                                                   child: smallTitleText(
//                                                       text: e['loan_code']
//                                                           .toString())),
//                                             ],
//                                           )),
//                                           DataCell(titleText(
//                                               text: formatCurrency(
//                                                   e['loan_quote'].toString()))),
//                                           DataCell(titleText(
//                                               text: formatCurrency(
//                                                   e['loan_amount']
//                                                       .toString()))),
//                                           DataCell(titleText(
//                                               text: formatCurrency(
//                                                   e['loan_quote_late']
//                                                       .toString()))),
//                                           DataCell(titleText(
//                                               text: formatCurrency(
//                                                   e['loan_balance']
//                                                       .toString()))),
//                                           DataCell(titleText(
//                                               text: e['initial_date'])),
//                                           DataCell(
//                                               titleText(text: e['final_date'])),
//                                           DataCell(titleText(
//                                               text: e['loan_late_payments']))
//                                         ],
//                                       );
//                                     },
//                                   ).toList(),
//                                 );
//                               })),
//                       if (ls.isEmpty)
//                         const Center(child: Text("No Record Found")),
//                       EvoBox.h20,
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(top: 16.0),
//                             child: Text(
//                                 "Showing ${_start + 1} to  ${ls.length >= 10 ? _end : ls.length} of ${ls.length} entries"),
//                           ),
//                           const Spacer(),
//                           if (!Responsive.isMobile(context))
//                             Row(
//                               children: _paggination(),
//                             )
//                         ],
//                       ),
//                       EvoBox.h20,
//                       if (Responsive.isMobile(context))
//                         Column(
//                           children: _paggination(),
//                         )
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   /// Pagination controls
//   Widget paginationControls(ValueNotifier<int> page, VoidCallback updateData,
//       int dataLength, int rowsPerPage) {
//     int totalPages = (dataLength / rowsPerPage).ceil();
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: page.value > 0
//               ? () {
//                   page.value--;
//                   updateData();
//                 }
//               : null,
//         ),
//         Text("Page ${page.value + 1} of $totalPages"),
//         IconButton(
//           icon: Icon(Icons.arrow_forward),
//           onPressed: page.value < totalPages - 1
//               ? () {
//                   page.value++;
//                   updateData();
//                 }
//               : null,
//         ),
//       ],
//     );
//   }

//   /// Helper function to format currency values properly
//   String _formatCellValue(dynamic value) {
//     if (value is num) {
//       return "RD\$ ${value.toStringAsFixed(2)}"; // Format numbers as currency
//     }
//     return value.toString();
//   }
// }
