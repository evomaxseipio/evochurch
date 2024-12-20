

import '../widgets/paginateDataTable/paginated_data_table.dart';


final transactionColumns = [
  SortColumn(
    label: 'Fund Name',
    field: 'fundName',
    getValue: (transac) => transac.fundName,
  ),
  
  SortColumn(
    label: 'Transaction Description',
    field: 'transactionDescription',
    getValue: (transac) => transac.transactionDescription,
  ),
  SortColumn(
    label: 'Transaction Amount',
    field: 'transactionAmount',
    // numeric: true,
    getValue: (transac) => transac.transactionAmount,
  ),
  SortColumn(
    label: 'Status',
    field: 'transactionStatus',
    getValue: (transac) => transac.transactionStatus,
  ),
  SortColumn(
    label: 'Created By',
    field: 'createdBy',
    getValue: (transac) => transac.createdBy,
  ),
  SortColumn(
    label: 'Created At',
    field: 'transactionDate',
    getValue: (transac) => transac.transactionDate,
  ),
  SortColumn(
    label: 'Authorized By',
    field: 'authorizedBy',
    getValue: (transac) => transac.authorizedBy,
  ),
  SortColumn(
    label: 'Authorized At',
    field: 'authorizationDate',
    getValue: (transac) => transac.authorizationDate,
  )
];

final contributionColumns = [
  SortColumn(
    label: 'Fund Name',
    field: 'fundName',
    getValue: (fund) => fund.fundName,
  ),
  SortColumn(
    label: 'Description',
    field: 'description',
    getValue: (fund) => fund.description,
  ),
  SortColumn(
    label: 'Target Amount',
    field: 'targetAmount',
    getValue: (fund) => fund.targetAmount,
  ),
  SortColumn(
    label: 'Total Contributions',
    field: 'totalContributions',
    getValue: (fund) => fund.totalContributions,
  ),
  SortColumn(
    label: 'Start Date',
    field: 'startDate',
    getValue: (fund) => fund.startDate,
  ),
  SortColumn(
    label: 'End Date',
    field: 'endDate',
    getValue: (fund) => fund.endDate,
  ),
];



final expenseTypeColumns = [
  SortColumn(
    label: 'Expense Name',
    field: 'expensesName',
    getValue: (expense) => expense.expensesName,
  ),
  SortColumn(
    label: 'Category',
    field: 'expensesCategory',
    getValue: (expense) => expense.expensesCategory,
  ),
  SortColumn(
    label: 'Description',
    field: 'expensesDescription',
    getValue: (expense) => expense.expensesDescription,
  ),
  SortColumn(
    label: 'Status',
    field: 'isActive',
    getValue: (expense) => expense.isActive,
  ),
];
