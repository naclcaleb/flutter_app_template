import 'package:flutter/material.dart';
import 'product_text_field.dart';

class AutocompleteTextField<OptionType extends Object> extends StatelessWidget {

  final TextEditingController? controller;
  final String? placeholder;
  final List<OptionType> options;
  final String Function(OptionType option)? stringForOption;
  final void Function(OptionType value)? onOptionSelected;
  final FocusNode focusNode;

  const AutocompleteTextField({super.key, this.controller, this.placeholder, this.options = const [], required this.stringForOption, required this.focusNode, this.onOptionSelected});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return RawAutocomplete<OptionType>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return Iterable<OptionType>.empty();
            }
            return options;
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              widthFactor: 1.0,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Material(
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: 200.0,
                      maxWidth: constraints.maxWidth,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).colorScheme.background,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ]
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8.0),
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final OptionType option = options.elementAt(index);
                        return GestureDetector(
                          onTap: () {
                            onSelected(option);
                          },
                          child: ListTile(
                            title: Text(stringForOption!(option), style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onBackground)),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
          onSelected: onOptionSelected,
          textEditingController: controller,
          fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) => ProductTextField(
            controller: textEditingController,
            type: ProductTextFieldType.text,
            placeholder: placeholder ?? '',
            focusNode: focusNode,
          ),
          focusNode: focusNode,
          displayStringForOption: stringForOption ?? (option) => option.toString(),
        );
      }
    );
  }
}