import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

enum ProductButtonStyle {
  light,
  thinLight,
  secondary,
  thinPrimary,
  error,
  lightDanger,
  primary
}

enum ProductButtonIconPosition {
  left, 
  right
}

enum ProductButtonSize {
  small, 
  medium, 
  large
}

class ProductButtonSizeValues {
  TextStyle? textStyle;
  double iconSize;
  double buttonHeight;

  ProductButtonSizeValues({required this.textStyle, required this.iconSize, required this.buttonHeight});
}

class ProductButtonColorValues {
  Color strokeColor;
  Color fillColor;
  Color textColor;
  Color splashColor;

  ProductButtonColorValues({required this.strokeColor, required this.fillColor, required this.textColor, required this.splashColor});
}



class ProductButton extends StatelessWidget {
  final String text;
  final bool loading;
  final ProductButtonStyle style;
  final IconData? icon;
  final ProductButtonIconPosition iconPosition;
  final ProductButtonSize size;
  final bool disabled;
  final void Function()? onTap;

  ProductButtonColorValues _getColorValues(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    Map<ProductButtonStyle, ProductButtonColorValues> colorValuesMap = {
      ProductButtonStyle.light: ProductButtonColorValues(strokeColor: Colors.transparent, fillColor: themeData.colorScheme.background, textColor: themeData.colorScheme.primary, splashColor: Colors.grey.withOpacity(0.1)),
      ProductButtonStyle.thinLight: ProductButtonColorValues(strokeColor: themeData.colorScheme.background, fillColor: Colors.transparent, textColor: themeData.colorScheme.background, splashColor: Colors.grey.withOpacity(0.1)),
      ProductButtonStyle.secondary: ProductButtonColorValues(strokeColor: Colors.transparent, fillColor: themeData.colorScheme.secondary, textColor: themeData.colorScheme.onSecondary, splashColor: Colors.white24),
      ProductButtonStyle.thinPrimary: ProductButtonColorValues(strokeColor: themeData.colorScheme.primary, fillColor: Colors.transparent, textColor: themeData.colorScheme.primary, splashColor: Colors.grey.withOpacity(0.1)),
      ProductButtonStyle.error: ProductButtonColorValues(strokeColor: Colors.transparent, fillColor: themeData.colorScheme.error, textColor: themeData.colorScheme.onError, splashColor: Colors.white24),
      ProductButtonStyle.lightDanger: ProductButtonColorValues(strokeColor: Colors.transparent, fillColor: themeData.colorScheme.error.withOpacity(0.3), textColor: themeData.colorScheme.error, splashColor: Colors.white24),
      ProductButtonStyle.primary: ProductButtonColorValues(strokeColor: Colors.transparent, fillColor: themeData.colorScheme.primary, textColor: themeData.colorScheme.onPrimary, splashColor: Colors.white24)
    };

    return colorValuesMap[style]!;
  }

  ProductButtonSizeValues _getSizeValues(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Map<ProductButtonSize, ProductButtonSizeValues> sizeValuesMap = {
      ProductButtonSize.small: ProductButtonSizeValues(textStyle: theme.textTheme.labelSmall, iconSize: 16, buttonHeight: 40),
      ProductButtonSize.medium: ProductButtonSizeValues(textStyle: theme.textTheme.labelMedium, iconSize: 18, buttonHeight: 52),
      ProductButtonSize.large: ProductButtonSizeValues(textStyle: theme.textTheme.labelLarge, iconSize: 20, buttonHeight: 56)
    };

    return sizeValuesMap[size]!;
  }

  const ProductButton({super.key, required this.text, this.icon, this.loading = false, this.style = ProductButtonStyle.light, this.iconPosition = ProductButtonIconPosition.left, this.size = ProductButtonSize.medium, this.disabled = false, this.onTap });

  List<Widget> _iconWidgets(BuildContext context) {
    if (iconPosition == ProductButtonIconPosition.left) {
      return [
        Icon(icon, size: _getSizeValues(context).iconSize, color: _getColorValues(context).textColor),
        if (text != '') const SizedBox(width: 8),
      ];
    } else if (iconPosition == ProductButtonIconPosition.right) {
      return [
        if (text != '') const SizedBox(width: 8),
        Icon(icon, size: _getSizeValues(context).iconSize, color: _getColorValues(context).textColor),
      ];
    } else {
      return [];
    }
  }

  Widget _buttonContent(BuildContext context) {
    if (loading) {
      return Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: _getColorValues(context).textColor,
          ),
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconPosition == ProductButtonIconPosition.left && icon != null) ..._iconWidgets(context),
          if (text != '') Text(text, style:_getSizeValues(context).textStyle?.copyWith(color: _getColorValues(context).textColor)),
          if (iconPosition == ProductButtonIconPosition.right && icon != null) ..._iconWidgets(context),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _getColorValues(context).fillColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: _getColorValues(context).strokeColor, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Container(
            height: _getSizeValues(context).buttonHeight,
            constraints: BoxConstraints(minWidth: _getSizeValues(context).buttonHeight),
            child: InkWell(
              onTap: (disabled || loading) ? null : onTap,
              splashColor: _getColorValues(context).splashColor,
              child: Padding(padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                child: Center(
                  child: _buttonContent(context),
                )
              ),
            ),
          ),
          if (disabled || loading) Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: _getColorValues(context).splashColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}