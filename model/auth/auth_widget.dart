import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../auth/auth_controller.dart';
import '../services/preferences_service.dart';
import '../../root_app_config.dart';
import '../../service_locator.dart';

class GlobalAuthWidget extends StatefulWidget {

  final GlobalKey<NavigatorState> navigatorKey;

  const GlobalAuthWidget({super.key, required this.navigatorKey, required this.child});

  final Widget child;

  @override
  State<GlobalAuthWidget> createState() => _GlobalAuthWidgetState();
}

class _GlobalAuthWidgetState extends State<GlobalAuthWidget> {

  final AuthController _authController = sl();
  final PreferencesService _preferencesService = sl();

  @override
  void initState() {
    super.initState();

    //The whole job of this widget is to handle navigation based on auth state
    _authController.listenForAuthStateChanges((userLoggedIn) {

      final navContext = widget.navigatorKey.currentContext;

      if (userLoggedIn) {

        //What to do if the user is logged in
        navContext?.go('/tab1');

      } else {
        //Go to the login page
        navContext?.go('/tab1');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}