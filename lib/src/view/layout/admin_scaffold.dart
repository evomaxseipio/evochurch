import 'package:evochurch/src/constants/constant_index.dart';
import 'package:evochurch/src/localization/multi_language.dart';
import 'package:evochurch/src/utils/utils_index.dart';
import 'package:evochurch/src/view_model/auth_services.dart';
import 'package:evochurch/src/view_model/theme_view_model.dart';
import 'package:evochurch/src/widgets/text/custom_text.dart';
import 'package:evochurch/src/widgets/widget_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'side_menu.dart';

class AdminScaffold extends StatelessWidget {
  final Widget body;
  final String title;

  AdminScaffold({super.key, required this.body, this.title = 'Dashboard'});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ValueNotifier<bool> _isOpen = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final bool isLargeOrMediumWeb =
        EvoResponsive.isLargeWeb(context) || EvoResponsive.isMediumWeb(context);
    return Scaffold(
      key: _scaffoldKey,
      // backgroundColor:
      //     context.isDarkMode ? EvoColor.cardDark : EvoColor.lightBackgroundBlue,
      drawer: isLargeOrMediumWeb ? null : _buildSliderMenu(),
      body: Row(
        children: [
          if (isLargeOrMediumWeb) _buildSliderMenu(),
          Expanded(
            child: Scaffold(
              appBar: _buildInnerAppBar(context),
              body: _buildBody(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderMenu() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isOpen,
      builder: (context, showOnlyIcon, _) {
        final bool isLargeOrMediumWeb = EvoResponsive.isLargeWeb(context) ||
            EvoResponsive.isMediumWeb(context);

        return Container(
          color: context.isDarkMode
              ? EvoColor.cardDark
              : EvoColor.lightBackgroundBlue,
          width: isLargeOrMediumWeb
              ? (!showOnlyIcon ? 230 : 80)
              : MediaQuery.of(context).size.width * 0.33,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isLargeOrMediumWeb) EvoBox.h14 else EvoBox.h14,
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ),
                child: _buildDrawerHeader(showOnlyIcon && isLargeOrMediumWeb),
              ),
              EvoBox.h12,
              Expanded(
                  child: SideMenu(
                      showOnlyIcon: showOnlyIcon,
                      handleMenuButtonPress: _handleMenuButtonPress)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawerHeader(bool showOnlyIcon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          IconlyBroken.adminKit,
          height: 24,
        ),
        if (!showOnlyIcon) ...[
          EvoBox.w12,
          Text(
            EvoStrings.projectName.toUpperCase(),
            style: const TextStyle(color: EvoColor.white, fontSize: 18),
          ),
        ],
      ],
    );
  }

  AppBar _buildInnerAppBar(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return AppBar(
      backgroundColor:
          context.isDarkMode ? EvoColor.cardDark : EvoColor.lightBackgroundBlue,
      elevation: 0,
      toolbarHeight: 60,
      automaticallyImplyLeading: false,
      centerTitle: false,
      leading: _buildMenuButton(context),
      // title: Text(title),
      titleSpacing: 24.0,
      actions: [
        EvoBox.w10,
        IconButton(
          onPressed: () {
            themeProvider.toggleTheme();
          },
          icon: Icon(
            !context.isDarkMode
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined,
            color: context.isDarkMode
                ? EvoColor.blueLightChartColor
                : EvoColor.light,
          ),
        ),
        EvoBox.w10,
        _profile(context),
        EvoBox.w10
      ],
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isOpen,
      builder: (context, isOpen, _) {
        return MaterialButton(
          height: double.infinity,
          minWidth: 60,
          onPressed: () => _handleMenuButtonPress(context),
          child: SvgPicture.asset(
            IconlyBroken.drawer,
            width: 20,
            height: 20,
          ),
        );
      },
    );
  }

  void _handleMenuButtonPress(BuildContext context) {
    final bool isLargeOrMediumWeb =
        EvoResponsive.isLargeWeb(context) || EvoResponsive.isMediumWeb(context);

    if (!isLargeOrMediumWeb) {
      if (_scaffoldKey.currentState!.isDrawerOpen) {
        _scaffoldKey.currentState!.closeDrawer();
      } else {
        _scaffoldKey.currentState!.openDrawer();
      }
    } else {
      _isOpen.value = !_isOpen.value;
    }
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      color: !context.isDarkMode
          ? EvoColor.lightBackgroundBlue
          : EvoColor.cardDark,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EvoBox.h10,
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: body,
            ),
          ),
          EvoBox.h2,
          const Center(
            child: EvoCustomText(
              title: EvoStrings.footerText,
              textColor: EvoColor.lightGray,
            ),
          ),
          SafeArea(child: EvoBox.h2),
        ],
      ),
    );
  }

  final List<String> _items = [
    EvoStrings.profile,
    EvoStrings.settings,
    EvoStrings.lockScreen,
  ];

  Widget _profile(BuildContext context) {
    final authServices = Provider.of<AuthServices>(context, listen: false);
    return EvoDropdownButton(
      focusColor: Colors.transparent,
      underline: EvoBox.shrink,
      customButton: const MaterialButton(
        height: double.infinity,
        minWidth: 60,
        hoverColor: Colors.transparent,
        onPressed: null,
        child: CircleAvatar(
          maxRadius: 16,
          backgroundImage: AssetImage(EvoImages.profileImage),
        ),
      ),
      customItemsIndexes: const [3],
      customItemsHeight: 8,
      onChanged: (value) async {
        if (value == 'Logout') {
          await authServices.signOut();
          if (context.mounted) context.go('/login');
        }
      },
      items: [
        ..._items.map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DropdownMenuItem<Divider>(
          enabled: false,
          child: Divider(
              color: context.isDarkMode
                  ? EvoColor.darkTextHeader
                  : EvoColor.lightTextHeader),
        ),
        const DropdownMenuItem(
          value: 'Logout',
          child: Text(
            EvoStrings.logout,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
      itemHeight: 48,
      itemPadding: const EdgeInsets.only(left: 16, right: 16),
      dropdownWidth: 160,
      dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
      ),
      dropdownElevation: 0,
      offset: const Offset(-120, 20),
    );
  }
}
