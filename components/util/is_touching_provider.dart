import 'package:flutter/widgets.dart';
import '../../model/utils/is_touching_monitor.dart';

class IsTouchingProvider extends StatelessWidget {

  final IsTouchingMonitor monitor;
  final Widget child;

  const IsTouchingProvider({super.key, required this.monitor, required this.child});

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) => monitor.setIsTouching(true),
      onPointerUp: (event) => monitor.setIsTouching(false),
      child: child,
    );
  }
}