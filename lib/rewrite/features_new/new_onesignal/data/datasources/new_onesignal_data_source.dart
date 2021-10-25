import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../../../core_new/network_info/new_network_info.dart';
import '../../../new_settings/domain/usecases/new_settings.dart';

abstract class NewOnesignalDataSource {
  /// Disables or enables push notifications
  Future<void> disablePush(bool value);

  /// Grants or revokes consent based on the provided boolean.
  Future<void> grantConsent(bool value);

  /// Returns `true` if the user has granted consent to the OneSignal SDK.
  Future<bool> get hasConsented;

  /// Checks if `https://onesignal.com` is reachable.
  Future<bool> get isReachable;

  /// Indicates if the user is subscribed to OneSignal.
  Future<bool> get isSubscribed;

  /// Provides the OneSignal User ID (AKA playerID).
  ///
  /// Returns `'onesignal-disabled'` if an error is thrown.
  Future<String> get userId;
}

class NewOnesignalDataSourceImpl implements NewOnesignalDataSource {
  final http.Client client;
  final NewNetworkInfo networkInfo;
  final NewSettings settings;

  NewOnesignalDataSourceImpl({
    required this.client,
    required this.networkInfo,
    required this.settings,
  });

  @override
  Future<void> disablePush(bool value) async {
    await OneSignal.shared.disablePush(value);
  }

  @override
  Future<void> grantConsent(bool value) async {
    await OneSignal.shared.consentGranted(value);
  }

  @override
  Future<bool> get hasConsented async {
    return await settings.getOneSignalConsented();
  }

  @override
  Future<bool> get isReachable async {
    if (await networkInfo.isConnected) {
      final response = await client.head(Uri.parse('https://onesignal.com'));
      if (response.statusCode == 200) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> get isSubscribed async {
    final state = await OneSignal.shared.getDeviceState();
    if (state != null) {
      return state.subscribed;
    } else {
      return false;
    }
  }

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
