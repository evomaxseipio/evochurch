import 'package:evochurch/src/widgets/widget_index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:evochurch/src/constants/constant_index.dart';
import 'package:evochurch/src/model/model_index.dart';
import 'package:evochurch/src/view/members/widgets/personal_infomation_card.dart';
import 'package:evochurch/src/view_model/index_view_model.dart';
import 'package:evochurch/src/widgets/button/button.dart';
import 'package:evochurch/src/widgets/maintanceWidgets/maintance_widgets.dart';
import 'package:evochurch/src/widgets/modal/modal.dart';

void callUserFormModal(BuildContext context, {AdminUser? user}) {
  final memberViewModel = Provider.of<MembersViewModel>(context, listen: false);
  final usersProvider =
      Provider.of<ConfigurationsViewModel>(context, listen: false);
  final viewModel = Provider.of<AppUserRoleViewModel>(context, listen: false);
  final formKey = GlobalKey<FormState>();

  // Initialize controllers with proper null checks
  final Map<String, TextEditingController> userControllers = {
    'email': TextEditingController(text: user?.userEmail ?? ''),
    'profileId': TextEditingController(text: user?.profileData.profileId.toString() ?? ''),
    'role': TextEditingController(text: user?.profileData.role ?? ''),
    'password': TextEditingController(),
    'confirmPassword': TextEditingController(),
  };

  ValueNotifier<String> selectedRole =
      ValueNotifier(user?.profileData.role ?? '');
  ValueNotifier<String> memberId =
      ValueNotifier(user?.profileData.profileId.toString() ?? '');

  void clearControllers() {
    userControllers.forEach((key, controller) => controller.clear());
  }

  EvoModal.showModal(
    context: context,
    modelType: ModalType.extraLarge,
    modalType: ModalType.extraLarge,
    title: user == null ? 'Create User' : 'Edit User',
    leadingIcon: Icon(
      user == null ? Icons.person_add : Icons.edit,
      size: 28,
    ),
    content: Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // color: Theme.of(context).secondaryHeaderColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildInformationCard('User Information', [
                  buildResponsiveRow(
                    [
                      FutureBuilder(
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
                                              memberId.value)
                                          .toList();

                              return buildDropdownFieldNew(
                                controllers: userControllers,
                                items: memberList,
                                displayKey: 'name',
                                valueKey: 'value',
                                label: 'Church Member',
                                field: 'profileId',
                                isReadOnly: memberId.value.isNotEmpty,
                              );
                            },
                          );
                        },
                      ),
                      FutureBuilder(
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
                                controllers: userControllers,
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
                                isReadOnly: false,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ]),
                EvoBox.h10,
                buildInformationCard('Users Credentials', [
                  buildResponsiveRow(
                    [
                      buildEditableField('Email', 'email', userControllers),
                      buildEditableField(
                          'Password', 'password', userControllers,
                          isPassword: true),
                      buildEditableField('Confirm Password', 'confirmPassword',
                          userControllers,
                          isPassword: true),
                    ],
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    ),
    actions: [
      EvoButton(
        icon: const Icon(Icons.save),
        onPressed: () async {
          AuthResult response = AuthResult(success: false, message: '');
          if (formKey.currentState!.validate()) {
            try {
              final authService =
                  Provider.of<AuthServices>(context, listen: false);

              if (userControllers['password']!.text !=
                  userControllers['confirmPassword']!.text) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:
                        Text('Password and Confirm Password do not match.')));
                return;
              }

              if (user == null) {
                response = await authService.signUp(
                  email: userControllers['email']!.text,
                  password: userControllers['confirmPassword']!.text,
                  userAttributes: {
                    'church_id': authService.userMetaData?['church_id'],
                    'role': userControllers['role']!.text,
                    'profile_id': userControllers['profileId']!.text,
                    'is_active': true,
                  },
                );
              } else {
                response = await authService.updateUserMetadata(
                  churchId:
                      int.parse(authService.userMetaData?['church_id'] ?? '0'),
                  profileId: userControllers['profileId']!.text,
                  role: int.parse(userControllers['role']!.text),
                  isActive: true,
                );
              }
            } catch (e) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('An error occurred. ${e.toString()}')));
            }

            if (!context.mounted) return;
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(response.message)));
            clearControllers();
            if (!context.mounted) return;
            Navigator.of(context, rootNavigator: true).pop();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Please fill in all required fields.')));
          }

          if (response.success) {
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
