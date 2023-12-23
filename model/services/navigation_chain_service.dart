import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../pages/base_page.dart';

class NavigationChainService {
  
  final Queue<String> _currentNavigationChain = Queue();

  void triggerNavigationChain(BuildContext context, List<String> routes) {
    _currentNavigationChain.clear();
    _currentNavigationChain.addAll(routes);

    _triggerNextNavigation(context);
  }

  void _triggerNextNavigation(BuildContext context) {
    if (_currentNavigationChain.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.push(_currentNavigationChain.removeFirst());
      });
    }
  }

  void registerPage(BuildContext context) {
    //If we're a root page (i.e. there are no SophiaPages above us), navigate to the next route
    if (BasePageParentIndicator.maybeOf(context) == null && context.mounted) {
      _triggerNextNavigation(context);
    }
  }

}
