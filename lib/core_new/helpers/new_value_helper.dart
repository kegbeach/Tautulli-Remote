import 'package:quiver/strings.dart';

import '../enums/location.dart';
import '../enums/media_type.dart';
import '../enums/state.dart';
import '../enums/stream_decision.dart';
import '../enums/subtitle_decision.dart';
import '../enums/video_dynamic_range.dart';

enum CastType {
  bool,
  int,
  double,
  num,
  string,
  location,
  mediaType,
  state,
  streamDecision,
  subtitleDecision,
  videoDynamicRange,
}

class NewValueHelper {
  static dynamic cast(
    dynamic value,
    CastType type,
  ) {
    try {
      if (value == null || (value is String && isBlank(value))) {
        return null;
      } else {
        switch (type) {
          case (CastType.bool):
            if ([1, true, '1', 'true'].contains(value)) {
              return true;
            }
            if ([0, false, '0', 'false'].contains(value)) {
              return false;
            }

            throw const FormatException();

          case (CastType.int):
            return int.parse(value.toString());

          case (CastType.double):
            return double.parse(value.toString());

          case (CastType.num):
            return num.parse(value.toString());

          case (CastType.string):
            if (isEmpty(value)) {
              return null;
            }

            return value.toString().trim();

          case (CastType.location):
            switch (value) {
              case ('lan'):
                return Location.LAN;
              case ('wan'):
                return Location.WAN;
              case ('cellular'):
                return Location.cellular;
              default:
                throw const FormatException();
            }

          case (CastType.mediaType):
            switch (value) {
              case ('album'):
                return MediaType.album;
              case ('clip'):
                return MediaType.clip;
              case ('collection'):
                return MediaType.collection;
              case ('episode'):
                return MediaType.episode;
              case ('movie'):
                return MediaType.movie;
              case ('photo'):
                return MediaType.photo;
              case ('playlist'):
                return MediaType.playlist;
              case ('season'):
                return MediaType.season;
              case ('show'):
                return MediaType.show;
              case ('track'):
                return MediaType.track;
              default:
                throw const FormatException();
            }

          case (CastType.state):
            switch (value) {
              case ('buffering'):
                return State.buffering;
              case ('error'):
                return State.error;
              case ('paused'):
                return State.paused;
              case ('playing'):
                return State.playing;
              default:
                throw const FormatException();
            }

          case (CastType.streamDecision):
            switch (value) {
              case ('copy'):
                return StreamDecision.copy;
              case ('direct play'):
                return StreamDecision.directPlay;
              case ('transcode'):
                return StreamDecision.transcode;
              default:
                throw const FormatException();
            }

          case (CastType.subtitleDecision):
            switch (value) {
              case ('burn'):
                return SubtitleDecision.burn;
              case ('copy'):
                return SubtitleDecision.copy;
              case ('transcode'):
                return SubtitleDecision.transcode;
              default:
                throw const FormatException();
            }

          case (CastType.videoDynamicRange):
            switch (value) {
              case ('hdr'):
              case ('HDR'):
                return VideoDynamicRange.HDR;
              case ('sdr'):
              case ('SDR'):
                return VideoDynamicRange.SDR;
              default:
                throw const FormatException();
            }
        }
      }
    } catch (e) {
      //TODO: Log error
      print('Failed top cast $value to $type');
      rethrow;
    }
  }
}
