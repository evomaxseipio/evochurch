import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:evochurch/src/constants/constant_index.dart';
import 'package:evochurch/src/model/admin_users_model.dart';
import 'package:evochurch/src/model/model_index.dart';
import 'package:evochurch/src/view/members/widgets/personal_infomation_card.dart';
import 'package:evochurch/src/view_model/index_view_model.dart';
import 'package:evochurch/src/widgets/button/button.dart';
import 'package:evochurch/src/widgets/maintanceWidgets/maintance_widgets.dart';
import 'package:evochurch/src/widgets/modal/modal.dart';

void callUserFormModal(BuildContext context, {AdminUser? user}) {
  final memberViewModel = Provider.of<MembersViewModel>(context, listen: false);
  final viewModel = Provider.of<AppUserRoleViewModel>(context, listen: false);
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _userControllers = {
    'email': TextEditingController(text: user?.userEmail),
    'profileId': TextEditingController(text: user?.profileData.profileId.toString()),
    'role': TextEditingController(text: user?.profileData.role),
    'password': TextEditingController(),
    'confirmPassword': TextEditingController(),
  };
  ValueNotifier<String> selectedRole = ValueNotifier(user?.profileData.roleName ?? 'member');
  ValueNotifier<String> memberId = ValueNotifier(user?.profileData.profileId.toString() ?? '');
  _userControllers['profileId']!.text = user?.profileData.profileId.toString() ?? '';
  _userControllers['role']!.text = user?.profileData.roleName ?? '';


  void clearControllers() {
    _userControllers.forEach((key, controller) => controller.clear());
  }

  EvoModal.showModal(
    context: context,
    modelType: ModalType.extraLarge,
    modalType: ModalType.large,
    title: user == null ? 'Create User' : 'Edit User',
    leadingIcon: Icon(
      user == null ? Icons.person_add : Icons.edit,
      size: 28,
    ),
    content: Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InformationCard(title: 'User Information', children: [
              Row(
                children: [
                  Expanded(
                    child: FutureBuilder(
                      future: memberViewModel.fetchMemberList(),
                      builder: (context, snapshot) {
                        return ValueListenableBuilder<String>(
                          valueListenable: memberId,
                          builder: (context, value, child) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            return buildDropdownFieldNew(
                                controllers: _userControllers,
                                items: memberViewModel.memberList,
                                displayKey: 'name',
                                valueKey: 'value',
                                label: 'Church Member',
                                field: 'profileId');
                          },
                        );
                      },
                    ),
                  ),
                  EvoBox.w10,
                  Expanded(
                    child: FutureBuilder(
                      future: viewModel.fetchRoles(),
                      builder: (context, snapshot) {
                        return ValueListenableBuilder<String>(
                          valueListenable: selectedRole,
                          builder: (context, value, child) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            return buildDropdownFieldNew(
                                controllers: _userControllers,
                                items: viewModel.roles
                                    .map((e) =>
                                        {'name': e.name, 'value': e.name})
                                    .toList(),
                                displayKey: 'name',
                                valueKey:  'value',
                                label: 'Role',
                                field: 'role');
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              EvoBox.w10,
            ]),
            InformationCard(title: 'Users Credentials', children: [
              Row(
                children: [
                  Expanded(
                      child: buildEditableField(
                          'Email', 'email', _userControllers)),
                  EvoBox.w10,
                  Expanded(
                    child: buildEditableField(
                        'Password', 'password', _userControllers,
                        isPassword: true),
                  ),
                  EvoBox.w10,
                  Expanded(
                    child: buildEditableField(
                        'Confirm Password', 'confirmPassword', _userControllers,
                        isPassword: true),
                  ),
                ],
              ),
            ]),
          ],
        ),
      ),
    ),
    actions: [
      EvoButton(
        icon: const Icon(Icons.save),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Handle save logic
            // Example:
            // saveUser(_userControllers, selectedRole.value);

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'User ${user == null ? 'created' : 'updated'} successfully.')));
            clearControllers();
            Navigator.of(context, rootNavigator: true).pop();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Please fill in all required fields.')));
          }
        },
        text: "Save",
        buttonType: ButtonType.success,
      ),
      EvoButton(
        icon: const Icon(Icons.cancel),
        onPressed: () {
          clearControllers();
          Navigator.of(context, rootNavigator: true).pop();
        },
        text: 'Close',
        buttonType: ButtonType.error,
      ),
    ],
  );
}
