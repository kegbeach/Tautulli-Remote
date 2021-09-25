import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../data/models/new_activity_model.dart';

class NewBackgroundImageChooser extends StatelessWidget {
  final NewActivityModel activity;
  final bool addBlur;

  const NewBackgroundImageChooser({
    Key? key,
    required this.activity,
    this.addBlur = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: addBlur ? 25 : 0,
        sigmaY: addBlur ? 25 : 0,
      ),
      child: activity.live
          ? const _BackgroundImageLiveTv()
          : _BackgroundImageGeneral(
              url: activity.posterUrl,
            ),
    );
  }
}

class _BackgroundImageGeneral extends StatelessWidget {
  final String? url;

  const _BackgroundImageGeneral({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if (url != null)
          Positioned.fill(
            child: Image(
              image: CachedNetworkImageProvider(url!),
              fit: BoxFit.cover,
            ),
          ),
        Container(
          color: Colors.black.withOpacity(0.4),
        ),
      ],
    );
  }
}

class _BackgroundImageLiveTv extends StatelessWidget {
  const _BackgroundImageLiveTv({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Uses asset image since fallback image from API is pre-blurred
    // Does not add opacity layer as it makes the image too dark
    return Image.asset(
      'assets/images/livetv_fallback.png',
      fit: BoxFit.cover,
    );
  }
}
