import 'package:flutter/material.dart';
import '../../basic/product_long_text_field.dart';
import '../../basic/product_text_field.dart';
import '../product_form_field.dart';

class ProductTextFormField extends ProductFormField<String> {

  final String? placeholder;
  final bool isLongText;
  final ProductTextFieldType type;
  final TextEditingController? controller;

  const ProductTextFormField({super.key, this.placeholder, this.isLongText = false, this.type = ProductTextFieldType.text, this.controller, super.validator, super.initialValue, super.enabled, super.label});

  @override
  State<ProductFormField<String>> createState() => _ProductTextFormFieldState();
}

class _ProductTextFormFieldState extends ProductFormFieldState<String, ProductTextFormField> {

  TextEditingController? _controller;

  _ProductTextFormFieldState();

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
    if (widget.isLongText) {
      return ProductLongTextField(
        placeholder: widget.placeholder ?? '',
        controller: _controller,
      );
    }
    return ProductTextField(
      placeholder: widget.placeholder ?? '',
      controller: _controller,
      type: widget.type,
    );
  }

}