import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../enums/media_type.dart';
import '../helpers/new_color_palette_helper.dart';
import '../helpers/new_icon_helper.dart';

class NewMediaTypeIcon extends StatelessWidget {
  final MediaType mediaType;
  final Color? iconColor;

  const NewMediaTypeIcon({
    Key? key,
    required this.mediaType,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _mapMediaTypeToIconWidget(mediaType, iconColor);
  }
}

FaIcon _mapMediaTypeToIconWidget(
  MediaType mediaType,
  Color? iconColor,
) {
  final icon = NewIconHelper.mapMediaTypeToIcon(mediaType);

  switch (mediaType) {
    case (MediaType.movie):
      return FaIcon(
        icon,
        size: 18,
        color: iconColor ?? TautulliColorPalette.not_white,
      );
    case (MediaType.episode):
    case (MediaType.season):
    case (MediaType.show):
      return FaIcon(
        icon,
        size: 14,
        color: iconColor ?? TautulliColorPalette.not_white,
      );
    case (MediaType.track):
    case (MediaType.album):
      return FaIcon(
        icon,
        size: 16,
        color: iconColor ?? TautulliColorPalette.not_white,
      );
    case (MediaType.photo):
      return FaIcon(
        icon,
        size: 18,
        color: iconColor ?? TautulliColorPalette.not_white,
      );
    case (MediaType.clip):
      return FaIcon(
        icon,
        size: 17,
        color: iconColor ?? TautulliColorPalette.not_white,
      );
    case (MediaType.collection):
      return FaIcon(
        icon,
        size: 17,
        color: iconColor ?? TautulliColorPalette.not_white,
      );
    case (MediaType.playlist):
      return FaIcon(
        icon,
        size: 17,
        color: iconColor ?? TautulliColorPalette.not_white,
      );
    default:
      return FaIcon(
        icon,
        size: 17,
        color: iconColor ?? TautulliColorPalette.not_white,
      );
  }
}
