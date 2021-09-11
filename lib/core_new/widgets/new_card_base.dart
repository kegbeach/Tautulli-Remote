import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NewCardBase extends StatelessWidget {
  final Widget child;
  final String? backgroundImageUrl;
  final Widget? backgroundWidget;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final double? height;

  const NewCardBase({
    Key? key,
    required this.child,
    this.backgroundImageUrl,
    this.backgroundWidget,
    this.backgroundColor,
    this.padding,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          height: height,
          color: backgroundColor,
          child: Stack(
            children: [
              if (backgroundImageUrl != null)
                Positioned.fill(
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: 25,
                      sigmaY: 25,
                    ),
                    child: Image(
                      image: CachedNetworkImageProvider(
                        backgroundImageUrl!,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              if (backgroundImageUrl != null)
                Container(
                  color: Colors.black.withOpacity(0.4),
                ),
              if (backgroundWidget != null) backgroundWidget!,
              Padding(
                padding: padding ?? const EdgeInsets.all(4),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
