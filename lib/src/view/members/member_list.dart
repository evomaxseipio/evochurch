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
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../providers/members_notifier.dart';

import '../../constants/grid_columns.dart';
import '../../widgets/paginateDataTable/paginated_data_table.dart';
import 'add_member.dart';

// final viewModel = MembersViewModel();

class MemberList extends HookConsumerWidget {
  const MemberList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersState = ref.watch(membersNotifierProvider);
    final membersNotifier = ref.read(membersNotifierProvider.notifier);
    final fundViewModel = FinanceViewModel();
    final collectionViewModel = CollectionViewModel();

    if (membersState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (membersState.error != null) {
      return Center(child: Text('Error: \\${membersState.error}'));
    }
    return ResponsiveMemberList(
      memberList: membersState.members,
      fundViewModel: fundViewModel,
      collectionViewModel: collectionViewModel,
      onSelectMember: (member) => membersNotifier.selectMember(member),
      ref: ref,
    );
  }
}

class ResponsiveMemberList extends HookWidget {
  const ResponsiveMemberList({
    super.key,
    required this.memberList,
    required this.fundViewModel,
    required this.collectionViewModel,
    required this.onSelectMember,
    required this.ref,
  });

  final List<Member> memberList;
  final FinanceViewModel fundViewModel;
  final CollectionViewModel collectionViewModel;
  final void Function(Member) onSelectMember;
  final WidgetRef ref;

  void handleMemberAction(BuildContext context, String action, Member member) {
    switch (action) {
      case 'edit':
        onSelectMember(member);
        context.goNamed(MyAppRouteConstants.memberProfileRouteName,
            extra: member);
        break;
      case 'tithes':
        debugPrint('Adding tithes for: \\${member.lastName}');
        callDonationModal(context, member, 'Diezmos');
        break;
      case 'donations':
        debugPrint('Adding donations for: \\${member.lastName}');
        callDonationModal(context, member, 'Ofrenda');
        break;
      case 'message':
        debugPrint('Sending message to: \\${member.bio}');
        break;
      case 'configusers':
        debugPrint('Configuring user for: \\${member.membershipRole}');
        if (member.membershipRole != 'Visita') {
          debugPrint('Member is a member');
        } else {
          debugPrint('Member is not a member');
          if (!context.mounted) return;
          CupertinoModalOptions.show(
            modalType: ModalTypeMessage.error,
            context: context,
            title: 'Error Creating User',
            message: '\\${member.firstName} is not a member',
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
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Delete'),
            content:
                Text('Are you sure you want to delete \\${member.firstName}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // Aquí podrías llamar a membersNotifier.deleteMember si lo implementas
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

  @override
  Widget build(BuildContext context) {
    // Create a search query state
    final searchQuery = useState('');

    // Create and manage the filtered list with useEffect
    final filteredList =useState<List<Member>>([...memberList]);

    // Effect to update filtered list when original list or search changes
    useEffect(() {
      void updateFilteredList() {
        if (searchQuery.value.isEmpty) {
          filteredList.value = [...memberList];
          return;
        }

        final lowercaseQuery = searchQuery.value.toLowerCase();
        filteredList.value = memberList.where((member) {
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
      // memberList.addListener(listener);

      // Cleanup
      return () {
        // memberList.removeListener(listener);
      };
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
      data: memberList,
      columns: memberListColumns,
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
      tableButtons: _buildTableButtons(context, ref),
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
                children: _buildTableButtons(context, ref)
                    .map((button) => Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: IconButton.filled(
                            onPressed: button.onPressed,
                            icon: button.icon ?? const Icon(Icons.help_outline),
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
        )
      ], // Closing bracket for the Column widget
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

  List<CustomTableButton> _buildTableButtons(
      BuildContext context, WidgetRef ref) {
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
