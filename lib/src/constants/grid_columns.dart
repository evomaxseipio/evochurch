

import '../widgets/paginateDataTable/paginated_data_table.dart';

// Members Columns List
final memberListColumns = [
  SortColumn(
    label: 'Name',
    field: 'name',
    getValue: (member) => member.firstName,
  ),
  SortColumn(
    label: 'Role',
    field: 'role',
    getValue: (member) => member.membershipRole,
  ),
  SortColumn(
    label: 'Nationality',
    field: 'nationality',
    getValue: (member) => member.nationality,
  ),
  SortColumn(
    label: 'Email',
    field: 'email',
    getValue: (member) => member.contact.email,
  ),
  SortColumn(
    label: 'Phone',
    field: 'phone',
    getValue: (member) => member.contact.phone,
  ),
  SortColumn(
    label: 'Date of Birth',
    field: 'dateOfBirth',
    getValue: (member) => member.dateOfBirth,
  ),
];

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
    label: 'IS Primary',
    field: 'isPrimary',
    getValue: (fund) => fund.isPrimary,
  ),
  SortColumn(
    label: 'Is Active',
    field: 'isActive',
    getValue: (fund) => fund.isActive,
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


final adminUserColumns = [
  // SortColumn(
  //   label: 'Actions',
  //   field: 'profileId',
  //   getValue: (user) => user.profileData.profileId,
  // ),
  
  SortColumn(
    label: 'Email',
    field: 'userEmail',
    getValue: (user) => user.userEmail,
  ),
  SortColumn(
    label: 'First Name',
    field: 'firstName',
    getValue: (user) => user.profileData.firstName,

  ),
  SortColumn(
    label: 'Last Name',
    field: 'lastName',
    getValue: (user) => user.profileData.lastName,
  ),
  SortColumn(
    label: 'Role',
    field: 'role',
    getValue: (user) => user.profileData.role,
  ),
   SortColumn(
    label: 'Last Sign Attempt',
    field: 'lastSignInAt',
    getValue: (user) => user.lastSignInAt,
  ),
 
  
];