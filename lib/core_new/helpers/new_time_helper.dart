import 'package:duration/duration.dart';

class NewTimeHelper {
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
