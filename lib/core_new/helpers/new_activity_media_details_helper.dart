import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiver/strings.dart';

import '../../features_new/new_activity/data/models/new_activity_model.dart';
import '../../translations/locale_keys.g.dart';
import '../enums/enums.dart' as enums;
import 'new_color_palette_helper.dart';
import 'new_string_helper.dart';

/// Various helper functions to return [RichText] data for activity data.
class NewActivityMediaDetailsHelper {
  static List<List> audio(NewActivityModel activity) {
    String title = LocaleKeys.media_details_audio.tr();
    List<List> list = [];

    if (activity.streamAudioDecision != enums.StreamDecision.UNKNOWN) {
      if (activity.streamAudioDecision == enums.StreamDecision.transcode) {
        list.add([
          title,
          RichText(
            text: TextSpan(
              text: LocaleKeys.media_details_transcode.tr(),
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ]);

        String textLeft =
            '${activity.audioCodec?.toUpperCase()} ${NewStringHelper.capitalize(activity.audioChannelLayout?.split("(")[0])}';
        String textRight =
            '${activity.streamAudioCodec?.toUpperCase()} ${NewStringHelper.capitalize(activity.streamAudioChannelLayout?.split("(")[0])}';

        list.add([
          '',
          _formatValue(left: textLeft, right: textRight),
        ]);
      } else if (activity.streamAudioDecision == enums.StreamDecision.copy) {
        String textLeft =
            '${LocaleKeys.media_details_direct_stream.tr()} (${activity.streamAudioCodec?.toUpperCase()} ${NewStringHelper.capitalize(activity.streamAudioChannelLayout?.split("(")[0])})';

        list.add([
          title,
          _formatValue(left: textLeft),
        ]);
      } else {
        String textLeft =
            '${LocaleKeys.media_details_direct_play.tr()} (${activity.streamAudioCodec?.toUpperCase()} ${NewStringHelper.capitalize(activity.streamAudioChannelLayout?.split("(")[0])})';

        list.add([
          title,
          _formatValue(left: textLeft),
        ]);
      }
    }
    return list;
  }

  static List<List> bandwidth(NewActivityModel activity) {
    String finalText;

    if (activity.mediaType != enums.MediaType.photo &&
        !['Unknown', '', ' '].contains(activity.bandwidth)) {
      int _bw = int.parse(activity.bandwidth!);
      if (_bw > 1000000) {
        finalText = '${(_bw / 1000000).toStringAsFixed(1)} Gbps';
      } else if (_bw > 1000) {
        finalText = '${(_bw / 1000).toStringAsFixed(1)} Mbps';
      } else {
        finalText = '$_bw kbps';
      }
    } else if (activity.syncedVersion) {
      finalText = LocaleKeys.media_details_none.tr();
    } else {
      finalText = LocaleKeys.general_unknown.tr();
    }
    final formattedBandwidth = RichText(
      text: TextSpan(
        text: finalText,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );

    return [
      [LocaleKeys.media_details_bandwidth.tr(), formattedBandwidth]
    ];
  }

  static List<List> container(NewActivityModel activity) {
    String title = LocaleKeys.media_details_container.tr();
    List<List> list = [];

    if (activity.streamContainerDecision == enums.StreamDecision.transcode) {
      list.add([
        title,
        RichText(
          text: TextSpan(
            text: LocaleKeys.media_details_converting.tr(),
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ]);

      String leftText = '${activity.container.toUpperCase()}';
      String rightText = '${activity.streamContainer.toUpperCase()}';

      list.add(['', _formatValue(left: leftText, right: rightText)]);
    } else {
      String value =
          '${LocaleKeys.media_details_direct_play.tr()} (${activity.streamContainer.toUpperCase()})';
      list.add([title, _formatValue(left: value)]);
    }

    return list;
  }

  static List<List> location(
    NewActivityModel activity,
    bool maskSensitiveInfo,
  ) {
    String text;
    IconData? icon;

    if (activity.ipAddress != LocaleKeys.media_details_na.tr()) {
      if (activity.secure) {
        icon = FontAwesomeIcons.lock;
      } else {
        icon = FontAwesomeIcons.unlock;
      }
      text =
          '${activity.location.toShortString().toUpperCase()}: ${maskSensitiveInfo ? '*${LocaleKeys.masked_info_ip_address}*' : activity.ipAddress}';
    } else {
      text = LocaleKeys.media_details_na.tr();
    }

    final formattedLocation = RichText(
      text: TextSpan(
        children: [
          if (icon != null)
            WidgetSpan(
              child: Container(
                padding: const EdgeInsets.only(
                  right: 5,
                ),
                child: FaIcon(
                  icon,
                  color: TautulliColorPalette.not_white,
                  size: 16.5,
                ),
              ),
            ),
          TextSpan(
            text: text,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );

    return [
      [LocaleKeys.media_details_location.tr(), formattedLocation]
    ];
  }

  static List<List> locationDetails({
    required String type,
    String? city,
    String? region,
    String? code,
    required bool maskSensitiveInfo,
  }) {
    if (city != null && city != LocaleKeys.general_unknown.tr()) {
      city = '$city, ';
    } else {
      city = '';
    }
    if (region == null) {
      region = '';
    }
    if (code == null) {
      code = '';
    }

    final formattedLocationDetails = RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Container(
              padding: const EdgeInsets.only(
                right: 5,
              ),
              child: FaIcon(
                type == 'relay'
                    ? FontAwesomeIcons.exclamationCircle
                    : FontAwesomeIcons.mapMarkerAlt,
                color: TautulliColorPalette.not_white,
                size: 16.5,
              ),
            ),
          ),
          TextSpan(
            text: type == 'relay'
                ? LocaleKeys.media_details_relay_message.tr()
                : maskSensitiveInfo
                    ? '*${LocaleKeys.masked_info_location.tr()}*'
                    : '$city$region $code',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );

    return [
      ['', formattedLocationDetails]
    ];
  }

  static List<List> optimized(NewActivityModel activity) {
    final formattedOptimized = RichText(
      text: TextSpan(
        text:
            '${activity.optimizedVersionProfile} ${activity.optimizedVersionTitle}',
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );

    return [
      [LocaleKeys.media_details_optimized.tr(), formattedOptimized]
    ];
  }

  static List<List> player(NewActivityModel activity) {
    final formattedPlayer = RichText(
      text: TextSpan(
        text: activity.player,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );

    return [
      [LocaleKeys.media_details_player.tr(), formattedPlayer]
    ];
  }

  static List<List> product(NewActivityModel activity) {
    final formattedProduct = RichText(
      text: TextSpan(
        text: activity.product,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );
    return [
      [LocaleKeys.media_details_product.tr(), formattedProduct]
    ];
  }

  static List<List> quality(NewActivityModel activity) {
    String formattedBitrate = '';
    String finalText;

    if (activity.mediaType != enums.MediaType.photo &&
        activity.qualityProfile != 'Unknown' &&
        activity.streamBitrate != null) {
      if (activity.streamBitrate! > 1000) {
        formattedBitrate =
            '${(activity.streamBitrate! / 1000).toStringAsFixed(1)} Mbps';
      } else {
        formattedBitrate = '${activity.streamBitrate} kbps';
      }
    }

    if (isNotBlank(formattedBitrate)) {
      finalText = '${activity.qualityProfile} ($formattedBitrate)';
    } else {
      finalText = activity.qualityProfile;
    }

    final formattedQuality = RichText(
      text: TextSpan(
        text: finalText,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );

    return [
      [LocaleKeys.media_details_quality.tr(), formattedQuality]
    ];
  }

  static List<List> stream(NewActivityModel activity) {
    String finalText;

    if (activity.transcodeDecision == enums.StreamDecision.transcode) {
      if (activity.transcodeThrottled) {
        finalText =
            '${LocaleKeys.media_details_transcode.tr()} (${LocaleKeys.media_details_throttled.tr()})';
      } else {
        finalText =
            '${LocaleKeys.media_details_transcode.tr()} (${LocaleKeys.media_details_speed.tr()}: ${activity.transcodeSpeed})';
      }
    } else if (activity.transcodeDecision == enums.StreamDecision.copy) {
      finalText = LocaleKeys.media_details_direct_stream.tr();
    } else {
      finalText = LocaleKeys.media_details_direct_play.tr();
    }
    final formattedStream = RichText(
      text: TextSpan(
        text: finalText,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );

    return [
      [LocaleKeys.media_details_stream.tr(), formattedStream]
    ];
  }

  static List<List> subtitles(NewActivityModel activity) {
    String title = LocaleKeys.media_details_subtitle.tr();
    List<List> list = [];

    if (activity.subtitles) {
      if (activity.streamSubtitleDecision == enums.SubtitleDecision.transcode) {
        list.add([
          title,
          RichText(
            text: TextSpan(
              text: LocaleKeys.media_details_transcode.tr(),
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ]);

        String textLeft = '${activity.subtitleCodec?.toUpperCase()}';
        String textRight = '${activity.streamSubtitleCodec?.toUpperCase()}';

        list.add([
          '',
          _formatValue(left: textLeft, right: textRight),
        ]);
      } else if (activity.streamSubtitleDecision ==
          enums.SubtitleDecision.copy) {
        String textLeft =
            '${LocaleKeys.media_details_direct_stream.tr()} (${activity.subtitleCodec?.toUpperCase()})';

        list.add([
          title,
          _formatValue(left: textLeft),
        ]);
      } else if (activity.streamSubtitleDecision ==
          enums.SubtitleDecision.burn) {
        String textLeft =
            '${LocaleKeys.media_details_burn.tr()} (${activity.subtitleCodec?.toUpperCase()})';

        list.add([
          title,
          _formatValue(left: textLeft),
        ]);
      } else {
        if (activity.syncedVersion) {
          String textLeft =
              '${LocaleKeys.media_details_direct_play.tr()} (${activity.subtitleCodec?.toUpperCase()})';

          list.add([
            title,
            _formatValue(left: textLeft),
          ]);
        } else {
          String textLeft =
              '${LocaleKeys.media_details_direct_play.tr()} (${activity.streamSubtitleCodec?.toUpperCase()})';

          list.add([
            title,
            _formatValue(left: textLeft),
          ]);
        }
      }
    } else {
      String textLeft = LocaleKeys.media_details_none.tr();

      list.add([
        title,
        _formatValue(left: textLeft),
      ]);
    }
    return list;
  }

  static List<List> synced(NewActivityModel activity) {
    final formattedSynced = RichText(
      text: TextSpan(
        text: activity.syncedVersionProfile,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );

    return [
      [LocaleKeys.media_details_synced.tr(), formattedSynced]
    ];
  }

  static List<List> video(NewActivityModel activity) {
    const String title = 'VIDEO';
    List<List> list = [];

    String _videoDynamicRange = '';
    String _streamVideoDynamicRange = '';
    String _hwD = '';
    String _hwE = '';

    if ([
          enums.MediaType.movie,
          enums.MediaType.episode,
          enums.MediaType.clip,
          enums.MediaType.photo,
        ].contains(activity.mediaType) &&
        (activity.streamVideoDecision != enums.StreamDecision.UNKNOWN)) {
      if (activity.videoDynamicRange == enums.VideoDynamicRange.HDR) {
        _videoDynamicRange = ' ${activity.videoDynamicRange}';
        _streamVideoDynamicRange = ' ${activity.streamVideoDynamicRange}';
      }
      if (activity.streamVideoDecision == enums.StreamDecision.transcode) {
        if (activity.transcodeHwDecoding) {
          _hwD = ' (HW)';
        }
        if (activity.transcodeHwEncoding) {
          _hwE = ' (HW)';
        }
        list.add([
          title,
          RichText(
            text: TextSpan(
              text: LocaleKeys.media_details_transcode.tr(),
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ]);

        String textLeft =
            '${activity.videoCodec?.toUpperCase()}$_hwD ${activity.videoFullResolution}$_videoDynamicRange';
        String textRight =
            '${activity.streamVideoCodec?.toUpperCase()}$_hwE ${activity.streamVideoFullResolution}$_streamVideoDynamicRange';

        list.add([
          '',
          _formatValue(
            left: textLeft,
            right: textRight,
          ),
        ]);
      } else if (activity.streamVideoDecision == enums.StreamDecision.copy) {
        String textLeft =
            '${LocaleKeys.media_details_direct_stream.tr()} (${activity.streamVideoCodec?.toUpperCase()} ${activity.streamVideoFullResolution}$_streamVideoDynamicRange)';

        list.add([
          title,
          _formatValue(left: textLeft),
        ]);
      } else {
        String textLeft =
            '${LocaleKeys.media_details_direct_play.tr()} (${activity.streamVideoCodec?.toUpperCase()} ${activity.streamVideoFullResolution}$_streamVideoDynamicRange)';

        list.add([
          title,
          _formatValue(left: textLeft),
        ]);
      }
    } else if (activity.mediaType == enums.MediaType.photo) {
      String textLeft =
          '${LocaleKeys.media_details_direct_play.tr()} (${activity.width}x${activity.height})';

      list.add([
        title,
        _formatValue(left: textLeft),
      ]);
    }

    return list;
  }
}

class MediaFlagsCleaner {
  static String audioChannels(String flag) {
    switch (flag) {
      case '1':
        return 'Mono';
      case '2':
        return 'Stereo';
      case '3':
        return '2.1';
      case '4':
        return '3.1';
      case '6':
        return '5.1';
      case '7':
        return '6.1';
      case '8':
        return '7.1';
      default:
        return flag;
    }
  }
}

RichText _formatValue({
  final String? left,
  final String? right,
}) {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: left,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        if (isNotBlank(right))
          WidgetSpan(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
              ),
              child: const FaIcon(
                FontAwesomeIcons.longArrowAltRight,
                color: TautulliColorPalette.not_white,
                size: 16.5,
              ),
            ),
          ),
        if (isNotBlank(right))
          TextSpan(
            text: right,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
      ],
    ),
  );
}
