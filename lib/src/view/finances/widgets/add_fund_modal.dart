import 'package:evochurch/src/constants/text_editing_controllers.dart';
import 'package:evochurch/src/view/message.dart';
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

final _formKey = GlobalKey<FormState>();
final Map<String, TextEditingController> _fundControllers = {};

callAddFundModal(BuildContext context, String? option, FundModel? fund) {
  // Assign Fund Controllers
  for (var field in fundControllers) {
    _fundControllers[field] = TextEditingController();
  }

  // Verify option and fund
  if (option == 'edit' && fund != null) {
    _fundControllers['fundName']!.text = fund.fundName;
    _fundControllers['description']!.text = fund.description!;
    _fundControllers['startDate']!.text =
        DateFormat('dd/MM/yyyy').format(fund.startDate);
    _fundControllers['endDate']!.text =
        DateFormat('dd/MM/yyyy').format(fund.endDate!);
    _fundControllers['targetAmount']!.text = fund.targetAmount.toString();
    _fundControllers['isPrimary']!.text = fund.isPrimary.toString();
    _fundControllers['isActive']!.text = fund.isActive.toString();
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
                        EvoBox.w10,
                        Expanded(
                            child: buildSwitchTile(
                          'Is Primary',
                          'isPrimary',
                          context,
                          _fundControllers,
                          isRequired: false,
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
        text: option == 'edit' ? "Update" : "Save",
        icon: const Icon(Icons.save_outlined),
        buttonType: option == 'edit' ? ButtonType.update : ButtonType.success,
        onPressed: () async {
          String message = '';
          bool confirmationPreceded = false;

          if (_formKey.currentState!.validate()) {
            try {
              final viewModel =
                  Provider.of<FinanceViewModel>(context, listen: false);
              AuthServices _authServices = AuthServices();
              int churchId =
                  int.parse(_authServices.userMetaData?['church_id']);

              // Get Data of primary fund
              FundModel? primaryFund = await viewModel.getFundPrimaryData();

              if ((primaryFund.fundId != fund!.fundId) &&
                  (_fundControllers['isPrimary']!.text == 'true')) {
                // Show dialog to confirm if user wants to change primary fund
                if (!context.mounted) return;
                confirmationPreceded = (await CupertinoModalOptions.show(
                  context: context,
                  title: 'Confirm Action',
                  message: 'Are you sure you want to proceed?',
                  modalType: ModalTypeMessage.confirmation,
                  actions: [
                    ModalAction(
                      text: 'Confirm',
                      isDefaultAction: true,
                      onPressed: () => true,
                    ),
                    ModalAction(
                      text: 'Cancel',
                      isDestructiveAction: true,
                      onPressed: () => false,
                    ),
                  ],
                ))!;

                if (!confirmationPreceded) {
                  _fundControllers['isPrimary']!.text = 'false';
                  return;
                }
              }


              DateTime startDate = DateFormat('dd/MM/yyyy')
                  .parse(_fundControllers['startDate']!.text);
              DateTime? endDate;
              if (_fundControllers['endDate']!.text.isNotEmpty) {
                endDate = DateFormat('dd/MM/yyyy')
                    .parse(_fundControllers['endDate']!.text);
              }

              FundModel newFund = FundModel(
                  fundId: option == 'edit' ? fund!.fundId : '',
                  churchId: churchId,
                  fundName: _fundControllers['fundName']!.text,
                  description: _fundControllers['description']!.text,
                  targetAmount:
                      double.tryParse(_fundControllers['targetAmount']!.text),
                  startDate: startDate,
                  endDate: endDate,
                  isActive: true,
                  isPrimary: _fundControllers['isPrimary']!.text == 'true'
                      ? true
                      : false);

              if (option == 'edit') {
                final responseData = await viewModel.updateFund(newFund);

                if (responseData['status'] == 'Success') {
                  message = 'Fund ${newFund.fundName} updated successfully';
                  // Process the form data
                  if (!context.mounted) return;
                  Navigator.of(context, rootNavigator: true).pop();
                  viewModel.notifyDataChanged();
                  await CupertinoModalOptions.show(
                    context: context,
                    title: 'Success',
                    message: message,
                    modalType: ModalTypeMessage.success,
                  );
                } else {
                  message =
                      'Failed to update fund, error: ${responseData['message']}';
                  if (!context.mounted) return;
                  CupertinoModalOptions.show(
                    context: context,
                    title: 'Error',
                    message: message,
                    modalType: ModalTypeMessage.error,
                  );
                }
              } else {
                final responseData = await viewModel.addFund(newFund);

                if (responseData!['status'] == 'Success') {
                  message =
                      'New fund added with ID: ${responseData['fund_id']}';
                  viewModel.notifyDataChanged();
                  // Process the form data
                  if (!context.mounted) return;
                  CupertinoModalOptions.show(
                    context: context,
                    title: 'Success',
                    message: message,
                    modalType: ModalTypeMessage.success,
                  );
                  clear();
                  Navigator.of(context, rootNavigator: true).pop();
                } else {
                  message =
                      'Failed to add new fund, error: ${responseData['message']}';
                  if (!context.mounted) return;
                  CupertinoModalOptions.show(
                    context: context,
                    title: 'Error',
                    message: message,
                    modalType: ModalTypeMessage.error,
                  );
                }
              }
            } catch (e) {
              debugPrint(e.toString());
            }
          } else {
            if (!context.mounted) return;
            CupertinoModalOptions.show(
              context: context,
              title: 'Error',
              message: 'Failed to save fund, please check your input.',
              modalType: ModalTypeMessage.error,
              actions: [
                ModalAction(
                  text: 'OK',
                  onPressed: () => false,
                ),
              ],
            );
          }
        },
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
