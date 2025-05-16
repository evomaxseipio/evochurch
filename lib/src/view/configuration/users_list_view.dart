import 'dart:async';

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
    final userList = useState<List<AdminUser>>([]);
    final isLoading = useState<bool>(true);
    final columns = adminUserColumns;

    StreamSubscription? usersSubscription;

    // Determine if we're on a mobile device based on screen width
    final isMobile = MediaQuery.of(context).size.width < 800;

    // Fetch users on initial build
    useEffect(() {
      Future.microtask(() async {
        await userProvider.loadUsers();
        adminUserList.value = userProvider.users;
      });

      fetchUsers() async {
        try {
          isLoading.value = true; // Set loading before fetching

          usersSubscription = userProvider.loadUser().listen(
            (users) async {
              if (!context.mounted) return;
              userList.value = users['users_list'];
              isLoading.value =
                  false; // Set loading to false after data arrives
            },
            onError: (e) {
              if (!context.mounted) return;
              debugPrint('Error loading users: $e');
              isLoading.value = false; // Set loading to false on error
            },
            onDone: () {
              if (!context.mounted) return;
              isLoading.value = false; // Set loading to false on done
            },
          );
        } catch (e) {
          debugPrint('Failed to load users: $e');
          isLoading.value = false;
        }
      }

      fetchUsers();
      return () {
        usersSubscription!.cancel();
        // realtimeSubscription!.cancel();
      };
    }, [userProvider]); // Empty dependency array ensures this runs only once

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

    return Scaffold(
      body: isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : userList.value.isEmpty
              ? const Center(child: Text('No users Found'))
              : ResponsiveuserList(
                  adminUserList: userList,
                  columns: columns,
                  handleuserAction: _handleAction),
    );
  }
}

class ResponsiveuserList extends HookWidget {
  const ResponsiveuserList({
    super.key,
    required this.adminUserList,
    required this.columns,
    required this.handleuserAction,
  });

  final ValueNotifier<List<AdminUser>> adminUserList;
  final List<SortColumn> columns;
  final Function handleuserAction;

  @override
  Widget build(BuildContext context) {
    // Create a search query state
    final searchQuery = useState('');

    // Create and manage the filtered list with useEffect
    final filteredList = useState<List<AdminUser>>([...adminUserList.value]);

    // Effect to update filtered list when original list or search changes
    useEffect(() {
      void updateFilteredList() {
        if (searchQuery.value.isEmpty) {
          filteredList.value = [...adminUserList.value];
          return;
        }

        final lowercaseQuery = searchQuery.value.toLowerCase();
        filteredList.value = adminUserList.value.where((user) {
          return user.profileData.firstName
                  .toLowerCase()
                  .contains(lowercaseQuery) ||
              user.profileData.lastName
                  .toLowerCase()
                  .contains(lowercaseQuery) ||
              user.profileData.roleName
                  .toLowerCase()
                  .contains(lowercaseQuery) ||
              user.userEmail!.toLowerCase().contains(lowercaseQuery);
        }).toList()
          ..sort((a, b) {
            return a.profileData.firstName
                .toLowerCase()
                .compareTo(b.profileData.firstName.toLowerCase());
          });
      }

      // Initial filter
      updateFilteredList();

      // Listen for changes in the original list
      listener() => updateFilteredList();
      adminUserList.addListener(listener);

      // Cleanup
      return () => adminUserList.removeListener(listener);
    }, [adminUserList, searchQuery.value]);

    // Determine if we're on a mobile device based on screen width
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Column(
      children: [
        Expanded(
          child: isMobile
              ? _buildMobileView(
                  context,
                  filteredList.value
                    ..sort(
                      (a, b) => a.profileData.firstName
                          .toLowerCase()
                          .compareTo(b.profileData.firstName.toLowerCase()),
                    ),
                  searchQuery)
              : _buildWebView(context),
        ),
      ],
    );
  }

  Widget _buildWebView(BuildContext context) {
    return CustomPaginatedTable<AdminUser>(
      title: 'Admin Users Directory',
      data: adminUserList.value,
      columns: adminUserColumns,
      getCells: (user) => _buildUserCells(user),
      filterFunction: _filterUser,
      onRowTap: (user) =>
          debugPrint('Selected user: ${user.profileData.firstName}'),
      actionMenuBuilder: _buildActionMenu,
      onActionSelected: (action, user) =>
          handleuserAction(context, action, user),
      tableButtons: _buildTableButtons(context),
    );
  }

  // build the mobile view
  Widget _buildMobileView(BuildContext context, List<AdminUser> adminUserList,
      ValueNotifier<String> searchQuery) {
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
              hintText: 'Search users...',
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
                    child: Text('No users found matching your search criteria'),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: adminUserList.length,
                      itemBuilder: (context, index) {
                        final user = adminUserList[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          // validate and change the color depending is light or dark mode
                          color: context.theme.brightness == Brightness.light
                              ? null
                              : Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(.3),
                          elevation: 2,
                          shadowColor: Theme.of(context).shadowColor,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 4.0),
                          child: ListTile(
                            title: Text(
                              '${user.profileData.firstName} ${user.profileData.lastName}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user.userEmail),
                                StatusChip(status: user.profileData.roleName!),
                              ],
                            ),
                            isThreeLine: true,
                            trailing: PopupMenuButton<String>(
                              onSelected: (action) {
                                handleuserAction(context, action, user);
                              },
                              itemBuilder: (context) =>
                                  _buildActionMenu(context, user),
                            ),
                            onTap: () {
                              debugPrint(
                                  'Selected user: ${user.profileData.firstName}');
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
      BuildContext context, AdminUser user) {
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
}
