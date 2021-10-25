part of 'new_settings_bloc.dart';

abstract class NewSettingsEvent extends Equatable {
  const NewSettingsEvent();

  @override
  List<Object?> get props => [];
}

class NewSettingsAddServer extends NewSettingsEvent {
  final String primaryConnectionAddress;
  final String? secondaryConnectionAddress;
  final String deviceToken;
  final String tautulliId;
  final String plexName;
  final String plexIdentifier;
  final bool plexPass;
  final bool onesignalRegistered;
  final List<NewCustomHeaderModel> customHeaders;

  const NewSettingsAddServer({
    required this.primaryConnectionAddress,
    this.secondaryConnectionAddress,
    required this.deviceToken,
    required this.tautulliId,
    required this.plexName,
    required this.plexIdentifier,
    required this.plexPass,
    required this.onesignalRegistered,
    this.customHeaders = const [],
  });

  @override
  List<Object> get props => [
        primaryConnectionAddress,
        deviceToken,
        tautulliId,
        plexName,
        plexPass,
        onesignalRegistered,
        customHeaders,
      ];
}

class NewSettingsDeleteCustomHeader extends NewSettingsEvent {
  final String tautulliId;
  final String key;

  const NewSettingsDeleteCustomHeader({
    required this.tautulliId,
    required this.key,
  });

  @override
  List<Object> get props => [tautulliId, key];
}

class NewSettingsDeleteServer extends NewSettingsEvent {
  final int id;
  final String plexName;

  const NewSettingsDeleteServer({
    required this.id,
    required this.plexName,
  });

  @override
  List<Object> get props => [id, plexName];
}

class NewSettingsLoad extends NewSettingsEvent {}

class NewSettingsUpdateConnectionAddress extends NewSettingsEvent {
  final bool primaryConnection;
  final String connectionAddress;
  final NewServerModel server;

  const NewSettingsUpdateConnectionAddress({
    required this.primaryConnection,
    required this.connectionAddress,
    required this.server,
  });

  @override
  List<Object?> get props => [primaryConnection, connectionAddress, server];
}

class NewSettingsUpdateCustomHeaders extends NewSettingsEvent {
  final String tautulliId;
  final String key;
  final String value;
  final bool basicAuth;
  final String? previousKey;

  const NewSettingsUpdateCustomHeaders({
    required this.tautulliId,
    required this.key,
    required this.value,
    this.basicAuth = false,
    this.previousKey,
  });

  @override
  List<Object> get props => [tautulliId, key, value, basicAuth];
}

class NewSettingsUpdateDoubleTapToExit extends NewSettingsEvent {
  final bool doubleTapToExit;

  const NewSettingsUpdateDoubleTapToExit(this.doubleTapToExit);

  @override
  List<Object?> get props => [doubleTapToExit];
}

class NewSettingsUpdateMaskSensitiveInfo extends NewSettingsEvent {
  final bool maskSensitiveInfo;

  const NewSettingsUpdateMaskSensitiveInfo(this.maskSensitiveInfo);

  @override
  List<Object?> get props => [maskSensitiveInfo];
}

class NewSettingsUpdateOnesignalBannerDismiss extends NewSettingsEvent {
  final bool dismiss;

  const NewSettingsUpdateOnesignalBannerDismiss(this.dismiss);

  @override
  List<Object?> get props => [dismiss];
}

class NewSettingsUpdatePrimaryActive extends NewSettingsEvent {
  final bool primaryActive;
  final NewServerModel server;

  const NewSettingsUpdatePrimaryActive({
    required this.primaryActive,
    required this.server,
  });

  @override
  List<Object?> get props => [primaryActive, server];
}

class NewSettingsUpdateServer extends NewSettingsEvent {
  final int id;
  final int sortIndex;
  final String primaryConnectionAddress;
  final String secondaryConnectionAddress;
  final String deviceToken;
  final String tautulliId;
  final String plexName;
  final String plexIdentifier;
  final bool plexPass;
  final String? dateFormat;
  final String? timeFormat;
  final bool onesignalRegistered;
  final List<NewCustomHeaderModel> customHeaders;

  const NewSettingsUpdateServer({
    required this.id,
    required this.sortIndex,
    required this.primaryConnectionAddress,
    required this.secondaryConnectionAddress,
    required this.deviceToken,
    required this.tautulliId,
    required this.plexName,
    required this.plexIdentifier,
    required this.plexPass,
    this.dateFormat,
    this.timeFormat,
    required this.onesignalRegistered,
    required this.customHeaders,
  });

  @override
  List<Object> get props => [
        id,
        sortIndex,
        primaryConnectionAddress,
        secondaryConnectionAddress,
        deviceToken,
        tautulliId,
        plexName,
        plexPass,
        onesignalRegistered,
        customHeaders,
      ];
}

class NewSettingsUpdateRefreshRate extends NewSettingsEvent {
  final int refreshRate;

  const NewSettingsUpdateRefreshRate(this.refreshRate);

  @override
  List<Object?> get props => [refreshRate];
}

class NewSettingsUpdateServerTimeout extends NewSettingsEvent {
  final int timeout;

  const NewSettingsUpdateServerTimeout(this.timeout);

  @override
  List<Object?> get props => [timeout];
}
