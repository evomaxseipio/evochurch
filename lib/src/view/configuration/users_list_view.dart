import 'package:evochurch/src/utils/utils_index.dart';
import 'package:evochurch/src/view/auth/widget/users_form_view.dart';
import 'package:evochurch/src/view/configuration/widgets/users_form_dialog.dart';
import 'package:evochurch/src/widgets/paginateDataTable/paginated_data_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

// import 'package:evochurch/src/constants/grid_columns.dart';
import 'package:evochurch/src/model/admin_users_model.dart';
import 'package:evochurch/src/view_model/configurations_view_model.dart';

import '../../constants/grid_columns.dart';

class UsersListView extends HookWidget {
  const UsersListView({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<ConfigurationsViewModel>();
    final adminUserList = useState<List<AdminUser>>(userProvider.users);

    // Fetch users on initial build
    useEffect(() {
      Future.microtask(() async {
        await userProvider.loadUsers();
        adminUserList.value = userProvider.users;
      });
      return null; // No cleanup needed
    }, []); // Empty dependency array ensures this runs only once

    return Scaffold(
      body: _buildBody(context, userProvider, adminUserList.value),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ConfigurationsViewModel userProvider,
    List<AdminUser> adminUserList,
  ) {
    if (userProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userProvider.error != null) {
      return Center(child: Text(userProvider.error!));
    }

    return CustomPaginatedTable<AdminUser>(
      title: 'Admin Users Directory',
      data: adminUserList,
      columns: adminUserColumns,
      getCells: (user) => [
        ..._buildUserCells(user), // User data columns
      ],
      filterFunction: (user, query) => _filterUser(user, query),
      onRowTap: (user) => _handleRowTap(user),
      actionMenuBuilder: (context, member) => [
        const PopupMenuItem<String>(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit_outlined),
            title: Text('Edit User'),
            dense: true,
            visualDensity: VisualDensity.compact,
          ),
        ),
         const PopupMenuItem<String>(
          value: 'change_password',
          child: ListTile(
            leading: Icon(Icons.lock_reset_outlined),
            title: Text('Change Password'),
            dense: true,
            visualDensity: VisualDensity.compact,
          ),
        ),
        
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            leading: Icon(
              Icons.delete_outline,
              color: Colors.red,
            ),
            title: Text(
              'Delete User',
              style: TextStyle(color: Colors.red),
            ),
            dense: true,
            visualDensity: VisualDensity.compact,
          ),
        ),
      ],
      onActionSelected: (action, user) => _handleAction(context, action, user),
      tableButtons: _buildTableButtons(context),
    );
  }

  List<DataCell> _buildUserCells(AdminUser user) {
    return [
      DataCell(Text(user.userEmail)), // Email
      DataCell(Text(user.profileData.firstName)), // First Name
      DataCell(Text(user.profileData.lastName)), // Last Name
      DataCell(Text(user.profileData.roleName)), // Role
      DataCell(Text(formatDate(user.lastSignInAt.toString()))), // Last Sign-In
    ];
  }

  bool _filterUser(AdminUser user, String query) {
    final lowercaseQuery = query.toLowerCase();
    return user.profileData.firstName!.toLowerCase().contains(lowercaseQuery) ||
        user.profileData.lastName!.toLowerCase().contains(lowercaseQuery) ||
        user.userEmail.toLowerCase().contains(lowercaseQuery) ||
        user.profileData.role!.toLowerCase().contains(lowercaseQuery);
  }

  List<CustomTableButton> _buildTableButtons(BuildContext context) {
    return [
      CustomTableButton(
        text: 'Add User',
        icon: const Icon(Icons.person_add_alt_1_rounded),
        onPressed: () => callUserFormModal(context),
      ),
      CustomTableButton(
        text: 'Print',
        icon: const Icon(Icons.print),
        onPressed: () => debugPrint('Print PDF'),
      ),
      CustomTableButton(
        text: 'Export',
        icon: const Icon(Icons.download),
        onPressed: () => debugPrint('Export PDF'),
      ),
    ];
  }

  void _handleAction(BuildContext context, String action, AdminUser user) {
    switch (action) {
      case 'edit':
        _showEditDialog(context, user: user);
        break;
      case 'delete':
        _showDeleteConfirmation(context, user);
        break;
      default:
        debugPrint('Selected action: $action');
    }
  }

  void _handleRowTap(AdminUser user) {
    debugPrint('Selected member: ${user.profileData.firstName}');
  }

  void _showEditDialog(BuildContext context, {AdminUser? user}) {
    callUserFormModal(context, user: user!);
  }

  void _showDeleteConfirmation(BuildContext context, AdminUser user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.userEmail}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await context
                    .read<ConfigurationsViewModel>()
                    .deleteUser(user.userId);
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User deleted successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete user: $e')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
