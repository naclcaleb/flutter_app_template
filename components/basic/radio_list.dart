import 'package:flutter/material.dart';

class RadioList extends InheritedWidget {

  final String groupValue;
  final void Function(Object? value)? onItemSelected;
  
  void notifyItemSelected(Object? value) {
    onItemSelected?.call(value);
  }

  static maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RadioList>();
  }

  static of(BuildContext context) {
    final RadioList? result = context.dependOnInheritedWidgetOfExactType<RadioList>();
    assert(result != null, 'No RadioList found in context');
    return result!;
  }

  const RadioList({
    super.key,
    required super.child, 
    required this.groupValue,
    this.onItemSelected
  });

  @override
  bool updateShouldNotify(RadioList oldWidget) {
    return oldWidget.groupValue != groupValue;
  }
}