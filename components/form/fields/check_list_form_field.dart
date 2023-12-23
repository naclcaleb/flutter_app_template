import 'package:flutter/material.dart';
import '../../basic/checkbox_list.dart';

import '../product_form_field.dart';

class CheckListFormField extends ProductFormField<Set<String>> {

  final Widget child;
  final void Function(Set<String> newValues)? onUpdateItems;

  const CheckListFormField({super.key, super.onSubmit, super.initialValue, super.validator, super.label, super.enabled, this.onUpdateItems, required this.child});

  @override
  State<CheckListFormField> createState() => _ProductCheckListFormFieldState();
}

class _ProductCheckListFormFieldState extends ProductFormFieldState<Set<String>, CheckListFormField> {
  
  Set<String> _values = {};

  void onUpdated(Set<String> values) {
    _values = values;
    fieldState?.didChange(values);
    widget.onUpdateItems?.call(_values);
    setState(() {
      _values = values;
    });
  }

  @override
  void onFormFieldStateRegistered() {
    
  }

  @override
  void provideInititalState() {
    _values = widget.initialValue ?? {};
    fieldState?.setValue(_values);
  }

  @override
  Widget buildChildWidget(BuildContext context) {
    return CheckboxList(values: _values, onListUpdated: onUpdated, child: widget.child);
  }

}