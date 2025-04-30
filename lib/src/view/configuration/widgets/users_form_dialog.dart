// user_form_dialog.dart
import 'package:evochurch/src/model/admin_users_model.dart';
import 'package:evochurch/src/view_model/configurations_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class UsersFormDialog extends HookWidget {
  final AdminUser? user;

  const UsersFormDialog({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController(text: user?.userEmail);
    final passwordController = useTextEditingController();
    final firstNameController = useTextEditingController(text: user?.profileData.firstName);
    final lastNameController = useTextEditingController(text: user?.profileData.lastName);
    final selectedRole = useState(user?.profileData.role ?? 'member');
    final isLoading = useState(false);

    return AlertDialog(
      title: Text(user == null ? 'Create User' : 'Edit User'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (user == null) ...[
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ],
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            DropdownButtonFormField<String>(
              value: selectedRole.value,
              items: ['admin', 'member'].map((role) {
                return DropdownMenuItem(value: role, child: Text(role));
              }).toList(),
              onChanged: (value) => selectedRole.value = value!,
              decoration: const InputDecoration(labelText: 'Role'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: isLoading.value
              ? null
              : () async {
                  isLoading.value = true;
                  try {
                    final userProvider = context.read<ConfigurationsViewModel>();

                    if (user == null) {
                      // Create new user
                      await userProvider.createUser(
                        email: emailController.text,
                        password: passwordController.text,
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        role: selectedRole.value,
                      );
                    } else {
                      // Update existing user
                      await userProvider.updateUser(
                        userId: user!.profileData.profileId,
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        role: selectedRole.value,
                      );
                    }
                    if(!context.mounted) return;
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  } finally {
                    isLoading.value = false;
                  }
                },
          child: isLoading.value
              ? const CircularProgressIndicator(strokeWidth: 2)
              : Text(user == null ? 'Create' : 'Update'),
        ),
      ],
    );
  }
}
