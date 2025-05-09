import 'package:evochurch/src/model/model_index.dart';
import 'package:evochurch/src/view_model/members_view_model.dart';
import 'package:evochurch/src/widgets/widget_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

import '../../constants/constant_index.dart';
import '../../model/member_model.dart';

import '../../widgets/maintanceWidgets/maintance_widgets.dart';
import 'widgets/personal_infomation_card.dart';
import 'widgets/top_bar_menus.dart';

class MemberMaintance extends HookWidget {
  final Member? member;

  const MemberMaintance({this.member, super.key});

  @override
  Widget build(BuildContext context) {
    // MembersViewModel viewModel = MembersViewModel();
    Member? currentMember;
    final formKey = GlobalKey<FormState>();
    final profile = useState<Member?>(null);
    final editMode = useState<String?>(null);
    final memberTextControllers =
        useState<Map<String, TextEditingController>>({});
    final addressTextControllers =
        useState<Map<String, TextEditingController>>({});
    final contactTextControllers =
        useState<Map<String, TextEditingController>>({});

    if (member != null) {
      // viewModel.selectedMember = member;
      profile.value = member;
    }

    useEffect(() {
      try {
        // Initialize member controllers
        for (var field in membersControllers) {
          memberTextControllers.value[field] = TextEditingController();
        }

        // Initialize address controllers
        for (var field in addressControllers) {
          addressTextControllers.value[field] = TextEditingController();
        }

        // Initialize contact controllers
        for (var field in contactControllers) {
          contactTextControllers.value[field] = TextEditingController();
        }

        // Populate controllers if profile exists
        if (profile.value != null) {
          currentMember = profile.value;

          // Member Information
          final memberFields = {
            'firstName': currentMember?.firstName ?? '',
            'lastName': currentMember?.lastName ?? '',
            'nickName': currentMember?.nickName ?? '',
            'dateOfBirth': currentMember?.dateOfBirth.toString() ?? '',
            'gender': currentMember?.gender ?? '',
            'maritalStatus': currentMember?.maritalStatus ?? '',
            'nationality': currentMember?.nationality ?? '',
            'idType': currentMember?.idType ?? '',
            'idNumber': currentMember?.idNumber ?? '',
          };

          memberFields.forEach((key, value) {
            memberTextControllers.value[key]?.text = value;
          });

          // Address Information
          final addressFields = {
            'streetAddress': currentMember?.address!.streetAddress ?? '',
            'cityState': currentMember?.address!.cityState ?? '',
            'country': currentMember?.address!.country ?? '',
            'stateProvince': currentMember?.address!.stateProvince ?? '',
          };

          addressFields.forEach((key, value) {
            addressTextControllers.value[key]?.text = value;
          });

          // Contact Information
          final contactFields = {
            'phone': currentMember!.contact!.phone ?? '',
            'mobilePhone': currentMember?.contact!.mobilePhone ?? '',
            'email': currentMember?.contact!.email ?? '',
          };

          contactFields.forEach((key, value) {
            contactTextControllers.value[key]?.text = value;
          });
        }
      } catch (e) {
        print(e);
      }

      // Cleanup function
      return () {
        // Dispose member controllers
        for (var controller in memberTextControllers.value.values) {
          controller.dispose();
        }

        // Dispose address controllers
        for (var controller in addressTextControllers.value.values) {
          controller.dispose();
        }

        // Dispose contact controllers
        for (var controller in contactTextControllers.value.values) {
          controller.dispose();
        }
      };
    }, []);

    updateMember() async {
      try {
        String message = '';

        DateTime birthDate = DateFormat('dd/MM/yyyy')
            .parse(memberTextControllers.value['dateOfBirth']!.text);

        debugPrint(birthDate.toString());
        if (formKey.currentState?.validate() ?? false) {
          try {
            MembersViewModel membersViewModel = MembersViewModel();

            // Add address data
            final addressData = AddressModel(
                streetAddress:
                    addressTextControllers.value['streetAddress']!.text,
                stateProvince:
                    addressTextControllers.value['stateProvince']!.text,
                cityState: addressTextControllers.value['cityState']!.text,
                country: addressTextControllers.value['country']!.text);

            // Add contact data
            final contactData = ContactModel(
                phone: contactTextControllers.value['phone']!.text,
                mobilePhone: contactTextControllers.value['mobilePhone']!.text,
                email: contactTextControllers.value['email']!.text);

            final memberData = Member(
                memberId: currentMember!.memberId,
                churchId: currentMember!.churchId,
                firstName: memberTextControllers.value['firstName']!.text,
                lastName: memberTextControllers.value['lastName']!.text,
                nickName: memberTextControllers.value['nickName']!.text,
                dateOfBirth: DateTime.parse(birthDate.toString()),
                gender: memberTextControllers.value['gender']!.text,
                maritalStatus:
                    memberTextControllers.value['maritalStatus']!.text,
                nationality: memberTextControllers.value['nationality']!.text,
                idType: memberTextControllers.value['idType']!.text,
                idNumber: memberTextControllers.value['idNumber']!.text,
                isMember: false,
                isActive: true,
                bio: memberTextControllers.value['firstName']!.text,
                address: addressData,
                contact: contactData);

            final responseData = await membersViewModel.updateMember(
                memberData, addressData, contactData);

            if (responseData!['status'] == 'Success') {
              message =
                  'Profile updated with ID: ${responseData['profile_id']} succesfully!!!';
              // Process the form data
              if (!context.mounted) return;
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(message)));
              Navigator.of(context, rootNavigator: true).pop();
            } else {
              message =
                  'Fail ed to add new profile, error: ${responseData['message']}';
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
      } catch (e) {
        throw Exception('Failed to load members');
      }
    }

    printMember() async {
      debugPrint('Print Function');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MemberTopMenu(
          onUpdate: updateMember,
          onPrint: printMember,
        ),
        EvoBox.h16,
        Expanded(
            child: Card(
          elevation: 2,
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: ListView(
              children: [
                buildInformationCard(
                  'Personal Information',
                  // title: 'Personal Information',
                  // onEdit: () => editMode.value =
                  //     (editMode.value == 'personal') ? null : 'personal',
                  // children:
                  [
                    // Name fields row
                    buildResponsiveRow([
                      buildEditableField('First Name', 'firstName',
                          memberTextControllers.value),
                      buildEditableField(
                          'Last Name', 'lastName', memberTextControllers.value),
                      buildEditableField(
                          'Nick Name', 'nickName', memberTextControllers.value),
                    ]),
                    EvoBox.h16,
                    // Personal details row
                    buildResponsiveRow([
                      buildDateField('Date of Birth', 'dateOfBirth', context,
                          memberTextControllers.value,
                          isRequired: false),
                      buildDropdownField(
                        'Gender',
                        'gender',
                        memberTextControllers.value,
                      ),
                      buildDropdownField(
                        'Marital Status',
                        'maritalStatus',
                        memberTextControllers.value,
                      ),
                    ]),
                    EvoBox.h16,
                    // ID information row
                    buildResponsiveRow([
                      buildEditableField(
                        'Nationality',
                        'nationality',
                        memberTextControllers.value,
                      ),
                      buildDropdownField(
                          'Id Type', 'idType', memberTextControllers.value,
                          isRequired: false),
                      buildEditableField(
                          'Id number', 'idNumber', memberTextControllers.value,
                          isRequired: false),
                    ]),
                    EvoBox.h16,
                    //
                  ],
                ),
                EvoBox.h14,
                buildInformationCard(
                  'Address Information',
                  [
                    // Address row 1
                    buildResponsiveRow([
                      buildEditableField('Street Address', 'streetAddress',
                          addressTextControllers.value,
                          isRequired: false),
                      buildEditableField('Province', 'stateProvince',
                          addressTextControllers.value,
                          isRequired: false),
                    ]),

                    const SizedBox(height: 16),

                    // Address row 2
                    buildResponsiveRow([
                      buildEditableField('City/State', 'cityState',
                          addressTextControllers.value),
                      buildDropdownField(
                          'Country', 'country', addressTextControllers.value),
                    ]),
                  ],
                ),
                EvoBox.h14,
                buildInformationCard(
                  'Contact Information',
                  [
                    // Contact row
                    buildResponsiveRow([
                      buildEditableField(
                          'Phone Number', 'phone', contactTextControllers.value),
                      buildEditableField(
                          'Mobile Phone', 'mobilePhone', contactTextControllers.value),
                      buildEditableField('Email', 'email', contactTextControllers.value,
                          isRequired: false),
                    ]),
                  ],
                ),
                EvoBox.h14,
              ],
            ),
          ),
        )),
      ],
    );
  }
}
