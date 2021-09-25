import 'package:equatable/equatable.dart';

import '../../../../core_new/enums/location.dart';
import '../../../../core_new/enums/media_type.dart';
import '../../../../core_new/enums/state.dart';
import '../../../../core_new/enums/stream_decision.dart';
import '../../../../core_new/enums/subtitle_decision.dart';
import '../../../../core_new/enums/video_dynamic_range.dart';

class NewActivity extends Equatable {
  final String? audioChannelLayout;
  final String? audioCodec;
  final String? bandwidth;
  final String? channelCallSign;
  final String? channelIdentifier;
  final String container;
  final int? duration;
  final String friendlyName;
  final int? grandparentRatingKey;
  final String? grandparentThumb;
  final String? grandparentTitle;
  final int height;
  final String ipAddress;
  final bool live;
  final Location location;
  final int mediaIndex;
  final MediaType mediaType;
  final bool optimizedVersion;
  final String? optimizedVersionProfile;
  final String? optimizedVersionTitle;
  final String? originallyAvailableAt;
  final int? parentMediaIndex;
  final int? parentRatingKey;
  final String? parentThumb;
  final String? parentTitle;
  final String platformName;
  final String player;
  final String product;
  final int progressPercent;
  final String qualityProfile;
  final int ratingKey;
  final bool relayed;
  final bool secure;
  final String sessionId;
  final int sessionKey;
  final State state;
  final String? streamAudioChannelLayout;
  final String? streamAudioCodec;
  final StreamDecision? streamAudioDecision;
  final int? streamBitrate;
  final String streamContainer;
  final StreamDecision? streamContainerDecision;
  final SubtitleDecision? streamSubtitleDecision;
  final String? streamSubtitleCodec;
  final String? streamVideoCodec;
  final StreamDecision? streamVideoDecision;
  final VideoDynamicRange? streamVideoDynamicRange;
  final String? streamVideoFullResolution;
  final String? subtitleCodec;
  final bool subtitles;
  //TODO: Should subType be an enum?
  final String? subType;
  final bool syncedVersion;
  final String? syncedVersionProfile;
  final String? thumb;
  final String title;
  final StreamDecision transcodeDecision;
  final bool transcodeHwDecoding;
  final bool transcodeHwEncoding;
  final int transcodeProgress;
  final double? transcodeSpeed;
  final bool transcodeThrottled;
  final int userId;
  final String userThumb;
  final String? videoCodec;
  final VideoDynamicRange? videoDynamicRange;
  final String? videoFullResolution;
  final int viewOffset;
  final int width;
  final int? year;
  final String? posterUrl;

  NewActivity({
    this.audioChannelLayout,
    this.audioCodec,
    this.bandwidth,
    this.channelCallSign,
    this.channelIdentifier,
    required this.container,
    this.duration,
    required this.friendlyName,
    this.grandparentRatingKey,
    this.grandparentThumb,
    this.grandparentTitle,
    required this.height,
    required this.ipAddress,
    required this.live,
    required this.location,
    required this.mediaIndex,
    required this.mediaType,
    required this.optimizedVersion,
    this.optimizedVersionProfile,
    this.optimizedVersionTitle,
    this.originallyAvailableAt,
    this.parentMediaIndex,
    this.parentRatingKey,
    this.parentThumb,
    this.parentTitle,
    required this.platformName,
    required this.player,
    required this.product,
    required this.progressPercent,
    required this.qualityProfile,
    required this.ratingKey,
    required this.relayed,
    required this.secure,
    required this.sessionKey,
    required this.sessionId,
    required this.state,
    this.streamAudioChannelLayout,
    this.streamAudioCodec,
    this.streamAudioDecision,
    this.streamBitrate,
    required this.streamContainer,
    this.streamContainerDecision,
    this.streamSubtitleDecision,
    this.streamSubtitleCodec,
    this.streamVideoCodec,
    this.streamVideoDecision,
    this.streamVideoDynamicRange,
    this.streamVideoFullResolution,
    this.subtitleCodec,
    required this.subtitles,
    this.subType,
    required this.syncedVersion,
    this.syncedVersionProfile,
    this.thumb,
    required this.title,
    required this.transcodeDecision,
    required this.transcodeHwEncoding,
    required this.transcodeHwDecoding,
    required this.transcodeProgress,
    this.transcodeSpeed,
    required this.transcodeThrottled,
    required this.userId,
    required this.userThumb,
    this.videoCodec,
    this.videoDynamicRange,
    this.videoFullResolution,
    required this.viewOffset,
    required this.width,
    this.year,
    this.posterUrl,
  });

  @override
  List<Object?> get props => [
        audioChannelLayout,
        audioCodec,
        bandwidth,
        channelCallSign,
        channelIdentifier,
        container,
        duration,
        friendlyName,
        grandparentRatingKey,
        grandparentThumb,
        grandparentTitle,
        height,
        ipAddress,
        live,
        location,
        mediaIndex,
        mediaType,
        optimizedVersion,
        optimizedVersionProfile,
        optimizedVersionTitle,
        originallyAvailableAt,
        parentMediaIndex,
        parentRatingKey,
        parentThumb,
        parentTitle,
        platformName,
        player,
        product,
        progressPercent,
        qualityProfile,
        ratingKey,
        relayed,
        secure,
        sessionKey,
        sessionId,
        state,
        streamAudioChannelLayout,
        streamAudioCodec,
        streamAudioDecision,
        streamBitrate,
        streamContainer,
        streamContainerDecision,
        streamSubtitleDecision,
        streamSubtitleCodec,
        streamVideoCodec,
        streamVideoDecision,
        streamVideoDynamicRange,
        streamVideoFullResolution,
        subtitleCodec,
        subtitles,
        subType,
        syncedVersion,
        syncedVersionProfile,
        thumb,
        title,
        transcodeDecision,
        transcodeHwEncoding,
        transcodeHwDecoding,
        transcodeProgress,
        transcodeSpeed,
        transcodeThrottled,
        userId,
        userThumb,
        videoCodec,
        videoDynamicRange,
        videoFullResolution,
        viewOffset,
        width,
        year,
        posterUrl,
      ];
}
