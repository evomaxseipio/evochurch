import 'package:evochurch/src/constants/text_editing_controllers.dart';
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

class AddFund extends HookWidget {
  const AddFund({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: EvoButton(
          onPressed: () => callAddFundModal(context), text: 'Add Fund'),
    );
  }
}

final _formKey = GlobalKey<FormState>();
final Map<String, TextEditingController> _fundControllers = {};

callAddFundModal(BuildContext context) {
  // Assign Fund Controllers
  for (var field in fundControllers) {
    _fundControllers[field] = TextEditingController();
  }

  void dispose() {
    _fundControllers.forEach((key, value) {
      value.dispose();
    });
  }

  EvoModal.showModal(
    barrierDismissible: true,
    context: context,
    modelType: ModalType.extraLarge,
    modalType: ModalType.large,
    title: "Add Fund",
    leadingIcon: const Icon(
      FontAwesomeIcons.handHoldingDollar,
      // color: EvoColor.appleDark,
      size: 24,
    ),
    content: Card(
      elevation: 2,
      // color: Colors.white,
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
                  title: 'Fund Information',
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: buildEditableField(
                          'Fund Name',
                          'fundName',
                          _fundControllers,
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
                          'description',
                          _fundControllers,
                          isRequired: true,
                        )),
                      ],
                    ),
                    EvoBox.h16,
                    Row(
                      children: [
                        Expanded(
                            child: buildDateField('Start Date', 'startDate',
                                context, _fundControllers)),
                        EvoBox.w10,
                        Expanded(
                            child: buildDateField('End Date', 'endDate',
                                context, _fundControllers,
                                isRequired: true)),
                      ],
                    ),
                    EvoBox.h16,
                    Row(
                      children: [
                        Expanded(
                            child: buildEditableField(
                          'Target Amount',
                          'targetAmount',
                          _fundControllers,
                          isRequired: true,
                        )),
                      ],
                    ),
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
              final viewModel = Provider.of<FinanceViewModel>(context, listen: false);
              AuthServices _authServices = AuthServices();
              int churchId = await _authServices.userMetaData?['church_id'];

              DateTime startDate = DateFormat('dd/MM/yyyy')
                  .parse(_fundControllers['startDate']!.text);
              DateTime? endDate;
              if (_fundControllers['endDate']!.text.isNotEmpty) {
                endDate = DateFormat('dd/MM/yyyy')
                    .parse(_fundControllers['endDate']!.text);
              }

              final newFund = FundModel(
                churchId: churchId,
                fundName: _fundControllers['fundName']!.text,
                description: _fundControllers['description']!.text,
                targetAmount: double.tryParse(_fundControllers['targetAmount']!.text),
                startDate: startDate,
                endDate: endDate,
              );

             

              final responseData = await viewModel.addFund(newFund);

              if (responseData!['status'] == 'Success') {
                message = 'New fund added with ID: ${responseData['fund_id']}';
                // Process the form data
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                clear();               
                Navigator.of(context, rootNavigator: true).pop();
              } else {
                message =
                    'Failed to add new fund, error: ${responseData['message']}';
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
  _fundControllers.forEach((key, value) {
    value.clear();
  });
}
