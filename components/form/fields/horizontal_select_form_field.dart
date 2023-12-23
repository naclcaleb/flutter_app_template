import 'package:flutter/material.dart';
import '../../basic/horizontal_select.dart';
import '../product_form_field.dart';

class HorizontalSelectFormField extends ProductFormField<String> {

  final void Function(String currentValue)? onUpdate;
  final List<HorizontalSelectOption> options;

  const HorizontalSelectFormField({super.key, super.initialValue, super.validator, super.label, super.enabled, required this.options, this.onUpdate});

  @override
  State<HorizontalSelectFormField> createState() => _HorizontalSelectFormFieldState();
}

class _HorizontalSelectFormFieldState extends ProductFormFieldState<String, HorizontalSelectFormField> {
  
  String? _value;

  void onItemSelected(String value) {
    fieldState?.didChange(value);
    setState(() {
      _value = value;
    });
    widget.onUpdate?.call(value);
  }

  @override
  void provideInititalState() {
    _value = widget.initialValue ?? '';
    fieldState?.setValue(_value);
  }

  @override
  Widget buildChildWidget(BuildContext context) {
    return HorizontalSelect(options: widget.options, value: _value ?? '', onValueChanged: onItemSelected,);
  }

}