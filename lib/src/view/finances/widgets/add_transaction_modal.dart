import 'package:evochurch/main.dart';
import 'package:evochurch/src/view_model/expense_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import 'package:evochurch/src/model/transaction_model.dart';
import 'package:evochurch/src/view_model/collection_view_model.dart';
import 'package:evochurch/src/view_model/finance_view_model.dart';
import 'package:evochurch/src/widgets/button/button.dart';
import 'package:evochurch/src/widgets/maintanceWidgets/maintance_widgets.dart';
import 'package:evochurch/src/widgets/modal/modal.dart';

import '../../../constants/constant_index.dart';
import '../../../view_model/auth_services.dart';
import '../../members/widgets/personal_infomation_card.dart';

// Main function to show the modal
void callAddTransactionModal(
  BuildContext context,
  String option, {
  TransactionModel? transaction,
}) {
  final formKey = GlobalKey<FormState>();
  final controllers = Map<String, TextEditingController>.fromEntries(
    transactionControllers
        .map((field) => MapEntry(field, TextEditingController())),
  );

  final financeViewModel =
      Provider.of<FinanceViewModel>(context, listen: false);
  final collectionViewModel =
      Provider.of<CollectionViewModel>(context, listen: false);
  final expensesTypeViewModel =
      Provider.of<ExpensesTypeViewModel>(context, listen: false);

  // Load initial data
  financeViewModel.refreshFunds();
  collectionViewModel.refreshData();
  expensesTypeViewModel.refreshExpensesTypes();

  EvoModal.showModal(
    barrierDismissible: true,
    context: context,
    modelType: ModalType.extraLarge,
    modalType: ModalType.large,
    title: "$option Transaction",
    leadingIcon: _buildLeadingIcon(option),
    content: Consumer<FinanceViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoadingFunds) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.error != null) {
          return Text('Error: ${viewModel.error}');
        }

        final fundsList = viewModel.fundsList
            .map((fund) => {
                  'fund_id': fund.fundId,
                  'fund_name': fund.fundName,
                })
            .toList();

        final expensesTypeList = expensesTypeViewModel.expensesTypeList
            .map((item) => {
                  'expenses_type_id': item.expensesTypeId.toString(),
                  'expenses_name': item.expensesName.toString(),
                })
            .toList();

        return TransactionForm(
          option: option,
          transaction: transaction,
          controllers: controllers,
          formKey: formKey,
          fundsList: fundsList,
          expensesTypeList: expensesTypeList,
        );
      },
    ),
    trailingIcon: const Icon(Icons.cancel_rounded),
    actions: [
      if (option != 'New' && transaction!.authorizedProfileId.isEmptyOrNull)
        _buildAuthButton(context, formKey, controllers),
      EvoBox.w16,
      if (transaction!.authorizedProfileId.isEmptyOrNull)
        _buildSaveButton(context, formKey, controllers, option),
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
    if (option != 'New') {
      controllers['transaction_id']!.text = transaction!.transactionId.toString();
      controllers['transaction_date']!.text = transaction!.transactionDate.toString();
      controllers['fund_id']!.text = transaction!.fundId.toString();
      controllers['expenses_type_id']!.text = transaction!.expensesTypeId.toString();
      controllers['payment_method']!.text = transaction!.paymentMethod;
      controllers['transaction_amount']!.text = transaction!.transactionAmount.toString();
      controllers['transaction_description']!.text = transaction!.transactionDescription;
      controllers['createdBy']!.text = transaction!.createdBy.toString();
      controllers['authorizedBy']!.text = transaction!.authorizedBy.toString();
      controllers['authorizationDate']!.text = transaction!.authorizationDate.toString();
      controllers['fundName']!.text = transaction!.fundName;
      controllers['authorizedProfileId']!.text = transaction!.authorizedProfileId.toString();
      // controllers['created_by_profile_id']!.text = transaction!.authorizedProfileName;
      // controllers['authorizedComments']!.text = transaction!.authorizedComments;
      // controllers['expensesName']!.text = transaction!.expensesName;

      // "churchId": 1,
      //       "transactionId": 2,
      //       "transactionDate": "2024-12-05",
      //       "transactionAmount": 35000.00,
      //       "transactionDescription": "Compra de alimentos en el Bravo",
      //       "transactionStatus": "PENDING",
      //       "expenses_type_id": 6,
      //       "profileId": "92d3a9a3-724b-4e07-93f8-cda6d45b22de",
      //       "createdBy": "Maxima Terrero",
      //       "authorizedProfileId": null,
      //       "authorizedBy": "Pendiente Autorizacion",
      //       "authorizedComments": null,
      //       "authorizationDate": null,
      //       "fundId": "587d8458-b999-4a65-8ae5-d7209aa811b2",
      //       "fundName": "Cocina y Granero Iglesia",
      //       "paymentMethod": "Cash"
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
                _buildTransactionFields(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionFields(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: buildDropdownFieldNew(
                label: 'Fund Name',
                field: 'fund_id',
                controllers: controllers,
                items: fundsList,
                valueKey: 'fund_id',
                displayKey: 'fund_name',
                isRequired: true,
              ),
            ),
            EvoBox.w16,
            Expanded(
              child: buildDropdownFieldNew(
                label: 'Expense Type',
                field: 'expenses_type_id',
                controllers: controllers,
                items: expensesTypeList,
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
            // Expanded(
            //   child: buildDateField(
            //     'Transaction Date',
            //     'transaction_date',
            //     context,
            //     controllers,
            //     isRequired: true,
            //   ),
            // ),
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

Icon? _buildLeadingIcon(String option) {
  return option == 'New'
      ? const Icon(Icons.playlist_add, size: 44)
      : const Icon(FontAwesomeIcons.list, size: 24);
}

Widget _buildAuthButton(
  BuildContext context,
  GlobalKey<FormState> formKey,
  Map<String, TextEditingController> controllers,
) {
  return EvoButton(
    icon: const Icon(Icons.fact_check_outlined),
    onPressed: () => _handleAuthorization(context, formKey, controllers),
    text: "Authorize",
    buttonType: ButtonType.update,
  );
}

_handleAuthorization(BuildContext context, GlobalKey<FormState> formKey,
    Map<String, TextEditingController> controllers) {}

Widget _buildSaveButton(
  BuildContext context,
  GlobalKey<FormState> formKey,
  Map<String, TextEditingController> controllers,
  String option,
) {
  return EvoButton(
    icon: const Icon(Icons.save),
    onPressed: () => _handleSave(context, formKey, controllers, option),
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
  String option,
) async {
  late Map<String, dynamic> response;
  if (!formKey.currentState!.validate()) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill in all required fields.')),
    );
    return;
  }

  try {
    final viewModel = Provider.of<FinanceViewModel>(context, listen: false);
    final authServices = AuthServices();
    final churchId = await authServices.userMetaData?['church_id'];
    final userId = authServices.currentUser?.id;

    // Create transaction object and save
    // ... Add your transaction saving logic here

    debugPrint('Saving transaction...');
    final dataController = controllers.map((key, value) => MapEntry(key, value.text));
    if (option.toLowerCase() == 'new') {
      // Add new transaction
      response = await viewModel.addTransaction(dataController, churchId, userId!);
    } else {
      // Update existing transaction
      response = await viewModel.updateTransaction(dataController);
    }
    if (response['status'] == 'Error') {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Message: ${response['message']}')),
      );
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response['message']}')),
      );

      Navigator.of(context, rootNavigator: true).pop();
    }
  } catch (e) {
    debugPrint(e.toString());
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
}

void _clearControllers(Map<String, TextEditingController> controllers) {
  for (var controller in controllers.values) {
    controller.dispose();
  }
}
