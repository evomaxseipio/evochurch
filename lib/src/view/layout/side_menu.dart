import 'package:easy_localization/easy_localization.dart';
import 'package:evochurch/main.dart';
import 'package:evochurch/src/routes/app_route_constants.dart';
import 'package:evochurch/src/utils/utils_index.dart';
import 'package:evochurch/src/view_model/menu_state_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:evochurch/src/constants/constant_index.dart';
import 'package:evochurch/src/localization/multi_language.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SideMenu extends HookWidget {
  final bool showOnlyIcon;
  final Function(BuildContext) handleMenuButtonPress;

  const SideMenu({
    super.key,
    required this.showOnlyIcon,
    required this.handleMenuButtonPress,
  });

  @override
  Widget build(BuildContext context) {
    final menuState = context.watch<MenuStateProvider>();

    return Container(
      color: context.isDarkMode
          ? Theme.of(context).appBarTheme.surfaceTintColor
          : Theme.of(context).primaryColor.withOpacity(0.9),
      height: double.infinity,
      width: showOnlyIcon ? 200 : 1000,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Main Menu
            _buildMenuItem(context, 'dashboard'.tr(), Icons.dashboard, '/'),
            _buildMenuItem(context, 'members'.tr(),
                Icons.supervisor_account_rounded, '/members'),
            _buildExpandableGroup(
              context,
              title: 'finances'.tr(),
              icon: Icons.monetization_on_rounded,
              // isExpanded,
              // '/finances',
              childrenRoutes: [
                _buildMenuItem(
                    context,
                    'transactions'.tr(),
                    FontAwesomeIcons.listCheck,
                    MyAppRouteConstants.transactionRouteName,
                    isChild: true),
                _buildMenuItem(context, 'funds'.tr(),
                    FontAwesomeIcons.handHoldingDollar, '/finances/funds',
                    isChild: true),
                _buildMenuItem(context, 'contributionsList'.tr(),
                    FontAwesomeIcons.sackDollar, '/finances/contributions',
                    isChild: true),
              ],
            ),
            _buildMenuItem(context, 'groups'.tr(), Icons.group, '/groups'),
            /*_buildMenuItem(context, languageModel.evochurch.services,
                Icons.church_rounded, '/services'),
            _buildMenuItem(context, languageModel.evochurch.events,
                Icons.event_available_rounded, '/events'),*/

            EvoBox.h10,
            showOnlyIcon
                ? const SizedBox.shrink()
                : Divider(
                    color: Colors.grey.shade600, indent: 15, endIndent: 15),

            // "Configurations" Section
            _buildExpandableGroup(
              context,
              title: 'settings'.tr(),
              icon: Icons.settings,
              // isExpanded,
              // '/',
              childrenRoutes: [
                _buildMenuItem(context, 'expenses'.tr(),
                    Icons.money_off_outlined, '/expenses'),

                _buildMenuItem(context, 'paymentMethods'.tr(),
                    Icons.payments_rounded, '/donations/one-time'),
                // _buildMenuItem(context, languageModel.evochurch.finances,
                //     Icons.monetization_on_rounded, '/finances'),
                // _buildMenuItem(context, languageModel.evochurch.services,
                //     Icons.church_rounded, '/services'),
                // _buildMenuItem(context, languageModel.evochurch.events,
                //     Icons.event_available_rounded, '/events'),
                _buildMenuItem(
                  context,
                  'users'.tr(),
                  Icons.supervisor_account_rounded,
                  MyAppRouteConstants.usersConfigRouteName,
                ),
              ],
            ),
            /* _buildExpandableGroup(
              context,
              title: 'Constributions',
              icon: Icons.monetization_on_outlined,
              // isExpanded,
              // '/donations/one-time',
              childrenRoutes: [
                _buildMenuItem(context, 'Contributions List',
                    FontAwesomeIcons.sackDollar, '/donations/one-time'),
                _buildMenuItem(context, 'Funds',
                    FontAwesomeIcons.handHoldingDollar, '/funds'),
                _buildMenuItem(context, 'Payment Methods',
                    Icons.payments_rounded, '/donations/one-time'),
              ],
            ),

            // Other Expandable Groups
            _buildExpandableGroup(
              context,
              title: 'Pictures',
              icon: Icons.photo_library_outlined,
              // isExpanded,
              // '/',
              childrenRoutes: [
                _buildMenuItem(context, 'Albums', Icons.photo_album_outlined,
                    '/pictures/albums'),
                _buildMenuItem(context, 'Uploads', Icons.file_upload_outlined,
                    '/pictures/uploads'),
              ],
            ),
            _buildExpandableGroup(
              context,
              title: 'Reports',
              icon: Icons.insert_chart_outlined,
              // isExpanded,
              // '/reports',
              childrenRoutes: [
                _buildMenuItem(context, 'Attendance Report',
                    Icons.bar_chart_outlined, '/reports/attendance'),
                _buildMenuItem(context, 'Donation Report',
                    Icons.pie_chart_outline_rounded, '/reports/donations'),
              ],
            ),

            _buildExpandableGroup(
              context,
              title: 'Attendance',
              icon: Icons.schedule,
              // isExpanded,
              // '/attendance',
              childrenRoutes: [
                _buildMenuItem(context, 'Check-in', Icons.touch_app,
                    '/attendance/checkin'),
                _buildMenuItem(context, 'Reports', Icons.insert_chart,
                    '/attendance/reports'),
              ],
            ),*/

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, String title, IconData icon, String route,
      {bool isChild = false}) {
    final isActive = GoRouterState.of(context).matchedLocation == route;
    final menuState = context.watch<MenuStateProvider>();

    return InkWell(
      onTap: () {
        final menuState =
            Provider.of<MenuStateProvider>(context, listen: false);
        if (!isChild) {
          menuState.isChild = false;
        }

        getBasePath(String path) => path.split('/').take(2).join('/');
        menuState.routeName = getBasePath(route);

        switch (menuState.routeName) {
          case '/':
            menuState.selectedIndex = 0;
            break;
          case '/members':
            menuState.selectedIndex = 1;
            break;
          case '/finances':
            menuState.selectedIndex = 2;
            break;

          case '/users':
            menuState.selectedIndex = 5;
            break;
          default:
            menuState.selectedIndex = 0;
        }

        context.go(route);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isActive
                ? Colors.blue.shade400.withOpacity(0.9)
                : Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isActive
                    ? Theme.of(context).colorScheme.onPrimary
                    : Colors.grey.shade400,
                size: isActive ? 22 : 20,
              ),
              if (!showOnlyIcon) ...[
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    color: isActive
                        ? Theme.of(context).colorScheme.onPrimary
                        : Colors.grey.shade400,
                    fontWeight: FontWeight.w100,
                    fontSize: isActive ? 16 : 14,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableGroup(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> childrenRoutes,
  }) {
    final menuState = context.watch<MenuStateProvider>();
    final isOpen = menuState.expandedGroup == title;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            context.read<MenuStateProvider>().toggleGroup(title);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isOpen
                    ? Colors.transparent
                    : Theme.of(context).appBarTheme.surfaceTintColor,
                // : Colors.transparent,
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: isOpen
                        ? Theme.of(context).colorScheme.onPrimary
                        : Colors.grey.shade400,
                    size: isOpen ? 22 : 20,
                  ),
                  if (!showOnlyIcon) ...[
                    EvoBox.w10,
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: isOpen
                              ? Theme.of(context).colorScheme.onPrimary
                              : Colors.grey.shade400,
                          fontWeight: FontWeight.w100,
                          fontSize: isOpen ? 16 : 14,
                        ),
                      ),
                    ),
                    Icon(
                      isOpen ? Icons.expand_less : Icons.expand_more,
                      color: isOpen
                          ? Theme.of(context).colorScheme.onPrimary
                          : Colors.grey.shade400,
                      size: 20,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        if (isOpen)
          Container(
            decoration: BoxDecoration(
              // color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.only(left: 30, right: 8, bottom: 8),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: childrenRoutes,
              ),
            ),
          )
      ],
    );
  }
}
