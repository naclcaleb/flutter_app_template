import 'package:flutter/material.dart';

enum ProductIconButtonStyle {
  light,
  dark,
  onlyLight,
  primary
}

class ProductIconButton extends StatelessWidget {

  final IconData icon;
  final ProductIconButtonStyle style;
  final double size;
  final bool disabled;
  final void Function()? onPressed;

  const ProductIconButton({super.key, required this.icon, this.size = 30, this.onPressed, this.style = ProductIconButtonStyle.light, this.disabled = false});

  Color _getNormalColor(BuildContext context) {
    if (style == ProductIconButtonStyle.dark) {
      return Theme.of(context).colorScheme.onBackground;
    } else if (style == ProductIconButtonStyle.light) {
      return Theme.of(context).colorScheme.background;
    } else if (style == ProductIconButtonStyle.onlyLight) {
      return Colors.white;
    } else if (style == ProductIconButtonStyle.primary) {
      return Theme.of(context).colorScheme.primary;
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: disabled ? null : onPressed, icon: Icon(icon, size: size), disabledColor: _getNormalColor(context).withOpacity(0.3), color: _getNormalColor(context),);
  }
}
