import 'dart:async';

import 'package:evochurch/src/model/member_model.dart';
import 'package:evochurch/src/routes/app_route_constants.dart';
import 'package:evochurch/src/utils/string_text_utils.dart';
import 'package:evochurch/src/view/finances/widgets/add_donations_modal.dart';
import 'package:evochurch/src/view_model/collection_view_model.dart';
import 'package:evochurch/src/view_model/finance_view_model.dart';

import 'package:evochurch/src/view_model/members_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../constants/grid_columns.dart';
import '../../widgets/paginateDataTable/paginated_data_table.dart';
import 'add_member.dart';

// final viewModel = MembersViewModel();
final columns = [
  SortColumn(
    label: 'Name',
    field: 'name',
    getValue: (member) => member.firstName,
  ),
  SortColumn(
    label: 'Nationality',
    field: 'nationality',
    getValue: (member) => member.nationality,
  ),
  SortColumn(
    label: 'Email',
    field: 'email',
    getValue: (member) => member.contact.email,
  ),
  SortColumn(
    label: 'Phone',
    field: 'phone',
    getValue: (member) => member.contact.phone,
  ),
  SortColumn(
    label: 'Date of Birth',
    field: 'dateOfBirth',
    getValue: (member) => member.dateOfBirth,
  ),
];

class MemberList extends HookWidget {
  MemberList({super.key});

  @override
  Widget build(BuildContext context) {
    final SupabaseClient _supabaseClient = Supabase.instance.client;
    final viewModel = Provider.of<MembersViewModel>(context, listen: false);
    final fundViewModel = Provider.of<FinanceViewModel>(context, listen: false);
    final collectionViewModel = Provider.of<CollectionViewModel>(context, listen: false);

    final memberList = useState<List<Member>>([]);
    final isLoading = useState<bool>(true);

    StreamSubscription? membersSubscription;
    StreamSubscription? realtimeSubscription;

    useEffect(() {
      fetchMembers() async {
        try {
          isLoading.value = true; // Set loading before fetching

          membersSubscription = viewModel.getMembers().listen(
            (members) {
              if (!context.mounted) return;
              memberList.value = members['member_list'];
              fundViewModel.refreshFunds();
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

      // Set up realtime subscription
      void setupRealtimeSubscription() {
        realtimeSubscription = _supabaseClient.from('profiles').stream(
            primaryKey: ['id']).listen((List<Map<String, dynamic>> data) {
          // Reload data when changes occur
          fetchMembers();
        }, onError: (error) {
          debugPrint('Realtime subscription error: $error');
        });
      }

      fetchMembers();
      // setupRealtimeSubscription();
      return () {
        membersSubscription!.cancel();
        realtimeSubscription!.cancel();
      };
    }, []);

    void _handleMemberAction(
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
          callDonationModal(context, member, 'Diezmo');
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
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomPaginatedTable<Member>(
                        title: 'Members Directory',
                        data: memberList.value,
                        columns: columns,
                        getCells: (member) => [
                          DataCell(
                              Text('${member.firstName} ${member.lastName}')),
                          DataCell(Text(member.nationality)),
                          DataCell(Text(member.contact!.email!)),
                          DataCell(Text(member.contact!.phone!)),
                          DataCell(
                              Text(formatDate(member.dateOfBirth.toString()))),
                        ],
                        filterFunction: (member, query) {
                          final lowercaseQuery = query.toLowerCase();
                          return member.firstName
                                  .toLowerCase()
                                  .contains(lowercaseQuery) ||
                              member.contact!.email!
                                  .toLowerCase()
                                  .contains(lowercaseQuery) ||
                              member.contact!.phone!.contains(query);
                        },
                        onRowTap: (member) {
                          // Handle member selection
                          debugPrint('Selected member: ${member.firstName}');
                        },
                        actionMenuBuilder: (context, member) => [
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: ListTile(
                              leading: Icon(Icons.edit_outlined),
                              title: Text('Edit Member'),
                              dense: true,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'tithes',
                            child: ListTile(
                              leading: Icon(Icons.paid_outlined),
                              title: Text('Add Tithes'),
                              dense: true,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'donations',
                            child: ListTile(
                              leading: Icon(Icons.attach_money_outlined),
                              title: Text('Add Donations'),
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
                          const PopupMenuDivider(),
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
                        ],
                        onActionSelected: (action, member) {
                          _handleMemberAction(context, action, member);
                        },
                        tableButtons: [
                          CustomTableButton(
                            text: 'Add Member',
                            icon: const Icon(Icons.person_add_alt_1_rounded),
                            onPressed: () {
                              debugPrint('Add Member');
                              callAddEmployeeModal(context);

                              // context.goNamed(
                              // MyAppRouteConstants.memberProfileRouteName,
                              // extra: null);
                            },
                          ),
                          CustomTableButton(
                            text: 'Print',
                            icon: const Icon(Icons.print),
                            onPressed: () async {
                              debugPrint('Print PDF');
                              final viewModel = MembersViewModel();
                              final user = await viewModel.updateUserMetaData();
                              debugPrint(user.toString());
                            },
                          ),
                          CustomTableButton(
                            text: 'Export',
                            icon: const Icon(Icons.download),
                            onPressed: () {
                              debugPrint('debugPrint PDF');
                            },
                          ),
                          // Add more buttons as needed
                        ],
                      ),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
