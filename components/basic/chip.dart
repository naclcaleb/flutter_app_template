import 'dart:ui';

import 'package:flutter/material.dart';

enum ChipStyle {
  normal,
  blurred,
  primary
}

class Chip extends StatelessWidget {

  final String text;
  final ChipStyle style;
  final void Function()? onTap;

  const Chip({super.key, required this.text, this.style = ChipStyle.normal, this.onTap});

  Color _backgroundColor(BuildContext context) {
    switch(style) {
      case ChipStyle.normal:
        return Theme.of(context).colorScheme.background;
      case ChipStyle.blurred:
        return Theme.of(context).colorScheme.background.withOpacity(0.3);
      case ChipStyle.primary:
        return Theme.of(context).colorScheme.primary;
    }
  }

  Color _foregroundColor(BuildContext context) {
    switch(style) {
      case ChipStyle.normal:
        return Theme.of(context).colorScheme.onBackground;
      case ChipStyle.blurred:
        return Theme.of(context).colorScheme.onBackground;
      case ChipStyle.primary:
        return Theme.of(context).colorScheme.onPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 37,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          decoration: ShapeDecoration(
            shape: const StadiumBorder(),
            color: _backgroundColor(context)
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
            child: Text(text, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: _foregroundColor(context)),)
          ),
        )
      ),
    );
  }
}