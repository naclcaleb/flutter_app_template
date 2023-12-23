import 'package:flutter/material.dart';

class CheckboxList extends InheritedWidget {

  final Set<String> values;
  final void Function(Set<String> values)? onListUpdated;

  void notifyItemToggled(String value) {
    Set<String> newSet = values;
    if (newSet.contains(value)) {
      newSet.remove(value);
    } else {
      newSet.add(value);
    }

    onListUpdated?.call(newSet);
  }

  static maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CheckboxList>();
  }

  static of(BuildContext context) {
    final CheckboxList? result = context.dependOnInheritedWidgetOfExactType<CheckboxList>();
    assert(result != null, 'No CheckboxList found in context');
    return result!;
  }

  const CheckboxList({ super.key, required super.child, this.onListUpdated, this.values = const {} });

  @override
  bool updateShouldNotify(CheckboxList oldWidget) {
    return oldWidget.values.containsAll(values) && values.containsAll(oldWidget.values);
  }

}