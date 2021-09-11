import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NewPosterChooser extends StatelessWidget {
  final dynamic itemModel;

  const NewPosterChooser({
    Key? key,
    required this.itemModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ['artist', 'album', 'track', 'playlist']
            .contains(itemModel.mediaType)
        ? _PosterSquare(
            url: itemModel.posterUrl ?? '',
          )
        : _PosterStandard(
            url: itemModel.posterUrl ?? '',
          );
  }
}

class _PosterStandard extends StatelessWidget {
  final String url;

  const _PosterStandard({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image(
          image: CachedNetworkImageProvider(url),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PosterSquare extends StatelessWidget {
  final String url;

  const _PosterSquare({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: 8,
                  sigmaY: 8,
                ),
                child: Image(
                  image: CachedNetworkImageProvider(url),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Image(
                image: CachedNetworkImageProvider(url),
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
