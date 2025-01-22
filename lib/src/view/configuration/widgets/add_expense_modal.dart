import 'package:evochurch/src/constants/text_editing_controllers.dart';
import 'package:evochurch/src/model/expense_type_model.dart';
import 'package:evochurch/src/view_model/expense_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:evochurch/src/model/fund_model.dart';
import 'package:evochurch/src/view_model/finance_view_model.dart';
import 'package:evochurch/src/widgets/button/button.dart';
import 'package:evochurch/src/widgets/maintanceWidgets/maintance_widgets.dart';
import 'package:evochurch/src/widgets/modal/modal.dart';
import 'package:provider/provider.dart';

import '../../../constants/constant_index.dart';
import '../../../view_model/auth_services.dart';
import '../../members/widgets/personal_infomation_card.dart';

class AddExpense extends HookWidget {
  const AddExpense({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: EvoButton(
          onPressed: () => callAddExpenseModal(context), text: 'Add Fund'),
    );
  }
}

final _formKey = GlobalKey<FormState>();
final Map<String, TextEditingController> _expenseControllers = {};

callAddExpenseModal(BuildContext context) {
  // Assign Fund Controllers
  for (var field in expenseControllers) {
    _expenseControllers[field] = TextEditingController();
  }

  void dispose() {
    _expenseControllers.forEach((key, value) {
      value.dispose();
    });
  }

  EvoModal.showModal(
    barrierDismissible: true,
    context: context,
    modelType: ModalType.extraLarge,
    modalType: ModalType.normal,
    title: "Add Expense Type",
    leadingIcon: const Icon(
      FontAwesomeIcons.handHoldingDollar,
      color: EvoColor.cardBackground,
      size: 24,
    ),
    content: Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(0),
        child: Form(
          key: _formKey,
          // autovalidateMode: AutovalidateMode.disabled,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InformationCard(
                  // backgroundColor: const Color.fromARGB(255, 173, 181, 189),
                  title: 'Expense Type Information',
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: buildEditableField(
                          'Expense Name',
                          'expenseName',
                          _expenseControllers,
                          isRequired: true,
                        )),
                      ],
                    ),
                    EvoBox.h16,
                    Row(
                      children: [
                        Expanded(
                            child: buildEditableField(
                          'Description',
                          'expenseDescription',
                          _expenseControllers,
                          isRequired: true,
                        )),
                      ],
                    ),
                    EvoBox.h16,
                    buildDropdownField(
                        'Category', 'expenseCategory', _expenseControllers),
                    EvoBox.h16,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    trailingIcon: const Icon(Icons.cancel_rounded),
    actions: [
      EvoButton(
        icon: const Icon(Icons.save),
        onPressed: () async {
          String message = '';

          if (_formKey.currentState!.validate()) {
            try {
              final viewModel =
                  Provider.of<ExpensesTypeViewModel>(context, listen: false);
              AuthServices _authServices = AuthServices();
              int churchId = await _authServices.userMetaData?['church_id'];

              // DateTime startDate = DateFormat('dd/MM/yyyy')
              //     .parse(_expenseControllers['startDate']!.text);
              // DateTime? endDate;
              // if (_expenseControllers['endDate']!.text.isNotEmpty) {
              //   endDate = DateFormat('dd/MM/yyyy')
              //       .parse(_expenseControllers['endDate']!.text);
              // }

              final newExpenseType = ExpensesTypeModel(
                  expensesTypeId: 0,
                  churchId: churchId,
                  expensesName: _expenseControllers['expenseName']!.text,
                  expensesDescription: _expenseControllers['expenseDescription']!.text,
                  expensesCategory: _expenseControllers['expenseCategory']!.text,                 
                  isActive: true);

              final responseData = await viewModel.addExpensesType(newExpenseType);

              if (responseData!['status'] == 'Success') {
                message = 'New Expenses Type added with Name: ${responseData['expensesName']}';
                // Process the form data
                if (!context.mounted) return;
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(message)));
                clear();
                Navigator.of(context, rootNavigator: true).pop();
              } else {
                message =
                    'Failed to add new Expenses type, error: ${responseData['message']}';
                if (!context.mounted) return;
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(message)));
              }
            } catch (e) {
              debugPrint(e.toString());
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Please fill in all required fields.')));
          }
        },
        text: "Save",
        //' Strings.cancelLoan,
        buttonType: ButtonType.success,
      ),
      EvoButton(
        icon: const Icon(Icons.cancel),
        onPressed: () {
          clear();
          Navigator.of(context, rootNavigator: true).pop();
        },
        text: 'Close',
        buttonType: ButtonType.error,
      ),
    ],
  );
}

void clear() {
  _expenseControllers.forEach((key, value) {
    value.clear();
  });
}
