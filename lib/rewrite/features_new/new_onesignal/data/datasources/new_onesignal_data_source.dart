import 'package:onesignal_flutter/onesignal_flutter.dart';

abstract class NewOnesignalDataSource {
  /// Provides the OneSignal User ID (AKA playerID).
  ///
  /// Returns `'onesignal-disabled'` if an error is thrown.
  Future<String> get userId;
}

class NewOnesignalDataSourceImpl implements NewOnesignalDataSource {
  @override
  Future<String> get userId async {
    try {
      final OSDeviceState? status = await OneSignal.shared.getDeviceState();
      if (status != null) {
        final String? userId = status.userId;
        if (userId != null) {
          return userId;
        }
      }
      return 'onesignal-disabled';
    } catch (_) {
      return 'onesignal-disabled';
    }
  }
}
