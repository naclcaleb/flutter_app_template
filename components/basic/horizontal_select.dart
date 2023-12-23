
import 'dart:developer';

import 'package:flutter/material.dart';

class HorizontalSelectOption {
  String label;
  String value;
  String? description;

  HorizontalSelectOption({ required this.label, required this.value, this.description});
}

class HorizontalSelect extends StatelessWidget {

  final List<HorizontalSelectOption> options;
  final String value;
  final void Function(String value)? onValueChanged;

  const HorizontalSelect({super.key, required this.options, required this.value, this.onValueChanged});

  Color _getBackgroundColorForOption(BuildContext context, HorizontalSelectOption option) {
      if (option.value == value) return Theme.of(context).colorScheme.background;
      return Theme.of(context).colorScheme.surface;
  }

  HorizontalSelectOption _getCurrentOption() {
    final currentOption = options.firstWhere((element) => element.value == value);
    return currentOption;
  }

  TextStyle? _getTextStyleForOption(BuildContext context, HorizontalSelectOption option) {
      final baseStyle = Theme.of(context).textTheme.bodyLarge;

      if (option.value == value) {
        return baseStyle?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w500
        );
      }
      return baseStyle?.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      );
  }

  @override
  Widget build(BuildContext context) {

    const animationDuration = Duration(milliseconds: 150);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.surface),
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.surface
          ),
          height: 50,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                var itemWidth = constraints.maxWidth / options.length;

                return Stack(
                  children: [
                    AnimatedPositioned(
                      duration: animationDuration,
                      curve: Curves.easeInOutCubic,
                      left: options.indexWhere((option) => option.value == value) * itemWidth,
                      child: Container(
                        height: constraints.maxHeight,
                        width: itemWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.background
                        ),
                      ),
                    ),
                    Row(
                      children: options.map((option) => Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (onValueChanged != null) onValueChanged!(option.value);
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Center(
                              child: AnimatedDefaultTextStyle(
                                style: _getTextStyleForOption(context, option) ?? const TextStyle(),
                                duration: animationDuration,
                                child: Text(option.label)
                              ),
                            ),
                          )
                        )
                      ).toList()
                    ),
                  ],
                );
              }
            ),
          )
        ),
        if (_getCurrentOption().description != null) Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0),
          child: Text(_getCurrentOption().description!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface), textAlign: TextAlign.left,),
        )
      ],
    );
  }
}