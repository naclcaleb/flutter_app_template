import 'package:flutter/material.dart';
import '../../basic/radio_list.dart';

import '../product_form_field.dart';

class RadioListFormField extends ProductFormField<String> {

  final void Function(String value)? onUpdated;
  final Widget child;

  const RadioListFormField({super.key, super.initialValue, super.validator, super.label, super.enabled, super.onSubmit, required this.child, this.onUpdated});

  @override
  State<RadioListFormField> createState() => _RadioListFormFieldState();
}

class _RadioListFormFieldState extends ProductFormFieldState<String, RadioListFormField> {
  
  String? _value;

  void onUpdated(Object? value) {
    String? newValue = value as String?;
    fieldState?.didChange(newValue);
    setState(() {
      _value = newValue;
    });
    widget.onUpdated?.call(newValue!);
  }

  @override
  void provideInititalState() {
    _value = widget.initialValue ?? '';
    fieldState?.setValue(_value);
  }

  @override
  Widget buildChildWidget(BuildContext context) {
    return RadioList(groupValue: _value ?? '', onItemSelected: onUpdated, child: widget.child,);
  }

}