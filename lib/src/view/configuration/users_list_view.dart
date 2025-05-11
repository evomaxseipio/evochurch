import 'package:evochurch/src/utils/utils_index.dart';
import 'package:evochurch/src/view/auth/widget/users_form_view.dart';
import 'package:evochurch/src/view/configuration/widgets/users_form_dialog.dart';
import 'package:evochurch/src/widgets/maintanceWidgets/status_chip_widget.dart';
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

    // Determine if we're on a mobile device based on screen width
    final isMobile = MediaQuery.of(context).size.width < 800;

    // Fetch users on initial build
    useEffect(() {
      Future.microtask(() async {
        await userProvider.loadUsers();
        adminUserList.value = userProvider.users;
      });
      return null; // No cleanup needed
    }, [userProvider]); // Empty dependency array ensures this runs only once

    return Scaffold(
      body: isMobile
          ? _buildMobileView(context, userProvider, adminUserList.value)
          : _buildBody(context, userProvider, adminUserList.value),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ConfigurationsViewModel userProvider,
    List<AdminUser> adminUserList,
  ) {
    return StreamBuilder<List<AdminUser>>(
      stream: userProvider.adminUsersStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return CustomPaginatedTable<AdminUser>(
          title: 'Admin Users Directory',
          data: snapshot.data!,
          columns: adminUserColumns,
          getCells: (user) => _buildUserCells(user),
          filterFunction: _filterUser,
          onRowTap: _handleRowTap,
          actionMenuBuilder: _buildActionMenu,
          onActionSelected: (action, user) =>
              _handleAction(context, action, user),
          tableButtons: _buildTableButtons(context),
        );
      },
    );
  }

  // build the mobile view
  Widget _buildMobileView(
    BuildContext context,
    ConfigurationsViewModel userProvider,
    List<AdminUser> adminUserList,
  ) {
    // Create a ValueNotifier to hold the search query
    final searchQuery = useState<String>('');
    // Filter the adminUserList based on the search query
    final filteredAdminUserList = adminUserList
        .where((user) => _filterUser(user, searchQuery.value))
        .toList();
    // Update the adminUserList state with the filtered list
    adminUserList = filteredAdminUserList;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Users Directory',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: _buildTableButtons(context)
                    .map((button) => Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: IconButton.filled(
                            onPressed: button.onPressed,
                            icon: button.icon ?? const Icon(Icons.help_outline),
                            // label: Text(button.text),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search members...',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
            onChanged: (query) => searchQuery.value = query,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Card(
            // margin: const EdgeInsets.symmetric(horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 2,
            shadowColor: Theme.of(context).shadowColor,
            child: adminUserList.isEmpty
                ? const Center(
                    child:
                        Text('No members found matching your search criteria'),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: adminUserList.length,
                      itemBuilder: (context, index) {
                        final member = adminUserList[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          elevation: 2,
                          shadowColor: Theme.of(context).shadowColor,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 4.0),
                          child: ListTile(
                            title: Text(
                              '${member.profileData} ${member.profileData.lastName}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(member.userEmail),
                                StatusChip(status: member.profileData.role!),
                              ],
                            ),
                            isThreeLine: true,
                            trailing: PopupMenuButton<String>(
                              onSelected: (action) {
                                _handleAction(context, action, member);
                              },
                              itemBuilder: (context) =>
                                  _buildActionMenu(context, member),
                            ),
                            onTap: () {
                              debugPrint(
                                  'Selected member: ${member.profileData.firstName}');
                            },
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  List<PopupMenuEntry<String>> _buildActionMenu(
      BuildContext context, AdminUser member) {
    return [
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
          leading: Icon(Icons.delete_outline, color: Colors.red),
          title: Text('Delete User', style: TextStyle(color: Colors.red)),
          dense: true,
          visualDensity: VisualDensity.compact,
        ),
      ),
    ];
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

  void _handleAction(
      BuildContext context, String action, AdminUser user) async {
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
