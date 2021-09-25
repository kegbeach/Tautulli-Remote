import 'package:duration/duration.dart';
import 'package:intl/intl.dart';

class NewTimeHelper {
  static String eta(
    int duration,
    int progressPercent,
    String? timeFormat,
  ) {
    Duration time = Duration(
        milliseconds: (duration * (1 - (progressPercent / 100))).round());

    DateTime eta = DateTime.now().add(time);

    final String parsedTimeFormat =
        timeFormat != null ? _parseTimeFormat(timeFormat) : 'HH:mm';

    return DateFormat("'ETA: '$parsedTimeFormat").format(eta);
  }

  /// Converts a [Duration] to a `hh:mm:ss` format.
  static String hourMinSec(Duration duration) {
    if (duration.inHours <= 0) {
      return '${duration.inMinutes.remainder(60).toString().padLeft(1, "0")}:${duration.inSeconds.remainder(60).toString().padLeft(2, "0")}';
    } else {
      return '${duration.inHours}:${duration.inMinutes.remainder(60).toString().padLeft(2, "0")}:${duration.inSeconds.remainder(60).toString().padLeft(2, "0")}';
    }
  }

  /// Returns a cleaner version of [Duration].
  ///
  /// Example: `1h, 6m` or `10m, 5s`.
  static String timeLeft(int duration, int progressPercent) {
    Duration time = Duration(
        milliseconds: (duration * (1 - (progressPercent / 100))).round());

    if (time.inMinutes < 1) {
      return prettyDuration(
        time,
        abbreviated: true,
        tersity: DurationTersity.second,
      );
    } else {
      return prettyDuration(
        time,
        abbreviated: true,
        tersity: DurationTersity.minute,
      );
    }
  }
}

String _parseDateFormat(String dateFormat) {
  return dateFormat
      .replaceAll('YYYY', 'y')
      .replaceAll('YY', 'yy')
      // .replaceAll('MMMM', 'MMMM')
      // .replaceAll('MMM', 'MMM')
      // .replaceAll('MM', 'MM')
      // .replaceAll('M', 'M')
      .replaceAll('Mo', 'M')
      .replaceAll('dddd', 'EEEE')
      .replaceAll('ddd', 'E')
      .replaceAll('dd', 'E')
      .replaceAll('do', 'E')
      .replaceAll('d', 'E')
      .replaceAll('DDDo', 'DD')
      .replaceAll('DDDD', 'DDD')
      .replaceAll('DDD', 'DD')
      .replaceAll('DD', 'dd')
      .replaceAll('Do', 'd')
      .replaceAll('D', 'd');
}

String _parseTimeFormat(String timeFormat) {
  return timeFormat
      // .replaceAll('HH', 'HH')
      // .replaceAll('H', 'H')
      // .replaceAll('hh', 'hh')
      // .replaceAll('h', 'h')
      // .replaceAll('mm', 'mm')
      // .replaceAll('m', 'm')
      // .replaceAll('ss', 'ss')
      // .replaceAll('s', 's')
      .replaceAll('a', 'a')
      .replaceAll('A', 'a')
      .replaceAll('ZZ', '')
      .replaceAll('Z', '')
      .replaceAll('X', '');
}
