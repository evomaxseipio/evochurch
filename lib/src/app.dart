import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

import 'constants/constant_index.dart';
import 'view_model/theme_view_model.dart';

/// The Widget that configures your application.

class MyApp extends StatefulWidget {
  final GoRouter appRouter;

  const MyApp({super.key, required this.appRouter});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
    _initDeepLinkHandler();
  }

  @override
  void dispose() {
    if (!_isWeb) {
      _sub.cancel(); // Cancel the deep link stream for mobile
    }
    super.dispose();
  }

  void _initDeepLinkHandler() {
    if (kIsWeb) {
      // Web: Use the current URL
      _handleWebLink(Uri.base);
    } else {
      // Mobile: Use uni_links
      _sub = uriLinkStream.listen((Uri? uri) {
        if (uri != null) {
          _handleMobileLink(uri);
        }
      }, onError: (err) {
        print('Error handling deep link: $err');
      });
    }
  }

  void _handleWebLink(Uri uri) {
    final String? accessToken = uri.queryParameters['access_token'];
    if (accessToken != null) {
      print("Web - Access Token Found: $accessToken");
      // Navigator.pushNamed(context, '/set-password', arguments: accessToken);
    }
  }

  void _handleMobileLink(Uri uri) {
    final String? accessToken = uri.queryParameters['access_token'];
    if (accessToken != null) {
      print("Mobile - Access Token Found: $accessToken");
      // Navigator.pushNamed(context, '/set-password', arguments: accessToken);
    }
  }

  bool get _isWeb => kIsWeb;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    context.setLocale(const Locale('en'));

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'app',
      routerConfig: widget.appRouter,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      // onGenerateTitle: (BuildContext context) =>
      //     AppLocalizations.of(context)!.appTitle,
      title: 'Evo Church Admin',

      scrollBehavior: SBehavior(),
      theme: FlexThemeData.light(scheme: FlexScheme.sanJuanBlue), // Light theme
      darkTheme:
          FlexThemeData.dark(scheme: FlexScheme.bahamaBlue), // Dark theme
      // The Mandy red, light theme.
      // theme: FlexThemeData.light(scheme: FlexScheme.blueM3),
      // // The Mandy red, dark theme.
      // darkTheme: FlexThemeData.dark(scheme: FlexScheme.blumineBlue),
      // Use dark or light theme based on system setting.`
      themeMode: themeProvider.themeMode, // DynamicmandyRed),heme mode
    );
  }
}
