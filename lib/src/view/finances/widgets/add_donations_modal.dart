import 'package:evochurch/src/constants/dropdown_list_data.dart';
import 'package:evochurch/src/constants/text_editing_controllers.dart';
import 'package:evochurch/src/model/collection_model.dart';
import 'package:evochurch/src/utils/extension.dart';
import 'package:evochurch/src/view_model/collection_view_model.dart';
import 'package:evochurch/src/view_model/index_view_model.dart';
import 'package:evochurch/src/widgets/widget_index.dart';
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
import '../../../model/member_model.dart';
import '../../../view_model/auth_services.dart';
import '../../members/widgets/personal_infomation_card.dart';

class AddFund extends HookWidget {
  const AddFund({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(child: EvoButton(onPressed: () {})
        // => callDonationModal(context), text: 'Add Donations'),
        );
  }
}

final _formKey = GlobalKey<FormState>();
final Map<String, TextEditingController> _collectionControllers = {};
final Map<String, TextEditingController> _fundsControllers = {};

callDonationModal(BuildContext context, Member? member, String donationType) {
  final viewModel = Provider.of<FinanceViewModel>(context, listen: false);
  final collectionViewModel =
      Provider.of<CollectionViewModel>(context, listen: false);
  final memberViewModel = Provider.of<MembersViewModel>(context, listen: false);
  final List<Map<String, String>> collectionList =
      collectionViewModel.collectionTypes
          .map((item) => {
                'collection_type_id': item.id.toString(), // Handle null id
                'collection_type_name': item.name // Handle null name
              })
          .toList();

  List<FundModel> fundList = viewModel.fundsList;
  final listOfFunds = fundList
      .map((item) => {'fund_id': item.fundId, 'fund_name': item.fundName})
      .toList();

  for (var fund in fundList) {
    fundDataList.add(fund.fundName);
  }

  for (var collection in collectionViewModel.collectionTypes) {
    collectionDataList.add(collection.name);
  }

  // Assign Collection Controllers
  for (var field in collectionControllers) {
    _collectionControllers[field] = TextEditingController();
    if (donationType == 'Diezmos' && field == 'collectionType') {
      _collectionControllers['collectionType']!.text = '1';
    }
  }

  // Assign funds controllers
  for (var field in fundControllers) {
    _fundsControllers[field] = TextEditingController();
  }

  void dispose() {
    _collectionControllers.forEach((key, value) {
      value.dispose();
    });

    _fundsControllers.forEach((key, value) {
      value.dispose();
    });
  }

  EvoModal.showModal(
    barrierDismissible: true,
    context: context,
    modelType: ModalType.extraLarge,
    modalType:
        donationType == 'Diezmos' ? ModalType.large : ModalType.extraLarge,
    title: donationType == 'Diezmos' ? 'Add Tithes' : "Add Contribution",
    leadingIcon: Icon(
      donationType == 'Diezmos' ? EvoIcons.tithes.icon : EvoIcons.offering.icon,
      size: 28,
      color: context.isDarkMode
          ? EvoTheme.dark.colorScheme.onSurface
          : EvoTheme.light.colorScheme.onSurface,
    ),
    content: EvoCard(
      // padding: const EdgeInsets.all(8),
      colorDark: context.isDarkMode
          ? EvoTheme.dark.colorScheme.surface
          : EvoTheme.light.colorScheme.surface,
      colorLight: context.isDarkMode
          ? EvoTheme.dark.colorScheme.surface
          : EvoTheme.light.colorScheme.surface,
      child: Container(
        padding: const EdgeInsets.all(0),
        child: Form(
          key: _formKey,
          // autovalidateMode: AutovalidateMode.disabled,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildInformationCard(
                  '${member!.firstName} ${member.lastName}',
                  [
                    buildResponsiveRow(
                      [
                        buildDropdownFieldNew(
                          label: 'Contribution Type',
                          field: 'collectionType',
                          controllers: _collectionControllers,
                          items: donationType == 'Diezmos'
                              ? collectionList
                              : collectionList
                                  .where((item) =>
                                      item['collection_type_id'] != '1')
                                  .toList(), // Filter only for one type
                          valueKey: 'collection_type_id',
                          displayKey: 'collection_type_name',
                          isRequired: true,
                          isReadOnly: donationType == 'Diezmos' ? true : false,
                        ),
                        buildDropdownField('Transaction Method',
                            'paymentMethod', _collectionControllers),
                        if (donationType != 'Diezmos')
                          buildDropdownFieldNew(
                            label: 'Fund',
                            field: 'fundId',
                            controllers: _collectionControllers,
                            items: listOfFunds,
                            valueKey: 'fund_id',
                            displayKey: 'fund_name',
                            isRequired: true,
                          ),
                      ],
                    ),
                    EvoBox.h16,
                    // Diezmos fields
                    buildResponsiveRow([
                      buildEditableField(
                        'Amount',
                        'collectionAmount',
                        _collectionControllers,
                        isRequired: true,
                        isNumeric: true,
                      ),
                      EvoBox.w10,
                      buildDateField('Contribution Date', 'collectionDate',
                          context, _collectionControllers,
                          isRequired: true),
                    ]),
                    EvoBox.h16,
                    buildResponsiveRow(
                      [
                        buildEditableField('Description', 'collectionComments',
                            _collectionControllers,
                            isRequired: true, maxLine: 3),
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
          if (!_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Please fill in all required fields.')));
            return;
          }

          try {
            final viewModel =
                Provider.of<CollectionViewModel>(context, listen: false);
            final fundViewModel =
                Provider.of<FinanceViewModel>(context, listen: false);
            final authServices =
                Provider.of<AuthServices>(context, listen: false);

            final mainFund =
                fundViewModel.fundsList.firstWhere((x) => x.isPrimary == true);
            final mainCollectionType = viewModel.collectionTypes
                .firstWhere((x) => x.isPrimary == true);

            DateTime startDate = DateFormat('dd/MM/yyyy')
                .parse(_collectionControllers['collectionDate']!.text);

            int churchId = int.parse(authServices.userMetaData?["church_id"]);

            CollectionModel newCollection = CollectionModel(
                churchId: churchId,
                fundId: donationType == 'Diezmos'
                    ? mainFund.fundId
                    : _collectionControllers['fundId']!.text,
                profileId: member.memberId,
                collectionType: donationType == 'Diezmos'
                    ? mainCollectionType.id
                    : int.parse(_collectionControllers['collectionType']!.text),
                collectionAmount: double.parse(
                    _collectionControllers['collectionAmount']!.text),
                collectionDate: startDate,
                isAnonymous: false,
                paymentMethod: _collectionControllers['paymentMethod']!.text,
                comments: _collectionControllers['collectionComments']!.text);

            final responseData =
                await viewModel.createCollection(newCollection.toJson());

            if (responseData['status'] == 'Success') {
              String message =
                  'New Collection is added with ID: ${responseData['message']}';
              memberViewModel.getFinancialByMemberId(member.memberId!);
              memberViewModel.notifyDataChanged();

              if (!context.mounted) return;
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(message)));

              clear();
              Navigator.of(context, rootNavigator: true).pop();
            } else {
              String message =
                  'Failed to add new fund, error: ${responseData['message']}';
              if (!context.mounted) return;
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(message)));
            }
          } catch (e) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.toString())));
          }
        },
        text: "Save",
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
  _collectionControllers.forEach((key, value) {
    value.clear();
  });
}
