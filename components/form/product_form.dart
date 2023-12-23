import 'package:flutter/material.dart';
import 'product_form_field.dart';

enum ProductFormStyle {
  light,
  dark
}

class ProductFormWrapper extends InheritedWidget {

  final GlobalKey<FormState>? formKey;

  final ProductFormStyle style;

  const ProductFormWrapper({super.key, this.formKey, this.style = ProductFormStyle.light, required super.child});

  static maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ProductFormWrapper>();
  }

  static of(BuildContext context) {
    final ProductFormWrapper? result = context.dependOnInheritedWidgetOfExactType<ProductFormWrapper>();
    assert(result != null, 'No ProductForm found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant ProductFormWrapper oldWidget) {
    return oldWidget.formKey != formKey || oldWidget.style != style;
  }

}

class ProductForm extends StatelessWidget {

  final ProductFormStyle style;
  final GlobalKey<FormState>? formKey;
  final Widget child;

  const ProductForm({super.key, this.style = ProductFormStyle.light, this.formKey, required this.child});

  @override
  Widget build(BuildContext context) {
    return ProductFormWrapper(
      style: style,
      child: Form(
        key: formKey,
        child: child,
      ),
    );
  }
}