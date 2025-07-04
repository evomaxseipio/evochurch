import 'package:evochurch/main.dart';
import 'package:evochurch/src/utils/utils_index.dart';
import 'package:evochurch/src/view/message.dart';
import 'package:evochurch/src/view_model/expense_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import 'package:evochurch/src/model/transaction_model.dart';
import 'package:evochurch/src/view_model/finance_view_model.dart';
import 'package:evochurch/src/widgets/button/button.dart';
import 'package:evochurch/src/widgets/maintanceWidgets/maintance_widgets.dart';
import 'package:evochurch/src/widgets/modal/modal.dart';

import '../../../constants/constant_index.dart';
import '../../../view_model/auth_services.dart';
import '../../members/widgets/personal_infomation_card.dart';

// Main function to show the modal
void callAddTransactionModal(
    BuildContext context, String option, FinanceViewModel financeViewModel,
    {TransactionModel? transaction, String? fund_id}) {
  final formKey = GlobalKey<FormState>();
  final controllers = Map<String, TextEditingController>.fromEntries(
    transactionControllers
        .map((field) => MapEntry(field, TextEditingController())),
  );

  final expensesTypeViewModel =
      Provider.of<ExpensesTypeViewModel>(context, listen: false);

  // Load expense types if they're not already loaded
  if (expensesTypeViewModel.expensesTypeList.isEmpty) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      expensesTypeViewModel.getExpensesTypeList();
    });
  }

  // Initialize with empty list if funds list is null or empty
  List<Map<String, String>> fundsList = [];

  if (financeViewModel.fundsList.isNotEmpty) {
    if (fund_id != null) {
      controllers['fund_id']!.text = fund_id;
      fundsList = financeViewModel.fundsList
          .map((fund) => {
                'fund_id': fund.fundId,
                'fund_name': fund.fundName,
              })
          .where((element) => element['fund_id'] == fund_id)
          .toList();

      // Ensure we have at least one item
      if (fundsList.isEmpty) {
        fundsList = financeViewModel.fundsList
            .map((fund) => {
                  'fund_id': fund.fundId,
                  'fund_name': fund.fundName,
                })
            .toList();
      }
    } else {
      fundsList = financeViewModel.fundsList
          .map((fund) => {
                'fund_id': fund.fundId,
                'fund_name': fund.fundName,
              })
          .toList();
    }
  }

  // Safely get expenses type list
  final expensesTypeList = expensesTypeViewModel.expensesTypeList.isEmpty
      ? <Map<String, String>>[]
      : expensesTypeViewModel.expensesTypeList
          .map((item) => {
                'expenses_type_id': item.expensesTypeId.toString(),
                'expenses_name': item.expensesName.toString(),
              })
          .toList();

  EvoModal.showModal(
    barrierDismissible: true,
    context: context,
    modelType: ModalType.extraLarge,
    modalType: ModalType.large,
    title: "$option Transaction",
    leadingIcon: option == 'New'
        ? const Icon(Icons.playlist_add, size: 44)
        : const Icon(FontAwesomeIcons.list, size: 24),
    content: TransactionForm(
      option: option,
      transaction: transaction,
      controllers: controllers,
      formKey: formKey,
      fundsList: fundsList,
      expensesTypeList: expensesTypeList,
    ),
    trailingIcon: const Icon(Icons.cancel_rounded),
    actions: [
      if (option != 'New' && transaction!.authorizedProfileId.isEmptyOrNull)
        _buildAuthButton(
            context, formKey, controllers, financeViewModel),
      // EvoBox.w10,
      // if (transaction!.authorizedProfileId.isEmptyOrNull)
      _buildSaveButton(context, formKey, controllers, financeViewModel, option),
      _buildCloseButton(context, controllers),
    ],
  );
}

// widget for the transaction form
class TransactionForm extends HookWidget {
  final String option;
  final TransactionModel? transaction;
  final Map<String, TextEditingController> controllers;
  final GlobalKey<FormState> formKey;
  final List<Map<String, String>> fundsList;
  final List<Map<String, String>> expensesTypeList;

