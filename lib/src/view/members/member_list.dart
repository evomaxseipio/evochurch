import 'dart:async';

import 'package:evochurch/src/constants/constant_index.dart';
import 'package:evochurch/src/model/member_model.dart';
import 'package:evochurch/src/routes/app_route_constants.dart';
import 'package:evochurch/src/utils/string_text_utils.dart';
import 'package:evochurch/src/view/auth/widget/users_form_view.dart';
import 'package:evochurch/src/view/finances/widgets/add_donations_modal.dart';
import 'package:evochurch/src/view/message.dart';
import 'package:evochurch/src/view_model/collection_view_model.dart';
import 'package:evochurch/src/view_model/finance_view_model.dart';

import 'package:evochurch/src/view_model/members_view_model.dart';
import 'package:evochurch/src/widgets/maintanceWidgets/status_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/grid_columns.dart';
import '../../widgets/paginateDataTable/paginated_data_table.dart';
import 'add_member.dart';

// final viewModel = MembersViewModel();

class MemberList extends HookWidget {
  const MemberList({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MembersViewModel>(context, listen: false);
    final fundViewModel = Provider.of<FinanceViewModel>(context, listen: false);
    final collectionViewModel =
        Provider.of<CollectionViewModel>(context, listen: false);

    final memberList = useState<List<Member>>([]);
    final isLoading = useState<bool>(true);
    final columns = memberListColumns;

    StreamSubscription? membersSubscription;

    useEffect(() {
      fetchMembers() async {
        try {
          isLoading.value = true; // Set loading before fetching

          membersSubscription = viewModel.getMembers().listen(
            (members) async {
              if (!context.mounted) return;
              memberList.value = members['member_list'];
              await fundViewModel.getFundList();
              collectionViewModel.fetchActiveCollectionTypes();
              isLoading.value =
                  false; // Set loading to false after data arrives
            },
            onError: (e) {
              if (!context.mounted) return;
              debugPrint('Error loading members: $e');
              isLoading.value = false; // Set loading to false on error
            },
            onDone: () {
              if (!context.mounted) return;
              isLoading.value = false; // Set loading to false on done
            },
          );
        } catch (e) {
          debugPrint('Failed to load members: $e');
          isLoading.value = false;
        }
      }

      fetchMembers();
      return () {
        membersSubscription!.cancel();
        // realtimeSubscription!.cancel();
      };
    }, []);

    void handleMemberAction(
        BuildContext context, String action, Member member) {
      switch (action) {
        case 'edit':
          viewModel.selectMember(member);
          context.goNamed(MyAppRouteConstants.memberProfileRouteName,
              extra: member);
          break;

        case 'tithes':
          // Handle donations
          debugPrint('Adding tithes for: ${member.lastName}');
          callDonationModal(context, member, 'Diezmos');
          break;

        case 'donations':
          // Handle donations
          debugPrint('Adding donations for: ${member.lastName}');
          callDonationModal(context, member, 'Ofrenda');
          break;

        case 'message':
          // Handle messaging
          debugPrint('Sending message to: ${member.bio}');
          // Example:
          // showDialog(
          //   context: context,
          //   builder: (context) => SendMessageDialog(member: member),
          // );
          break;
        case 'configusers':
          // Handle user configuration
          debugPrint('Configuring user for: ${member.membershipRole}');
          // Validate if the member is a member
          if (member.membershipRole != 'Visita') {
            debugPrint('Member is a member');
          } else {
            debugPrint('Member is not a member');
            if (!context.mounted) return;
            CupertinoModalOptions.show(
              modalType: ModalTypeMessage.error,
              context: context,
              title: 'Error Creating User',
              message: '${member.firstName} is not a member',
              actions: [
                ModalAction(
                  text: 'OK',
                  onPressed: () => true,
                ),
              ],
            );
            return;
          }
          callUserFormModal(context, member: member);
          break;

        case 'delete':
          // Show delete confirmation
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Confirm Delete'),
              content:
                  Text('Are you sure you want to delete ${member.firstName}?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Handle delete
                    Navigator.pop(context);
                  },
                  child:
                      const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
          break;
      }
    }

    return Scaffold(
      body: isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : memberList.value.isEmpty
              ? const Center(child: Text('No Members Found'))
              : ResponsiveMemberList(
                  memberList: memberList,
                  columns: columns,
                  handleMemberAction: handleMemberAction),
    );
  }
}

class ResponsiveMemberList extends HookWidget {
  const ResponsiveMemberList({
    super.key,
    required this.memberList,
    required this.columns,
    required this.handleMemberAction,
  });

  final ValueNotifier<List<Member>> memberList;
  final List<SortColumn> columns;
  final Function handleMemberAction;

