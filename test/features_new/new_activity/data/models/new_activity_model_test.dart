import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote/rewrite/core_new/enums/location.dart';
import 'package:tautulli_remote/rewrite/core_new/enums/media_type.dart';
import 'package:tautulli_remote/rewrite/core_new/enums/state.dart';
import 'package:tautulli_remote/rewrite/core_new/enums/stream_decision.dart';
import 'package:tautulli_remote/rewrite/core_new/enums/video_dynamic_range.dart';
import 'package:tautulli_remote/rewrite/features_new/new_activity/data/models/new_activity_model.dart';
import 'package:tautulli_remote/rewrite/features_new/new_activity/domain/entities/new_activity.dart';

import '../../../../fixtures_new/new_fixture_reader.dart';

void main() {
  final tNewActivityModel = NewActivityModel(
    audioCodec: 'eac3',
    bandwidth: '6478',
    channelCallSign: null,
    channelIdentifier: null,
    container: 'mkv',
    duration: 2776450,
    friendlyName: 'mock_friendly_name',
    grandparentRatingKey: 79309,
    grandparentThumb: null,
    grandparentTitle: 'Catch-22',
    height: 1080,
    ipAddress: '192.168.0.1',
    live: false,
    location: Location.WAN,
    mediaIndex: 2,
    mediaType: MediaType.episode,
    optimizedVersion: false,
    optimizedVersionProfile: null,
    optimizedVersionTitle: null,
    originallyAvailableAt: null,
    parentMediaIndex: 1,
    parentRatingKey: 1,
    parentThumb: null,
    parentTitle: null,
    platformName: 'chrome',
    player: 'Chrome',
    product: 'Plex Web',
    progressPercent: 11,
    qualityProfile: 'Original',
    ratingKey: 79329,
    relayed: false,
    secure: true,
    sessionId: 'm8bbpxpywe6i91zib3hnfltz',
    sessionKey: 10,
    state: State.playing,
    streamAudioChannelLayout: 'Stereo',
    streamAudioCodec: 'aac',
    streamAudioDecision: StreamDecision.transcode,
    streamBitrate: 6574,
    streamContainer: 'mp4',
    streamContainerDecision: StreamDecision.transcode,
    streamSubtitleDecision: null,
    streamSubtitleCodec: null,
    streamVideoCodec: 'h264',
    streamVideoDecision: StreamDecision.copy,
    streamVideoDynamicRange: VideoDynamicRange.SDR,
    streamVideoFullResolution: '1080p',
    subtitleCodec: null,
    subtitles: false,
    syncedVersion: false,
    syncedVersionProfile: null,
    thumb: null,
    title: 'Episode 2',
    transcodeDecision: StreamDecision.transcode,
    transcodeHwDecoding: false,
    transcodeHwEncoding: false,
    transcodeProgress: 21,
    transcodeSpeed: 0.0,
    transcodeThrottled: true,
    userId: 1521111,
    userThumb: 'https://plex.tv/users/5df7320378672025/avatar?c=1521111',
    videoCodec: 'h264',
    videoDynamicRange: VideoDynamicRange.SDR,
    videoFullResolution: '1080p',
    viewOffset: 317000,
    width: 1920,
    year: 2019,
  );

  test(
    'should be a subclass of NewActivity entity',
    () async {
      // assert
      expect(tNewActivityModel, isA<NewActivity>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('new_activity_item.json'));
        // act
        final result = NewActivityModel.fromJson(jsonMap);
        // assert
        expect(result, tNewActivityModel);
      },
    );
  });
}
