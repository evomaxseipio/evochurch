import 'package:evochurch/src/model/addres_model.dart';
import 'package:evochurch/src/model/contact_model.dart';
import 'package:evochurch/src/model/member_model.dart';
import 'package:evochurch/src/view/members/widgets/personal_infomation_card.dart';
import 'package:evochurch/src/view_model/auth_services.dart';
import 'package:evochurch/src/view_model/members_view_model.dart';
import 'package:evochurch/src/widgets/modal/modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

import '../../constants/constant_index.dart';
import '../../widgets/button/button.dart';
import '../../widgets/maintanceWidgets/maintance_widgets.dart';
import '../../widgets/responsive_widgets.dart';

class AddMember extends HookWidget {
  const AddMember({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: EvoButton(
          onPressed: () => callAddEmployeeModal(context), text: 'Add Member'),
    );
  }
}

ValueNotifier<List<Map<String, dynamic>>> _routeZoneList = ValueNotifier([]);
final _formKey = GlobalKey<FormState>();
final Map<String, TextEditingController> _memberControllers = {};
final Map<String, TextEditingController> _addressControllers = {};
final Map<String, TextEditingController> _contactControllers = {};
final Map<String, String?> _dropdownValues = {};

callAddEmployeeModal(BuildContext context) {
  // Assign Members Controllers
  for (var field in membersControllers) {
    _memberControllers[field] = TextEditingController();
  }

  // Assign Address Controllers
  for (var field in addressControllers) {
    _addressControllers[field] = TextEditingController();
  }

  // Assign Members Controllers
  for (var field in contactControllers) {
    _contactControllers[field] = TextEditingController();
  }

  void dispose() {
    _memberControllers.forEach((key, value) {
      value.dispose();
    });

    _addressControllers.forEach((key, value) {
      value.dispose();
    });

    _contactControllers.forEach((key, value) {
      value.dispose();
    });
  }

  // Clear all controllers

  EvoModal.showModal(
    barrierDismissible: true,
    context: context,
    modelType: ModalType.extraLarge,
    modalType: ModalType.extraLarge,
    title: "Agregar Persona",
    leadingIcon: const Icon(
      Icons.people_alt_outlined,
      // color: EvoColor.appleDark,
      size: 34,
    ),
    content: Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildInformationCard(
                  'Personal Information',
                  [
                    // Name fields row
                    buildResponsiveRow([
                      buildEditableField(
                          'First Name', 'firstName', _memberControllers),
                      buildEditableField(
                          'Last Name', 'lastName', _memberControllers),
                      buildEditableField(
                          'Nick Name', 'nickName', _memberControllers),
                    ]),

                    const SizedBox(height: 16),

                    // Personal details row
                    buildResponsiveRow([
                      buildDateField('Date of Birth', 'dateOfBirth', context,
                          _memberControllers,
                          isRequired: false),
                      buildDropdownField(
                          'Gender', 'gender', _memberControllers),
                      buildDropdownField('Marital Status', 'maritalStatus',
                          _memberControllers),
                    ]),

                    const SizedBox(height: 16),

                    // ID information row
                    buildResponsiveRow([
                      buildEditableField(
                          'Nationality', 'nationality', _memberControllers),
                      buildDropdownField(
                          'Id Type', 'idType', _memberControllers,
                          isRequired: false),
                      buildEditableField(
                          'Id number', 'idNumber', _memberControllers,
                          isRequired: false),
                    ]),
                  ],
                ),
                EvoBox.h12,
                buildInformationCard(
                  'Address Information',
                  [
                    // Address row 1
                    buildResponsiveRow([
                      buildEditableField('Street Address', 'streetAddress',
                          _addressControllers,
                          isRequired: false),
                      buildEditableField(
                          'Province', 'stateProvince', _addressControllers,
                          isRequired: false),
                    ]),

                    const SizedBox(height: 16),

                    // Address row 2
                    buildResponsiveRow([
                      buildEditableField(
                          'City/State', 'cityState', _addressControllers),
                      buildDropdownField(
                          'Country', 'country', _addressControllers),
                    ]),
                  ],
                ),
                EvoBox.h12,
                buildInformationCard(
                  'Contact Information',
                  [
                    // Contact row
                    buildResponsiveRow([
                      buildEditableField(
                          'Phone Number', 'phone', _contactControllers),
                      buildEditableField(
                          'Mobile Phone', 'mobilePhone', _contactControllers),
                      buildEditableField('Email', 'email', _contactControllers,
                          isRequired: false),
                    ]),
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
      ValueListenableBuilder(
          valueListenable: _routeZoneList,
          builder: (context, value, child) {
            return EvoButton(
              icon: const Icon(Icons.save),
              onPressed: () async {
                String message = '';

                DateTime birthDate = DateFormat('dd/MM/yyyy')
                    .parse(_memberControllers['dateOfBirth']!.text);

                debugPrint(birthDate.toString());
                if (false == false) {
                  try {
                    MembersViewModel profileViewModel = MembersViewModel();
                    AuthServices _authServices = AuthServices();
                    final churchId =
                        int.parse(_authServices.userMetaData?['church_id']);

                    final newProfile = Member(
                      churchId: churchId,
                      firstName: _memberControllers['firstName']!.text,
                      lastName: _memberControllers['lastName']!.text,
                      nickName: _memberControllers['nickName']!.text,
                      dateOfBirth: DateTime.parse(birthDate.toString()),
                      gender: _memberControllers['gender']!.text,
                      maritalStatus: _memberControllers['maritalStatus']!.text,
                      nationality: _memberControllers['nationality']!.text,
                      idType: _memberControllers['idType']!.text,
                      idNumber: _memberControllers['idNumber']!.text,
                      isMember: false,
                      isActive: true,
                      bio: _memberControllers['firstName']!.text,
                    );

                    // Add address data
                    final addressData = AddressModel(
                        streetAddress:
                            _addressControllers['streetAddress']!.text,
                        stateProvince:
                            _addressControllers['stateProvince']!.text,
                        cityState: _addressControllers['cityState']!.text,
                        country: _addressControllers['country']!.text);

                    // Add contact data
                    final contactData = ContactModel(
                        phone: _contactControllers['phone']!.text,
                        mobilePhone: _contactControllers['mobilePhone']!.text,
                        email: _contactControllers['email']!.text);

                    final responseData = await profileViewModel.addMember(
                        newProfile, addressData, contactData);

                    if (responseData!['status'] == 'Success') {
                      message =
                          'New profile added with ID: ${responseData['profile_id']}';
                      // Process the form data
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(message)));
                      clear();
                      Navigator.of(context, rootNavigator: true).pop();
                    } else {
                      message =
                          'Failed to add new profile, error: ${responseData['message']}';
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
              text: "Guardar",
              //' Strings.cancelLoan,
              buttonType: ButtonType.success,
            );
          }),
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
  _memberControllers.forEach((key, value) {
    value.clear();
  });

  _addressControllers.forEach((key, value) {
    value.clear();
  });

  _contactControllers.forEach((key, value) {
    value.clear();
  });
}
