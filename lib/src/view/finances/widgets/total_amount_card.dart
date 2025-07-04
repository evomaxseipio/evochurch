import 'package:evochurch/src/widgets/button/button.dart';
import 'package:flutter/material.dart';

import '../../../constants/constant_index.dart';
import '../../../utils/string_text_utils.dart';

/*Card totalAmoundHeaderCard({Color? cardColor}) {
  return Card(
    elevation: 2,
    color: cardColor ?? EvoColor.boxgreylight,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    shadowColor: EvoColor.boxgreylight,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
              child: customColumnTitle(
                  calculateLoanTotal("loan_amount", loanTransactionProfileList),
                  'Total Restante',
                  size: 16,
                  fontWeight: FontWeight.bold)),
          EvoBox.w16,
          Expanded(
              child: customColumnTitle(
                  calculateLoanTotal(
                      "loan_balance", loanTransactionProfileList),
                  'Total Interes',
                  size: 16,
                  fontWeight: FontWeight.bold)),
          EvoBox.w16,
          Expanded(
              child: customColumnTitle(
                  calculateLoanTotal("loan_quote", loanTransactionProfileList),
                  'Total Atraso',
                  size: 16,
                  fontWeight: FontWeight.bold)),
          EvoBox.w16,
          Expanded(
              child: customColumnTitle(
                  calculateLoanTotal(
                      "loan_late_payments", loanTransactionProfileList),
                  'Total Mora',
                  size: 16,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}

Card totalAmoundHeaderCardWithFilter(ValueNotifier<List<String>> statusList,
    ValueNotifier<List<String>> routeList,
    {Color? cardColor}) {
  return Card(
    elevation: 2,
    color: cardColor ?? EvoColor.boxgreylight,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    shadowColor: EvoColor.boxgreylight,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
              child: customColumnTitle(
                  calculateLoanTotalByFilters("loan_total_amount",
                      loanClientList, statusList, routeList),
                  'Monto Total',
                  size: 16,
                  fontWeight: FontWeight.bold)),
          EvoBox.w16,
          Expanded(
              child: customColumnTitle(
                  calculateLoanTotalByFilters(
                      "loan_fee", loanClientList, statusList, routeList),
                  'Total Interes',
                  size: 16,
                  fontWeight: FontWeight.bold)),
          EvoBox.w16,
          Expanded(
              child: customColumnTitle(
                  calculateLoanTotalByFilters(
                      "loan_late_fee", loanClientList, statusList, routeList),
                  'Total Mora',
                  size: 16,
                  fontWeight: FontWeight.bold)),
          EvoBox.w16,
          Expanded(
              child: customColumnTitle(
                  calculateLoanTotalByFilters(
                      "loan_remaining", loanClientList, statusList, routeList),
                  'Total Restante',
                  size: 16,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}*/
