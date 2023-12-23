import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'pages/base_tab_view.dart';
import 'pages/home/home_page.dart';
import 'pages/profile/profile_page_tab_wrapper.dart';
import 'splash_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _tab1NavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _tab2NavigatorKey = GlobalKey<NavigatorState>();

final mainRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    
    StatefulShellRoute.indexedStack(
      branches: [

        //Routes for tabs go in here
        StatefulShellBranch(navigatorKey: _tab1NavigatorKey, routes: [
          GoRoute(path: '/tab1', builder: (context, state) => const HomePage()),
        ]),

        StatefulShellBranch(navigatorKey: _tab2NavigatorKey, routes: [
          GoRoute(path: '/tab2', builder: (context, state) => ProfilePageTabWrapper()),
        ])

      ],
      builder: (context, state, navigationShell) => BaseTabView(navigationShell: navigationShell)
    ),
    
    //Other non-specific page routes go here
  ]
);