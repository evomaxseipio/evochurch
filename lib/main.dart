import 'package:evochurch/src/app.dart';
import 'package:evochurch/src/view_model/index_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_strategy/url_strategy.dart';

import 'src/localization/multi_language.dart';
import 'src/routes/app_route_config.dart';

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await languageModel.load();

  Bloc.observer = MyBlocObserver();
  await initialize();

  // Lock orientation to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Supabase initialization Local
  await Supabase.initialize(
    url: 'https://hxssxfgdhsfvkhigzlco.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh4c3N4ZmdkaHNmdmtoaWd6bGNvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjU5NDIyMTQsImV4cCI6MjA0MTUxODIxNH0.twlByPRucPMmUcB59PF7uyju1rELkymi6KNjzf_4q88',
    realtimeClientOptions: const RealtimeClientOptions(
      eventsPerSecond: 2,
    ),
  );

  // Supabase initialization
  // await Supabase.initialize(
  //   url: 'https://xebpgqdnltmnwhzpyjtl.supabase.co',
  //   anonKey:
  //       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhlYnBncWRubHRtbndoenB5anRsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjQ0NDM3MDMsImV4cCI6MjA0MDAxOTcwM30.woM4a9QklmZQ6pTKFs1IegD6hs-DV_O7b8ANFRNlpsk',
  //   realtimeClientOptions: const RealtimeClientOptions(
  //     eventsPerSecond: 2,
  //   ),
  // );

  final authServices = AuthServices();
  final appRouter = MyAppRouter(authServices);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthServices()), // AuthServices for handling authentication
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => MembersViewModel()),
        ChangeNotifierProvider(create: (_) => FinanceViewModel()), // ThemeProvider for handling theme mode
        ChangeNotifierProvider(create: (_) => CollectionViewModel()),
        ChangeNotifierProvider(create: (_) => ExpensesTypeViewModel()),
        ChangeNotifierProvider(create: (_) => ConfigurationsViewModel()), 
         ChangeNotifierProvider(create: (_) => AppUserRoleViewModel()), // LanguageModel for handling language selection
      ],
      child: MyApp(appRouter: appRouter.router),
    ),
  );
}

class MyBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    debugPrint('$bloc');
    debugPrint('$event');
  }
}
