import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../components/basic/tab_bar.dart';

class BaseTabView extends StatelessWidget {

  final StatefulNavigationShell navigationShell;

  const BaseTabView({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: TabBar(currentIndex: navigationShell.currentIndex, navigationShell: navigationShell,),
      body: navigationShell,
    );
  }
}