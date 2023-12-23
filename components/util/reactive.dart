import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Reactive<ValueType extends ChangeNotifier> extends StatelessWidget {

  final ValueType item;
  final Widget Function(BuildContext context, ValueType item) builder;

  const Reactive(this.item, {super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: item,
      builder: (context, item) => Consumer<ValueType>(builder: (context, item, child) => builder(context, item))
    );
  }
}