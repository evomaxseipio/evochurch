
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

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
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp.router(
      
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'app',
      routerConfig: widget.appRouter,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'), // English, Spanish
        Locale('en'), // English, Spanish
      ],
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appTitle,
      title: 'Evo Church Admin',
      
      scrollBehavior: SBehavior(),
      theme: EvoTheme.lightTheme, // Light theme
      darkTheme: EvoTheme.darkTheme, // Dark theme
      themeMode: themeProvider.themeMode, // Dynamic theme mode
     
    );
  }
}
