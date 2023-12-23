import 'package:flutter/material.dart';
import 'product_form.dart';

//Helpful util function for text fields
String? defaultValidator(String? value, String errorMessage) {
  if (value == null || value.isEmpty) {
    return errorMessage;
  }
  return null;
}

abstract class ProductFormField<ValueType> extends StatefulWidget {

  final ValueType? initialValue;
  final String? Function(ValueType?)? validator;
  final bool? enabled;
  final String? label;
  final void Function(ValueType?)? onSubmit;

  const ProductFormField({super.key, this.initialValue, this.validator, this.enabled, this.label, this.onSubmit});

}

abstract class ProductFormFieldState<ValueType, T extends ProductFormField<ValueType>> extends State<T> {

  FormFieldState<ValueType>? fieldState;

  void onFormFieldStateRegistered() {

  }

  void provideInititalState() {

  }

  ProductFormStyle _getStyle() {
    return ProductFormWrapper.of(context).style;
  }

  void _registerWithState(FormFieldState<ValueType> fieldState) {
    if (this.fieldState == null) {
      this.fieldState = fieldState;
      provideInititalState();
      onFormFieldStateRegistered();
    }
  }

  Color _getErrorColor(BuildContext context) {
    if (_getStyle() == ProductFormStyle.dark) return Theme.of(context).colorScheme.background;
    return Theme.of(context).colorScheme.error;
  }

  Color _getLabelColor(BuildContext context) {
    if (_getStyle() == ProductFormStyle.dark) return Theme.of(context).colorScheme.background;
    return Theme.of(context).colorScheme.onBackground;
  }

  Widget buildChildWidget(BuildContext context) {
    return const Placeholder();
  }

  @override
  Widget build(BuildContext context) {

    return FormField(
      initialValue: widget.initialValue,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: widget.enabled ?? true,
      onSaved: widget.onSubmit,
      builder: (FormFieldState<ValueType> fieldState) {
        _registerWithState(fieldState); // This is a hack to get the field state to update
        return Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
              if (widget.label != null) Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Text(widget.label!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: _getLabelColor(context))),
              ),
              buildChildWidget(context),
              const SizedBox(height: 5,),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOutCubic,
                height: fieldState.hasError ? 20:0,
                child: Text(
                  fieldState.errorText ?? '',
                  style: Theme.of(fieldState.context).textTheme.bodySmall?.copyWith(color: _getErrorColor(context)),
                  textAlign: TextAlign.start,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

/*
class SophiaFormField<ValueType> extends FormField<ValueType> {

  final Widget Function(FormFieldState<ValueType> fieldState) valueSupplier;

  SophiaFormField({
    required this.valueSupplier,
    super.key,
    super.initialValue,
    super.validator,
    super.autovalidateMode = AutovalidateMode.always,
    super.enabled = true,
  }) : super(
    builder: (FormFieldState<ValueType> fieldState) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          valueSupplier(fieldState),
          const SizedBox(height: 10,),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOutCubic,
            height: fieldState.hasError ? 20:0,
            child: Text(
              fieldState.errorText ?? '',
              style: Theme.of(fieldState.context).textTheme.bodySmall?.copyWith(color: Theme.of(fieldState.context).colorScheme.error),
              textAlign: TextAlign.start,
            ),
          )
        ],
      );
    }
  );

  @override
  FormFieldState<ValueType> createState() => FormFieldState<ValueType>();
}*/