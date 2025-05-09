import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:evochurch/src/model/member_model.dart';
import 'package:evochurch/src/view/members/member_maintance.dart';
import '../../utils/responsive.dart';
import 'members_index.dart';

class ProfileView extends HookWidget {
  final Member? member;

  const ProfileView({this.member, super.key});

  @override
  Widget build(BuildContext context) {
    final selectedMenuItem = useState('Profile');
    final scaffoldKey = useMemoized(() => GlobalKey<ScaffoldState>());
    final isMobile = Responsive.isMobile(context);

    void selectMenuItem(String item) {
      selectedMenuItem.value = item;
      if (isMobile) {
        scaffoldKey.currentState?.closeDrawer();
      }
    }

    Widget getContent() {
      switch (selectedMenuItem.value) {
        case 'Profile':
          return MemberMaintance(member: member);
        case 'Membership':
          return const MembershipPage();
        case 'Finances':
          return MemberFinances(member: member);
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

    Widget buildSidebar() {
      return ListView(
        padding: EdgeInsets.zero,
        children: [
          if (isMobile)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Account Settings',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          buildSidebarItem(
            'Profile',
            selectedMenuItem.value,
            Icons.person,
            onTap: () => selectMenuItem('Profile'),
          ),
          buildSidebarItem(
            'Membership',
            selectedMenuItem.value,
            Icons.group,
            onTap: () => selectMenuItem('Membership'),
          ),
          buildSidebarItem(
            'Finances',
            selectedMenuItem.value,
            Icons.attach_money,
            onTap: () => selectMenuItem('Finances'),
          ),
          const SizedBox(height: 40),
          buildSidebarItem(
            'Delete Account',
            selectedMenuItem.value,
            Icons.delete,
            isDestructive: true,
            onTap: () => selectMenuItem('Delete Account'),
          ),
        ],
      );
    }

    Widget buildMobileLayout() {
      return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(selectedMenuItem.value),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
          ),
        ),
        drawer: Drawer(
          child: buildSidebar(),
        ),
        body: getContent(),
      );
    }

    Widget buildDesktopLayout() {
      return Scaffold(
        body: Card(
          child: Row(
            children: [
              // Sidebar
              Container(
                width: 230,
                color: Theme.of(context).appBarTheme.surfaceTintColor,
                height: double.infinity,
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
                      child: buildSidebar(),
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

    return isMobile ? buildMobileLayout() : buildDesktopLayout();
  }

  Widget buildSidebarItem(
    String title,
    String selectedItem,
    IconData icon, {
    bool isDestructive = false,
    required VoidCallback onTap,
  }) {
    final isSelected = title == selectedItem;
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive
            ? Colors.red
            : isSelected
                ? Colors.blue
                : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive
              ? Colors.red
              : isSelected
                  ? Colors.blue
                  : Colors.grey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: onTap,
    );
  }
}
