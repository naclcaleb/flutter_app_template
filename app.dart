import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'components/util/reactive.dart';
import 'global_error_widget.dart';
import 'model/auth/auth_widget.dart';
import 'notifications_service_widget.dart';
import 'routes.dart';
import 'service_locator.dart';

var appTheme = AppTheme();

class App extends StatelessWidget {

  final GlobalAppThemeConfig globalAppThemeConfig = sl();

  App({super.key});

  @override
  Widget build(BuildContext context) {
    return Reactive(
      globalAppThemeConfig,
      builder: (context, appThemeConfig) => MaterialApp.router(
        routerConfig: mainRouter,
        theme: appTheme.light,
        darkTheme: appTheme.dark,
        themeMode: appThemeConfig.themeMode,
        builder: (context, child) {
          return NotificationsServiceWidget(
            child: GlobalErrorWidget(
              child: GlobalAuthWidget(
                navigatorKey: mainRouter.routerDelegate.navigatorKey,
                child: child ?? const SizedBox(),
              ),
            ),
          );
        },
      ),
    );
  }
}