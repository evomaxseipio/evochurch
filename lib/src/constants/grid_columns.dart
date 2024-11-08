

import '../widgets/paginateDataTable/paginated_data_table.dart';


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
