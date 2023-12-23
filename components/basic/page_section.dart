import 'package:flutter/material.dart';

enum PageSectionStyle {
  plain,
  surface,
  primary
}

class PageSection extends StatelessWidget {

  final String? title;
  final PageSectionStyle style;
  final bool padSides;
  final Widget child;

  const PageSection({super.key, this.title, this.style = PageSectionStyle.plain, this.padSides = true, required this.child});

  List<Widget> _getHeader(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if (title != null) {
      return [
        Padding(
          padding: EdgeInsets.only(left: padSides ? 0:20, right: padSides ? 0:20),
          child: Text(title!, style: theme.textTheme.headlineMedium?.copyWith(color: _getForegroundColor(context)),),
        ),
        const SizedBox(height: 10,),
      ];
    } 
    return [];
  }

  Color _getForegroundColor(BuildContext context) {
    ThemeData theme = Theme.of(context);
    switch (style) {
      case PageSectionStyle.plain:
        return theme.colorScheme.onBackground;
      case PageSectionStyle.surface:
        return theme.colorScheme.onBackground;
      case PageSectionStyle.primary:
        return theme.colorScheme.onPrimary;
    }
  }

  Color _getBackgroundColor(BuildContext context) {
    ThemeData theme = Theme.of(context);
    switch (style) {
      case PageSectionStyle.plain:
        return theme.colorScheme.background;
      case PageSectionStyle.surface:
        return theme.colorScheme.surface;
      case PageSectionStyle.primary:
        return theme.colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _getBackgroundColor(context),
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(left: padSides ? 20: 0, right: padSides ? 20:0, top: 15, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._getHeader(context),
            child
          ],
        ),
      ),
    );
  }
}