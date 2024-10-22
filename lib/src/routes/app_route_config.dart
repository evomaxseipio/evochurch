import 'package:evochurch/src/model/member_model.dart';
import 'package:evochurch/src/routes/app_route_constants.dart';
import 'package:evochurch/src/utils/utils_index.dart';
import 'package:evochurch/src/view/auth/login_view.dart';
import 'package:evochurch/src/view/auth/sign_up_view.dart';
import 'package:evochurch/src/view/error_view.dart';
import 'package:evochurch/src/view/home/dashboard_view.dart';
import 'package:evochurch/src/view/layout/admin_scaffold.dart';
import 'package:evochurch/src/view/members/member_list.dart';
import 'package:evochurch/src/view/members/profile_view.dart';
import 'package:evochurch/src/view_model/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// import 'package:evo_sign_offert/src/view/settings/product_list.dart';

class MyAppRouter {
  final AuthServices authServices;

  MyAppRouter(this.authServices);

  late final router = GoRouter(
    refreshListenable: authServices,
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AdminScaffold(
            title: state.uri.path == '/'
                ? 'Dashboard'
                : state.uri.path.substring(1).capitalize,
            body: child,
          );
        },
        routes: [
          GoRoute(
            name: MyAppRouteConstants.homeRouteName,
            path: '/',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardView(),
            ),
          ),
          GoRoute(
            name: MyAppRouteConstants.membersListRouteName,
            path: '/members',
            pageBuilder: (context, state) => NoTransitionPage(
              child: MemberList(),
            ),
          ),
          GoRoute(
              name: MyAppRouteConstants.memberProfileRouteName,
              path: '/members/profile',
              redirect: (context, state) {
                final member = state.extra as Member?;
                if (member == null) {
                  // Redirect to the members list route if no member is passed
                  return '/members';
                }
                return null; // No redirect needed if member exists
              },
              pageBuilder: (context, state) {
                final member = state.extra as Member?;
                return NoTransitionPage(
                  child: ProfileView(
                    member: member,
                  ),
                );
              }),

          // Other routes (profile, about, contact) can be added here
        ],
      ),
      GoRoute(
        name: MyAppRouteConstants.loginRouteName,
        path: '/login',
        pageBuilder: (context, state) => const MaterialPage(
          child: LoginView(),
        ),
      ),
      GoRoute(
        name: MyAppRouteConstants.signUpRouteName,
        path: '/signup',
        pageBuilder: (context, state) => const MaterialPage(
          child: SignUpView(), // Make sure you have created this SignUpView
        ),
      ),
    ],
    errorPageBuilder: (context, state) =>
        const MaterialPage(child: ErrorView()),
    redirect: (BuildContext context, GoRouterState state) {
      final bool isLoggedIn = authServices.isAuthenticated();
      final bool isLoggingIn = state.uri.path == '/login';
      final bool isSignUp = state.uri.path == '/signup';

      if (!isLoggedIn && !isLoggingIn && !isSignUp) {
        return '/login';
      }

      if (!isLoggedIn && !isLoggingIn && isSignUp) {
        return '/signup';
      }

      if (isLoggedIn && isLoggingIn) {
        return '/';
      }

      return null;
    },
  );
}
