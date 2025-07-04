import 'package:evochurch/src/model/transaction_model.dart';

final membersControllers = [
  'firstName',
  'lastName',
  'nickName',
  'dateOfBirth',
  'gender',
  'maritalStatus',
  'nationality',
  'idType',
  'idNumber',
  'isMember',
  'isActive',
  'isMember',
  'bio',
];

final addressControllers = [
  'streetAddress',
  'stateProvince',
  'cityState',
  'country'
];

final contactControllers = ['phone', 'mobilePhone', 'email'];

final membershipControllers = [
  'baptismDate',
  'baptismChurch',
  'baptismPastor',
  'membershipRole',
  'baptismChurchCity',
  'baptismChurchCountry',
  'hasCredential',
  'credentialType',
  'credetialYear',
  'isBaptizedInSpirit',
];

final historyControllers = [
  'dateStart',
  'dateReturn',
  'observations',
];

final fundControllers = [
  'fundId',
  'churchId',
  'fundName',
  'description',
  'targetAmount',
  'startDate',
  'endDate',
  'isPrimary',
  'isActive',
];

final collectionControllers = [
  'fundId',
  'memberId',
  'collectionType',
  'collectionAmount',
  'isAnonymous',
  'paymentMethod',
  'collectionDate',
  'collectionComments',
  
];

final expenseControllers = [
  'expenseId',
  'churchId',
  'expenseName',
  'expenseCategory',
  'expenseDescription',
  'expenseIsActive'
];

final transactionControllers = [
'church_id',
'transaction_id',
'expenses_type_id',
'fund_id',
'created_by_profile_id',
'createdBy',
'authorized_by_profile_id',
'authorizedBy',
'authorization_status',
'authorization_date',
'authorization_comments',
'transaction_amount',
'transaction_date',
'transaction_description',
'payment_method',
'reference_number',
'is_verified'
];

