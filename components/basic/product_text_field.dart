import 'package:flutter/material.dart';

enum ProductTextFieldType {
  email,
  password,
  text,
  number
}

class ProductTextField extends StatelessWidget {

  final String placeholder;
  final IconData? icon;
  final TextEditingController? controller;
  final void Function(String value)? onSubmitted;
  final ProductTextFieldType type;
  final FocusNode? focusNode;
  final EdgeInsets? scrollPadding;
  final bool allowMultiline;

  const ProductTextField({super.key, this.placeholder = 'Type here...', this.icon, this.type = ProductTextFieldType.text, this.controller, this.onSubmitted, this.focusNode, this.scrollPadding, this.allowMultiline = false});
 
  TextInputType _getKeyboardType(BuildContext context) {

    if (allowMultiline) return TextInputType.multiline;

    switch (type) {
      case ProductTextFieldType.email:
        return TextInputType.emailAddress;
      case ProductTextFieldType.password:
        return TextInputType.visiblePassword;
      case ProductTextFieldType.text:
        return TextInputType.text;
      case ProductTextFieldType.number:
        return TextInputType.number;
    }
  }

  TextCapitalization _getTextCapitalization() {
    switch (type) {
      case ProductTextFieldType.email:
        return TextCapitalization.none;
      case ProductTextFieldType.password:
        return TextCapitalization.none;
      case ProductTextFieldType.text:
        return TextCapitalization.sentences;
      case ProductTextFieldType.number:
        return TextCapitalization.none;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      textCapitalization: _getTextCapitalization(),
      controller: controller,
      onSubmitted: onSubmitted,
      autofocus: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        fillColor: Theme.of(context).colorScheme.surface,
        filled: true,
        hintText: placeholder,
        prefixIcon: icon == null ? null : Icon(icon),
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface),
        contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
      ),
      keyboardType: _getKeyboardType(context),
      obscureText: type == ProductTextFieldType.password,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onBackground),
      focusNode: focusNode,
      scrollPadding: scrollPadding ?? const EdgeInsets.all(20),
      maxLines: allowMultiline ? null:1,
    );
  }
}