import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TabDefinition {
  final String label;
  final String value;
  final IconData icon;

  const TabDefinition({required this.label, required this.value, required this.icon});
}

class TabItem extends StatelessWidget {

  final TabDefinition tab;
  final bool isActive;
  final void Function()? onTap;

  const TabItem({super.key, required this.tab, required this.isActive, this.onTap});

  TextStyle? _getTextStyle(BuildContext context) {
    if (isActive) {
      return Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.primary);
    } else {
      return Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        splashColor: _getTextStyle(context)?.color?.withOpacity(0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(tab.icon, color: _getTextStyle(context)?.color),
            const SizedBox(height: 5,),
            Text(tab.label, style: _getTextStyle(context)),
          ],
        ),
      ),
    );
  }
}

class TabBarFab extends StatelessWidget {

  final void Function()? onTap;

  const TabBarFab({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: Material(
        shape: const CircleBorder(),
        color: Theme.of(context).colorScheme.primary,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          splashColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Icon(
                FeatherIcons.plus, 
                color: Theme.of(context).colorScheme.onPrimary,
                size: 30,
              )
            ),
          ),
        ),
      ),
    );
  }
}

class ProductTabBar extends StatefulWidget {

  final int currentIndex;
  final StatefulNavigationShell navigationShell;
  final bool hasFab;

  const ProductTabBar({super.key, this.currentIndex = 0, required this.navigationShell, this.hasFab = false});

  @override
  State<ProductTabBar> createState() => _ProductTabBarState();
}

class _ProductTabBarState extends State<ProductTabBar> {

  final Map<String, int> tabToIndexMap = {
    'tab1': 0,
    'tab2': 1
  };

  List<TabDefinition> leftItems = [
    const TabDefinition(label: 'Tab 1', value: 'tab1', icon: FeatherIcons.home),
  ];

  List<TabDefinition> rightItems = [
    const TabDefinition(label: 'Tab 2', value: 'tab2', icon: FeatherIcons.book),
  ];

  void onFabPressed() {
    context.push('/record');
  }

  void onTabPressed(String value) {

    final index = tabToIndexMap[value] ?? 0;

    widget.navigationShell.goBranch(index);

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).colorScheme.surface, width: 2))
      ),
      height: 110,
      child: BottomAppBar(
        color: Theme.of(context).colorScheme.background,
        surfaceTintColor: Theme.of(context).colorScheme.background,
        padding: const EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...leftItems.map((tab) => Expanded(child: TabItem(tab: tab, isActive: tabToIndexMap[tab.value] == widget.currentIndex, onTap: () => onTabPressed(tab.value),))).toList(),
              if (widget.hasFab) Expanded(child: TabBarFab(onTap: onFabPressed,)),
              ...rightItems.map((tab) => Expanded(child: TabItem(tab: tab, isActive: tabToIndexMap[tab.value] == widget.currentIndex, onTap: () => onTabPressed(tab.value)))).toList()
            ],
          ),
        ),
      ),
    );
  }
}