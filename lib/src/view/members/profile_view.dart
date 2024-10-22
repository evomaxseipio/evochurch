import 'package:evochurch/src/model/member_model.dart';
import 'package:evochurch/src/view/members/member_maintance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../constants/constant_index.dart';
import '../../utils/responsive.dart';
import '../../widgets/maintanceWidgets/maintance_widgets.dart';
import 'members_index.dart';

class ProfileView extends HookWidget {
  final Member? member;

  const ProfileView({this.member, super.key});

  @override
  Widget build(BuildContext context) {
    final selectedMenuItem = useState('Profile');

    Widget getContent() {
      switch (selectedMenuItem.value) {
        case 'Profile':
          return MemberMaintance(member: member);
        case 'Membership':
          return const MembershipPage();
        case 'Finances':
          return TeamsPage();
        case 'Contacts':
          return Container(
            padding: const EdgeInsets.all(24),
            child: Text('Contacts Family Members',
                style: Theme.of(context).textTheme.headlineMedium),
          );
        case 'Notifications':
          return Container(
            padding: const EdgeInsets.all(24),
            child: Text('Notifications Content',
                style: Theme.of(context).textTheme.headlineMedium),
          );
        case 'Reports':
          return Container(
            padding: const EdgeInsets.all(24),
            child: Text('Data Export Content',
                style: Theme.of(context).textTheme.headlineMedium),
          );
        case 'Delete Account':
          return Container(
            padding: const EdgeInsets.all(24),
            child: Text('Delete Account Content',
                style: Theme.of(context).textTheme.headlineMedium),
          );
        default:
          return Container();
      }
    }

    return Scaffold(
      body: Card(
        child: Row(
          children: [
            // Sidebar
            Responsive.isMobile(context)
                ? const SizedBox.shrink()
                : Container(
                    width: 230,
                    color: Theme.of(context).appBarTheme.surfaceTintColor,
                    height: double.infinity,
                    // decoration: BoxDecoration(
                    //   color: Colors.white,
                    //   border: Border(
                    //     right: BorderSide(color: Colors.grey.shade200),
                    //   ),

                    // ),
                    child: Column(
                      children: [
                        // Fixed header
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            'Account Settings',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        // Scrollable menu items
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              buildSidebarItem(
                                'Profile',
                                selectedMenuItem.value,
                                Icons.person,
                                onTap: () => selectedMenuItem.value = 'Profile',
                              ),
                              buildSidebarItem(
                                'Membership',
                                selectedMenuItem.value,
                                Icons.group,
                                onTap: () =>
                                    selectedMenuItem.value = 'Membership',
                              ),
                              buildSidebarItem(
                                'Finances',
                                selectedMenuItem.value,
                                Icons.attach_money,
                                onTap: () =>
                                    selectedMenuItem.value = 'finances',
                              ),
                              buildSidebarItem(
                                'Contact Family',
                                selectedMenuItem.value,
                                Icons.family_restroom,
                                onTap: () => selectedMenuItem.value = 'contact',
                              ),
                              buildSidebarItem(
                                'Notifications',
                                selectedMenuItem.value,
                                Icons.notifications,
                                onTap: () =>
                                    selectedMenuItem.value = 'Notifications',
                              ),
                              // buildSidebarItem(
                              //   'Billing',
                              //   selectedMenuItem.value,
                              //   onTap: () => selectedMenuItem.value = 'Billing',
                              // ),
                              buildSidebarItem(
                                'Reports',
                                selectedMenuItem.value,
                                Icons.data_thresholding_outlined,
                                onTap: () =>
                                    selectedMenuItem.value = 'Data Export',
                              ),
                              EvoBox.h36,
                              // Delete account at the bottom
                              buildSidebarItem(
                                'Delete Account',
                                selectedMenuItem.value,
                                Icons.delete,
                                isDestructive: true,
                                onTap: () =>
                                    selectedMenuItem.value = 'Delete Account',
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
            // Main Content
            Expanded(
              child: getContent(),
            ),
          ],
        ),
      ),
    );
  }
}
