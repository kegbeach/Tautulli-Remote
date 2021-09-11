import 'package:quiver/strings.dart';

class StringHelper {
  /// Capitalizes the first letter of a string.
  ///
  /// Throws an [ArgumentError] if string is null.
  static String capitalize(String? string) {
    if (isBlank(string)) {
      return string!;
    }

    return string![0].toUpperCase() + string.substring(1);
  }

  /// Replaces all but the last 2 letters of [string]
  /// with the same number of `*`.
  static String maskSensitiveInfo(String string) {
    final int maskLength = string.length - 2;
    String maskString = '';

    for (int i = maskLength; i > 0; i--) {
      maskString += '*';
    }

    return string.replaceRange(0, maskLength, maskString);
  }
}
