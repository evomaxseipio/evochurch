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
  final usersProvider = Provider.of<ConfigurationsViewModel>(context, listen: false);
  final viewModel = Provider.of<AppUserRoleViewModel>(context, listen: false);
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _userControllers = {
    'email': TextEditingController(text: user?.userEmail),
    'profileId': TextEditingController(text: user?.profileData.profileId.toString()),
    'role': TextEditingController(text: user?.profileData.role),
    'password': TextEditingController(),
    'confirmPassword': TextEditingController(),
  };
  ValueNotifier<String> selectedRole = ValueNotifier(user?.profileData.role ?? '');
  ValueNotifier<String> memberId = ValueNotifier(user?.profileData.profileId.toString() ?? '');
  _userControllers['profileId']!.text = user?.profileData.profileId.toString() ?? '';
  _userControllers['role']!.text = user?.profileData.role ?? '';
  _userControllers['password']!.text = user == null ? '' : 'fakePassword';
  _userControllers['confirmPassword']!.text = user == null ? '' : 'fakePassword';


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

                            // Filter the list in case is editing
                            final List<Map<String, String>> memberList =
                                memberId.value.isEmpty
                                    ? memberViewModel.memberList
                                    : memberViewModel.memberList
                                        .where((element) =>
                                            element['value'] ==
                                            user?.profileData.profileId)
                                        .toList();

                            return buildDropdownFieldNew(
                                controllers: _userControllers,
                                items: memberList,
                                displayKey: 'name',
                                valueKey: 'value',
                                label: 'Church Member',
                                field: 'profileId',
                                isReadOnly:
                                    memberId.value.isEmpty ? false : true);
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
                                    .map((e) => {
                                          'name': e.name,
                                          'value': e.id.toString()
                                        })
                                    .toList(),
                                displayKey: 'name',
                                valueKey: 'value',
                                label: 'Role',
                                field: 'role',
                                isReadOnly: false);
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
        onPressed: () async {
          AuthResult response = AuthResult(success: false, message: '');
          if (_formKey.currentState!.validate()) {
            // Handle save logic
            // Example:

            try {
              final authService =
                  Provider.of<AuthServices>(context, listen: false);

              /// Compare the password and confirm password
              /// If they are not the same, show a snackbar with the error message
              /// Else, proceed with the sign up process
              if (_userControllers['password']!.text !=
                  _userControllers['confirmPassword']!.text) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:
                        Text('Password and Confirm Password do not match.')));
                return;
              }

             

              // If user is not editing, create a new user
              // Else, update the user
              if (user == null) {
                response = await authService.signUp(
                  email: _userControllers['email']!.text,
                  password: _userControllers['confirmPassword']!.text,
                  userAttributes: {
                    'church_id': authService.userMetaData?['church_id'],
                    'role': _userControllers['role']!.text,
                    'profile_id': _userControllers['profileId']!.text,
                    'is_active': true,
                  },
                );
               
                } else {
                  // update the user
                  response = await authService.updateUserMetadata(
                        churchId: int.parse(authService.userMetaData?['church_id']),
                        profileId: _userControllers['profileId']!.text,
                        role: int.parse(_userControllers['role']!.text),
                        isActive: true                      
                      );

                }                               
              
            } catch (e) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('An error occurred. ${e.toString()}'),));
            }

            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(response.message)));
            clearControllers();
            if (!context.mounted) return;
            Navigator.of(context, rootNavigator: true).pop();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Please fill in all required fields.')));
          }

           if (response.success) {
            // Refresh the user list after updating
            await usersProvider.loadUsers();
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


////////////////////////////////////////////////////////////////
// Pending create the update method

