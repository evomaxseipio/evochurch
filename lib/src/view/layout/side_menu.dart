import 'package:evochurch/src/constants/constant_index.dart';
import 'package:evochurch/src/localization/multi_language.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SideMenu extends StatelessWidget {
  final bool showOnlyIcon;
  final Function(BuildContext) handleMenuButtonPress;

  const SideMenu({
    super.key,
    required this.showOnlyIcon,
    required this.handleMenuButtonPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).appBarTheme.surfaceTintColor,
      height: double.infinity,
      width: showOnlyIcon ? 200 : 1000,
      child: SingleChildScrollView(
        // Habilitar scrolling
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20), // Espacio superior

            // Menú principal
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

            // _buildMenuItem(context, 'My Offers', Icons.task, '/offert/twelve_products_offert'),

            // Separador
            EvoBox.h10,
            showOnlyIcon
                ? const SizedBox.shrink()
                : Divider(
                    color: Colors.grey.shade600,
                    indent: 15,
                    endIndent: 15,
                  ),

            // Sección de "Groups"
            showOnlyIcon
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Configurations',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.settings,
                              color: Colors.grey.shade500, size: 20),
                          onPressed: () {
                            // Acción para añadir nuevo grupo
                          },
                        ),
                      ],
                    ),
                  ),

            // Elementos del grupo
            _buildGroupMenuItem(
              context,
              'Offer Templates',
              Icons.folder_special_outlined, // Icono personalizado
              '/settings/templates_config?useMockData=true',
            ),
            _buildGroupMenuItem(
              context,
              'Product',
              Icons.local_offer_outlined, // Icono personalizado
              '/settings/products_config',
            ),
            _buildGroupMenuItem(
              context,
              'Users',
              Icons.people, // Icono personalizado
              '/group/remote',
            ),

            const SizedBox(height: 20), // Espacio inferior
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
          padding: const EdgeInsets.symmetric(horizontal: 20,),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isActive ? Colors.orange.withOpacity(0.1) : Colors.transparent,
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
                    color: isActive ? Colors.orange.shade700 : Colors.grey.shade400,
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

  Widget _buildGroupMenuItem(
      BuildContext context, String title, IconData icon, String route) {
    final isActive = GoRouterState.of(context).matchedLocation == route;

    return InkWell(
      onTap: () {
        context.go(route);
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? Colors.green : Colors.grey.shade400,
              size: 20,
            ),
            if (!showOnlyIcon) ...[
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: isActive ? Colors.green : Colors.grey.shade400,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
