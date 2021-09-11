import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../enums/media_type.dart';
import '../enums/state.dart' as enums;
import '../enums/stream_decision.dart';
import 'new_color_palette_helper.dart';

class NewIconHelper {
  static IconData mapStateToIcon(enums.State state) {
    switch (state) {
      case (enums.State.paused):
        return FontAwesomeIcons.pauseCircle;
      case (enums.State.buffering):
        return FontAwesomeIcons.spinner;
      case (enums.State.playing):
        return FontAwesomeIcons.playCircle;
      case (enums.State.error):
        return FontAwesomeIcons.exclamationTriangle;
      default:
        return FontAwesomeIcons.questionCircle;
    }
  }

  static IconData mapMediaTypeToIcon(MediaType mediaType) {
    switch (mediaType) {
      case (MediaType.movie):
        return FontAwesomeIcons.film;
      case (MediaType.episode):
      case (MediaType.season):
      case (MediaType.show):
        return FontAwesomeIcons.tv;
      case (MediaType.track):
      case (MediaType.album):
        return FontAwesomeIcons.music;
      case (MediaType.photo):
        return FontAwesomeIcons.image;
      case (MediaType.clip):
        return FontAwesomeIcons.video;
      case (MediaType.collection):
        return FontAwesomeIcons.layerGroup;
      case (MediaType.playlist):
        return FontAwesomeIcons.list;
      default:
        return FontAwesomeIcons.questionCircle;
    }
  }

  static IconData mapTranscodeDecisionToIcon(StreamDecision transcodeDecision) {
    switch (transcodeDecision) {
      case (StreamDecision.transcode):
        return FontAwesomeIcons.server;
      case (StreamDecision.copy):
        return FontAwesomeIcons.stream;
      case (StreamDecision.directPlay):
        return FontAwesomeIcons.playCircle;
      default:
        return FontAwesomeIcons.questionCircle;
    }
  }

  static Widget mapWatchedStatusToIcon(num watchedStatus) {
    const double size = 16;
    const Color color = TautulliColorPalette.not_white;

    if (watchedStatus == 1) {
      return const FaIcon(
        FontAwesomeIcons.solidCircle,
        color: color,
        size: size,
      );
    } else if (watchedStatus == 0.5) {
      return Transform.rotate(
        angle: 180 * pi / 180,
        child: const FaIcon(
          FontAwesomeIcons.adjust,
          color: color,
          size: size,
        ),
      );
    } else {
      return const FaIcon(
        FontAwesomeIcons.circle,
        color: color,
        size: size,
      );
    }
  }
}
