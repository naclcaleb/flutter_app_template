import 'package:flutter/material.dart';

class ProductLongTextField extends StatelessWidget {

  final TextEditingController? controller;
  final void Function(String value)? onSubmitted;
  final String placeholder;

  const ProductLongTextField({super.key, this.placeholder = 'Type here...', this.controller, this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: false,
      textCapitalization: TextCapitalization.sentences,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        fillColor: Theme.of(context).colorScheme.surface,
        filled: true,
        hintText: placeholder,
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface),
        contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
      ),
      minLines: 4,
      maxLines: null,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onBackground),
    );
  }
}