  @override
  Widget build(BuildContext context) {
    // Create a search query state
    final searchQuery = useState('');

    // Create and manage the filtered list with useEffect
    final filteredList = useState<List<Member>>([...memberList.value]);

    // Effect to update filtered list when original list or search changes
    useEffect(() {
      void updateFilteredList() {
        if (searchQuery.value.isEmpty) {
          filteredList.value = [...memberList.value];
          return;
        }

        final lowercaseQuery = searchQuery.value.toLowerCase();
        filteredList.value = memberList.value.where((member) {
          return member.firstName.toLowerCase().contains(lowercaseQuery) ||
              member.lastName.toLowerCase().contains(lowercaseQuery) ||
              member.contact!.email!.toLowerCase().contains(lowercaseQuery) ||
              member.membershipRole!.toLowerCase().contains(lowercaseQuery) ||
              member.contact!.phone!.contains(searchQuery.value);
        }).toList()
          ..sort((a, b) {
            return a.firstName
                .toLowerCase()
                .compareTo(b.firstName.toLowerCase());
          });
      }

      // Initial filter
      updateFilteredList();

      // Listen for changes in the original list
      listener() => updateFilteredList();
      memberList.addListener(listener);

      // Cleanup
      return () => memberList.removeListener(listener);
    }, [memberList, searchQuery.value]);

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
                      (a, b) => a.firstName
                          .toLowerCase()
                          .compareTo(b.firstName.toLowerCase()),
                    ),
                  searchQuery)
              : _buildWebView(context),
        ),
      ],
    );
  }

  Widget _buildWebView(BuildContext context) {
    return CustomPaginatedTable<Member>(
      title: 'Members Directory',
      data: memberList.value,
      columns: columns,
      getCells: (member) => [
        DataCell(Text('${member.firstName} ${member.lastName}')),
        DataCell(StatusChip(status: member.membershipRole!)),
        DataCell(Text(member.nationality)),
        DataCell(Text(member.contact!.email!)),
        DataCell(Text(member.contact!.phone!)),
        DataCell(Text(formatDate(member.dateOfBirth.toString()))),
      ],
      filterFunction: (member, query) {
        final lowercaseQuery = query.toLowerCase();
        return member.firstName.toLowerCase().contains(lowercaseQuery) ||
            member.contact!.email!.toLowerCase().contains(lowercaseQuery) ||
            member.membershipRole!.toLowerCase().contains(lowercaseQuery) ||
            member.contact!.phone!.contains(query);
      },
      onRowTap: (member) {
        debugPrint('Selected member: ${member.firstName}');
      },
      actionMenuBuilder: _buildActionMenu,
      onActionSelected: (action, member) {
        handleMemberAction(context, action, member);
      },
      tableButtons: _buildTableButtons(context),
    );
  }

  Widget _buildMobileView(BuildContext context, List<Member> filteredMembers,
      ValueNotifier<String> searchQuery) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Members Directory',
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
            child: filteredMembers.isEmpty
                ? const Center(
                    child:
                        Text('No members found matching your search criteria'),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: filteredMembers.length,
                      itemBuilder: (context, index) {
                        final member = filteredMembers[index];
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
                              '${member.firstName} ${member.lastName}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(member.nationality),
                                Text(member.contact!.phone!),
                                StatusChip(status: member.membershipRole!),
                              ],
                            ),
                            isThreeLine: true,
                            trailing: PopupMenuButton<String>(
                              onSelected: (action) {
                                handleMemberAction(context, action, member);
                              },
                              itemBuilder: (context) =>
                                  _buildActionMenu(context, member),
                            ),
                            onTap: () {
                              debugPrint(
                                  'Selected member: ${member.firstName}');
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

  List<PopupMenuItem<String>> _buildActionMenu(
      BuildContext context, Member member) {
    return [
      const PopupMenuItem<String>(
        value: 'edit',
        child: ListTile(
          leading: Icon(Icons.edit_outlined),
          title: Text('Edit Member'),
          dense: true,
          visualDensity: VisualDensity.compact,
        ),
      ),
      PopupMenuItem<String>(
        value: 'tithes',
        child: ListTile(
          leading: Icon(EvoIcons.tithes.icon),
          title: const Text('Add Tithes'),
          dense: true,
          visualDensity: VisualDensity.compact,
        ),
      ),
      PopupMenuItem<String>(
        value: 'donations',
        child: ListTile(
          leading: Icon(EvoIcons.offering.icon),
          title: const Text('Add Contributions'),
          dense: true,
          visualDensity: VisualDensity.compact,
        ),
      ),
      const PopupMenuItem<String>(
        value: 'message',
        child: ListTile(
          leading: Icon(Icons.message_outlined),
          title: Text('Send Message'),
          dense: true,
          visualDensity: VisualDensity.compact,
        ),
      ),
      const PopupMenuItem<String>(
        value: 'configusers',
        child: ListTile(
          leading: Icon(Icons.supervisor_account_outlined),
          title: Text('Create App User'),
          dense: true,
          visualDensity: VisualDensity.compact,
        ),
      ),
      // const PopupMenuDivider<String>(),
      const PopupMenuItem<String>(
        value: 'delete',
        child: ListTile(
          leading: Icon(
            Icons.delete_outline,
            color: Colors.red,
          ),
          title: Text(
            'Delete Member',
            style: TextStyle(color: Colors.red),
          ),
          dense: true,
          visualDensity: VisualDensity.compact,
        ),
      ),
    ];
  }

  List<CustomTableButton> _buildTableButtons(BuildContext context) {
    return [
      CustomTableButton(
        text: 'Add Member',
        icon: const Icon(Icons.person_add_alt_1_rounded),
        onPressed: () {
          debugPrint('Add Member');
          callAddEmployeeModal(context);
        },
      ),
      CustomTableButton(
        text: 'Print',
        icon: const Icon(Icons.print),
        onPressed: () async {
          debugPrint('Print PDF');
          final viewModel = MembersViewModel();
        },
      ),
      CustomTableButton(
        text: 'Export',
        icon: const Icon(Icons.download),
        onPressed: () {
          debugPrint('Export PDF');
        },
      ),
    ];
  }
}