  const TransactionForm({
    super.key,
    required this.option,
    this.transaction,
    required this.controllers,
    required this.formKey,
    required this.fundsList,
    required this.expensesTypeList,
  });

  @override
  Widget build(BuildContext context) {
    try {
      if (option != 'New') {
        controllers['transaction_id']!.text =
            transaction!.transactionId.toString();
        controllers['transaction_date']!.text =
            transaction!.transactionDate.toString();
        controllers['fund_id']!.text = transaction!.fundId.toString();
        controllers['expenses_type_id']!.text =
            transaction!.expensesTypeId.toString();
        controllers['payment_method']!.text = transaction!.paymentMethod;
        controllers['transaction_amount']!.text =
            transaction!.transactionAmount.toString();
        controllers['transaction_description']!.text =
            transaction!.transactionDescription;
        controllers['createdBy']!.text = transaction!.createdBy.toString();
        controllers['authorizedBy']!.text =
            transaction!.authorizedBy.toString().trim().isEmptyOrNull
                ? 'Pending Approval'
                : transaction!.authorizedBy.toString();
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InformationCard(
              title: 'Transaction Information',
              children: [
                _buildTransactionFields(context, controllers['fund_id']!.text),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionFields(BuildContext context, String? fundId) {

      // Handle empty lists gracefully
    final actualFundsList = fundsList.isEmpty
        ? [
            {'fund_id': '', 'fund_name': 'No funds available'}
          ]
        : fundsList;
    final actualExpensesTypeList = expensesTypeList.isEmpty
        ? [
            {
              'expenses_type_id': '',
              'expenses_name': 'No expense types available'
            }
          ]
        : expensesTypeList;
  

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: buildDropdownFieldNew(
                  label: 'Fund Name',
                  field: 'fund_id',
                  controllers: controllers,
                  items: actualFundsList,
                  valueKey: 'fund_id',
                  displayKey: 'fund_name',
                  isRequired: true,
                  isReadOnly: fundId.isEmptyOrNull ? false : true),
            ),
            EvoBox.w16,
            Expanded(
              child: buildDropdownFieldNew(
                label: 'Expense Type',
                field: 'expenses_type_id',
                controllers: controllers,
                items: actualExpensesTypeList,
                valueKey: 'expenses_type_id',
                displayKey: 'expenses_name',
                isRequired: true,
              ),
            ),
          ],
        ),
        EvoBox.h16,
        Row(
          children: [
            Expanded(
              child: buildDropdownField(
                  'Payment Method', 'payment_method', controllers),
            ),
            EvoBox.w16,
            Expanded(
              child: buildEditableField(
                'Transaction Amount',
                'transaction_amount',
                controllers,
                isRequired: true,
                isNumeric: true,
              ),
            ),
          ],
        ),
        EvoBox.h16,
        buildEditableField(
          'Transaction Description',
          'transaction_description',
          controllers,
          isRequired: true,
          maxLine: 3,
        ),
        if (option != 'New') ...[
          EvoBox.h16,
          Row(
            children: [
              Expanded(
                child: buildEditableField(
                  'Created By',
                  'createdBy',
                  controllers,
                  isRequired: true,
                  isReadOnly: true,
                ),
              ),
              EvoBox.w16,
              Expanded(
                child: buildEditableField(
                  'Authorized By',
                  'authorizedBy',
                  controllers,
                  isRequired: true,
                  isReadOnly: true,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

Widget _buildAuthButton(
  BuildContext context,
  GlobalKey<FormState> formKey,
  Map<String, TextEditingController> controllers,
  FinanceViewModel viewModel,
) {
  return EvoButton(
    icon: const Icon(Icons.fact_check_outlined),
    onPressed: () => _handleAuthorization(context, formKey, controllers, viewModel),
    text: "Authorize",
    buttonType: ButtonType.update,
  );
}

_handleAuthorization(BuildContext context,
  GlobalKey<FormState> formKey,
  Map<String, TextEditingController> controllers,
  FinanceViewModel viewModel) async{
  if (!formKey.currentState!.validate()) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill in all required fields.')),
    );

    return;
  }

   try {
    final authServices = AuthServices();
    final userId = authServices.currentUser?.userMetadata!['profile_id'];

    final dataController =
        controllers.map((key, value) => MapEntry(key, value.text));

    final response =  await viewModel.authorizeTransaction(dataController, userId!);

    if (!context.mounted) return;

    if (response['status'] == 'Error') {
      CupertinoModalOptions.show(
        context: context,
        title: 'Error',
        message: response['message'],
        modalType: ModalTypeMessage.error,
      );
    } else {
      Navigator.of(context, rootNavigator: true).pop();

      /// Delay notifying listeners to avoid calling setState during build
      Future.delayed(Duration.zero, () {
        viewModel.getTransactionList(null);
        viewModel.notifyDataChanged();
      });

      CupertinoModalOptions.show(
        context: context,
        title: 'Success',
        message: response['message'],
        modalType: ModalTypeMessage.success,
      );
    }
  } catch (e) {
    debugPrint(e.toString());
    if (!context.mounted) return;

    CupertinoModalOptions.show(
      context: context,
      title: 'Error',
      message: 'An error occurred while saving the transaction.',
      modalType: ModalTypeMessage.error,
    );
  }
}

Widget _buildSaveButton(
  BuildContext context,
  GlobalKey<FormState> formKey,
  Map<String, TextEditingController> controllers,
  FinanceViewModel viewModel,
  String option,
) {
  return EvoButton(
    icon: const Icon(Icons.save),
    onPressed: () =>
        _handleSave(context, formKey, controllers, viewModel, option),
    text: option == 'New' ? "Save" : "Update",
    buttonType: ButtonType.success,
  );
}

Widget _buildCloseButton(
  BuildContext context,
  Map<String, TextEditingController> controllers,
) {
  return EvoButton(
    icon: const Icon(Icons.cancel),
    onPressed: () {
      _clearControllers(controllers);
      Navigator.of(context, rootNavigator: true).pop();
    },
    text: 'Close',
    buttonType: ButtonType.error,
  );
}

Future<void> _handleSave(
  BuildContext context,
  GlobalKey<FormState> formKey,
  Map<String, TextEditingController> controllers,
  FinanceViewModel viewModel,
  String option,
) async {
  if (!formKey.currentState!.validate()) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill in all required fields.')),
    );
    return;
  }

  try {
    final authServices = AuthServices();
    final userId = authServices.currentUser?.userMetadata!['profile_id'];

    final dataController =
        controllers.map((key, value) => MapEntry(key, value.text));

    final response = option.toLowerCase() == 'new'
        ? await viewModel.addTransaction(dataController, userId!)
        : await viewModel.updateTransaction(dataController);

    if (!context.mounted) return;

    if (response['status'] == 'Error') {
      CupertinoModalOptions.show(
        context: context,
        title: 'Error',
        message: response['message'],
        modalType: ModalTypeMessage.error,
      );
    } else {
      Navigator.of(context, rootNavigator: true).pop();

      /// Delay notifying listeners to avoid calling setState during build
      Future.delayed(Duration.zero, () {
        viewModel.getTransactionList(null);
        viewModel.notifyDataChanged();
      });

      CupertinoModalOptions.show(
        context: context,
        title: 'Success',
        message: response['message'],
        modalType: ModalTypeMessage.success,
      );
    }
  } catch (e) {
    debugPrint(e.toString());
    if (!context.mounted) return;

    CupertinoModalOptions.show(
      context: context,
      title: 'Error',
      message: 'An error occurred while saving the transaction.',
      modalType: ModalTypeMessage.error,
    );
  }
}


void _clearControllers(Map<String, TextEditingController> controllers) {
  for (var controller in controllers.values) {
    controller.dispose();
  }
}
