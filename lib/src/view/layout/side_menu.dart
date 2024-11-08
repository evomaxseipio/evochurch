import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:evochurch/src/constants/constant_index.dart';
import 'package:evochurch/src/localization/multi_language.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

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
    final isExpanded = useState<Map<String, bool>>({
      'Configurations': false,
      'Pictures': false,
      'Reports': false,
      'Constributions': false,
      'Attendance': false,
    });

    return Container(
      color: Theme.of(context).appBarTheme.surfaceTintColor,
      height: double.infinity,
      width: showOnlyIcon ? 200 : 1000,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Main Menu
            _buildMenuItem(context, languageModel.evochurch.dashboard,
                Icons.dashboard, '/'),
            _buildMenuItem(context, languageModel.evochurch.members,
                Icons.supervisor_account_rounded, '/members'),
            _buildMenuItem(context, languageModel.evochurch.finances,
                Icons.monetization_on_rounded, '/finances'),
            _buildMenuItem(context, languageModel.evochurch.services,
                Icons.church_rounded, '/services'),
            _buildMenuItem(context, languageModel.evochurch.events,
                Icons.event_available_rounded, '/events'),

            EvoBox.h10,
            showOnlyIcon
                ? const SizedBox.shrink()
                : Divider(
                    color: Colors.grey.shade600, indent: 15, endIndent: 15),

            // "Configurations" Section
            _buildExpandableGroup(
              context,
              'Configurations',
              Icons.settings,
              isExpanded,
              [
                _buildMenuItem(context, languageModel.evochurch.members,
                    Icons.supervisor_account_rounded, '/members'),
                _buildMenuItem(context, languageModel.evochurch.finances,
                    Icons.monetization_on_rounded, '/finances'),
                _buildMenuItem(context, languageModel.evochurch.services,
                    Icons.church_rounded, '/services'),
                _buildMenuItem(context, languageModel.evochurch.events,
                    Icons.event_available_rounded, '/events'),
              ],
            ),
            _buildExpandableGroup(
              context,
              'Constributions',
              Icons.monetization_on_outlined,
              isExpanded,
              [
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
              'Pictures',
              Icons.photo_library_outlined,
              isExpanded,
              [
                _buildMenuItem(context, 'Albums', Icons.photo_album_outlined,
                    '/pictures/albums'),
                _buildMenuItem(context, 'Uploads', Icons.file_upload_outlined,
                    '/pictures/uploads'),
              ],
            ),
            _buildExpandableGroup(
              context,
              'Reports',
              Icons.insert_chart_outlined,
              isExpanded,
              [
                _buildMenuItem(context, 'Attendance Report',
                    Icons.bar_chart_outlined, '/reports/attendance'),
                _buildMenuItem(context, 'Donation Report',
                    Icons.pie_chart_outline_rounded, '/reports/donations'),
              ],
            ),

            _buildExpandableGroup(
              context,
              'Attendance',
              Icons.schedule,
              isExpanded,
              [
                _buildMenuItem(context, 'Check-in', Icons.touch_app,
                    '/attendance/checkin'),
                _buildMenuItem(context, 'Reports', Icons.insert_chart,
                    '/attendance/reports'),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, String title, IconData icon, String route) {
    final isActive = GoRouterState.of(context).matchedLocation == route;

    return InkWell(
      onTap: () {
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
            color:
                isActive ? Colors.orange.withOpacity(0.1) : Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isActive ? Colors.orange.shade700 : Colors.grey.shade400,
                size: 20,
              ),
              if (!showOnlyIcon) ...[
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    color: isActive
                        ? Colors.orange.shade700
                        : Colors.grey.shade400,
                    fontWeight: FontWeight.w600,
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
    BuildContext context,
    String title,
    IconData icon,
    ValueNotifier<Map<String, bool>> isExpanded,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            isExpanded.value = {
              ...isExpanded.value,
              title: !isExpanded.value[title]!,
            };
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isExpanded.value[title] == true
                    ? Colors.orange.withOpacity(0.1)
                    : Colors.transparent,
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: isExpanded.value[title] == true
                        ? Colors.orange.shade700
                        : Colors.grey.shade400,
                    size: 20,
                  ),
                  if (!showOnlyIcon) ...[
                    EvoBox.w10,
                    Text(
                      title,
                      style: TextStyle(
                        color: isExpanded.value[title] == true
                            ? Colors.orange.shade700
                            : Colors.grey.shade400,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      isExpanded.value[title] == true
                          ? Icons.expand_less
                          : Icons.expand_more,
                      color: isExpanded.value[title] == true
                          ? Colors.orange.shade700
                          : Colors.grey.shade400,
                      size: 20,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        if (isExpanded.value[title] == true)
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          )
      ],
    );
  }
}
