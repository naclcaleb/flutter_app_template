import 'dart:developer';

import 'package:flutter/material.dart';
import '../product_form_field.dart';

import '../../basic/autocomplete_text_field.dart';

class AutocompleteTextFormField<OptionType extends Object> extends ProductFormField<String> {

  final String? placeholder;
  final List<OptionType> options;
  final String Function(OptionType option)? stringForOption;
  final TextEditingController? controller;
  final void Function(OptionType value)? onOptionSelected;

  const AutocompleteTextFormField({super.key, this.placeholder, required this.options, required this.stringForOption, this.onOptionSelected, this.controller, super.validator, super.initialValue, super.enabled, super.label});

  @override
  State<ProductFormField<String>> createState() => _AutocompleteTextFormFieldState<OptionType>();
}

class _AutocompleteTextFormFieldState<OptionType extends Object> extends ProductFormFieldState<String, AutocompleteTextFormField<OptionType>> {

  TextEditingController? _controller;
  FocusNode _focusNode = FocusNode();

  _AutocompleteTextFormFieldState();

  @override
  void provideInititalState() {
    _controller?.text = widget.initialValue ?? '';
  }

  @override 
  void onFormFieldStateRegistered() {
    _controller?.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        fieldState?.didChange(_controller?.text);
      });
    });
  }

  @override
  void initState() {
    _controller = widget.controller ?? TextEditingController();

    super.initState();
  }
  
  @override
  Widget buildChildWidget(BuildContext context) {
    return AutocompleteTextField<OptionType>(
      placeholder: widget.placeholder ?? '',
      controller: _controller,
      options: widget.options,
      stringForOption: widget.stringForOption,
      onOptionSelected: widget.onOptionSelected,
      focusNode: _focusNode,
    );
  }

}