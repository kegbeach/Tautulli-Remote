part of 'new_settings_bloc.dart';

abstract class NewSettingsState extends Equatable {
  const NewSettingsState();
}

class NewSettingsInitial extends NewSettingsState {
  @override
  List<Object> get props => [];
}

class NewSettingsInProgress extends NewSettingsState {
  @override
  List<Object> get props => [];
}

class NewSettingsSuccess extends NewSettingsState {
  final bool doubleTapToExit;
  final bool graphTipsShown;
  final String? lastSelectedServer;
  final bool maskSensitiveInfo;
  final bool oneSignalBannerDismissed;
  final int refreshRate;
  final List<NewServerModel> serverList;
  final int serverTimeout;
  final String statsType;
  final String usersSort;
  final String yAxis;

  const NewSettingsSuccess({
    required this.doubleTapToExit,
    required this.graphTipsShown,
    this.lastSelectedServer,
    required this.maskSensitiveInfo,
    required this.oneSignalBannerDismissed,
    required this.refreshRate,
    required this.serverList,
    required this.serverTimeout,
    required this.statsType,
    required this.usersSort,
    required this.yAxis,
  });

  NewSettingsSuccess copyWith({
    bool? doubleTapToExit,
    bool? graphTipsShown,
    String? lastSelectedServer,
    bool? maskSensitiveInfo,
    bool? oneSignalBannerDismissed,
    int? refreshRate,
    List<NewServerModel>? serverList,
    int? serverTimeout,
    String? statsType,
    String? usersSort,
    String? yAxis,
  }) {
    return NewSettingsSuccess(
      doubleTapToExit: doubleTapToExit ?? this.doubleTapToExit,
      graphTipsShown: graphTipsShown ?? this.graphTipsShown,
      lastSelectedServer: lastSelectedServer ?? this.lastSelectedServer,
      maskSensitiveInfo: maskSensitiveInfo ?? this.maskSensitiveInfo,
      oneSignalBannerDismissed:
          oneSignalBannerDismissed ?? this.oneSignalBannerDismissed,
      refreshRate: refreshRate ?? this.refreshRate,
      serverList: serverList ?? this.serverList,
      serverTimeout: serverTimeout ?? this.serverTimeout,
      statsType: statsType ?? this.statsType,
      usersSort: usersSort ?? this.usersSort,
      yAxis: yAxis ?? this.yAxis,
    );
  }

  @override
  List<Object> get props => [
        doubleTapToExit,
        graphTipsShown,
        maskSensitiveInfo,
        oneSignalBannerDismissed,
        refreshRate,
        serverList,
        serverTimeout,
        statsType,
        usersSort,
        yAxis,
      ];
}

class NewSettingsFailure extends NewSettingsState {
  @override
  List<Object> get props => [];
}
