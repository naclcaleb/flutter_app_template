import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

enum ImageDisplayFormat {
  circle, 
  rounded,
  square
}

class ProductImage extends StatelessWidget {

  final String? url;
  final IconData placeholderIcon;
  final double? width;
  final double? height;
  final ImageDisplayFormat style;
  final Widget? placeholderChild;
  
  const ProductImage({super.key, this.url, this.placeholderIcon = FeatherIcons.image, this.placeholderChild, this.width, this.height, this.style = ImageDisplayFormat.square});

  @override
  Widget build(BuildContext context) {

    if (url == null) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: style == ImageDisplayFormat.circle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: style == ImageDisplayFormat.rounded ? BorderRadius.circular(35) : null,
        ),
        child: placeholderChild == null ? 
            Center(child: Icon(placeholderIcon, size: min(30, (width ?? 10)/2,), color: Theme.of(context).colorScheme.onSurface,),)
            : Center(child: placeholderChild,)
      );
    }

    return CachedNetworkImage(
      imageUrl: url!, 
      width: width, 
      height: height,
      alignment: Alignment.center,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          shape: style == ImageDisplayFormat.circle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: style == ImageDisplayFormat.rounded ? BorderRadius.circular(35) : null,
        ),
      ),
      placeholder: (context, url) => Container(
        width: width,
        height: width,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: style == ImageDisplayFormat.circle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: style == ImageDisplayFormat.rounded ? BorderRadius.circular(35) : null,
        )
      ),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: width,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error.withOpacity(0.3),
          shape: style == ImageDisplayFormat.circle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: style == ImageDisplayFormat.rounded ? BorderRadius.circular(35) : null,
        ),
        child: Center(child: Icon(FeatherIcons.alertTriangle, color: Theme.of(context).colorScheme.error.withOpacity(0.5), size: min(30, (width ?? 10)/2,)))
      )
    );
  }
}