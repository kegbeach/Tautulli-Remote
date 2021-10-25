import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quiver/strings.dart';

import '../../../../core_new/database/data/models/new_custom_header_model.dart';
import '../../../../core_new/database/data/models/new_server_model.dart';
import '../../../../core_new/enums/protocol.dart';
import '../../../new_logging/domain/usecases/new_logging.dart';
import '../../data/models/connection_address_model.dart';
import '../../data/models/new_plex_server_info_model.dart';
import '../../data/models/new_tautulli_settings_general_model.dart';
import '../../domain/usecases/new_settings.dart';
import '../../../../core_new/enums/protocol.dart';

part 'new_settings_event.dart';
part 'new_settings_state.dart';

class NewSettingsBloc extends Bloc<NewSettingsEvent, NewSettingsState> {
  final NewSettings settings;
  final NewLogging logging;

  NewSettingsBloc({
    required this.settings,
    required this.logging,
  }) : super(NewSettingsInitial()) {
    on<NewSettingsAddServer>(
      (event, emit) => _onNewSettingsAddServer(event, emit),
    );
    on<NewSettingsDeleteCustomHeader>(
      (event, emit) => _onNewSettingsDeleteCustomHeader(event, emit),
    );
    on<NewSettingsDeleteServer>(
      (event, emit) => _onNewSettingsDeleteServer(event, emit),
    );
    on<NewSettingsLoad>((event, emit) => _onNewSettingsLoad(event, emit));
    on<NewSettingsUpdateConnectionAddress>(
      (event, emit) => _onNewSettingsUpdateConnectionAddress(event, emit),
    );
    on<NewSettingsUpdateCustomHeaders>(
      (event, emit) => _onNewSettingsUpdateCustomHeaders(event, emit),
    );
    on<NewSettingsUpdateDoubleTapToExit>(
      (event, emit) => _onNewSettingsUpdateDoubleTapToExit(event, emit),
    );
    on<NewSettingsUpdateMaskSensitiveInfo>(
      (event, emit) => _onNewSettingsUpdateMaskSensitiveInfo(event, emit),
    );
    on<NewSettingsUpdateOnesignalBannerDismiss>(
      (event, emit) => _onNewSettingsUpdateOnesignalBannerDismiss(event, emit),
    );
    on<NewSettingsUpdatePrimaryActive>(
      (event, emit) => _onNewSettingsUpdatePrimaryActive(event, emit),
    );
    on<NewSettingsUpdateServer>(
      (event, emit) => _onNewSettingsUpdateServer(event, emit),
    );
    on<NewSettingsUpdateRefreshRate>(
      (event, emit) => _onNewSettingsUpdateRefreshRate(event, emit),
    );
    on<NewSettingsUpdateServerTimeout>(
      (event, emit) => _onNewSettingsUpdateServerTimeout(event, emit),
    );
  }

  void _onNewSettingsAddServer(
    NewSettingsAddServer event,
    Emitter<NewSettingsState> emit,
  ) async {
    final currentState = state as NewSettingsSuccess;

    logging.info(
      'Settings :: Saving server details for ${event.plexName}',
    );

    final ConnectionAddressModel primaryConnectionAddress =
        ConnectionAddressModel.fromConnectionAddress(
      primary: true,
      connectionAddress: event.primaryConnectionAddress,
    );

    ConnectionAddressModel secondaryConnectionAddress =
        const ConnectionAddressModel(
      primary: false,
    );
    if (isNotBlank(event.secondaryConnectionAddress)) {
      secondaryConnectionAddress = ConnectionAddressModel.fromConnectionAddress(
        primary: false,
        connectionAddress: event.secondaryConnectionAddress!,
      );
    }

    NewServerModel server = NewServerModel(
      sortIndex: currentState.serverList.length,
      primaryConnectionAddress: primaryConnectionAddress.address!,
      primaryConnectionProtocol:
          primaryConnectionAddress.protocol!.toShortString(),
      primaryConnectionDomain: primaryConnectionAddress.domain!,
      primaryConnectionPath: primaryConnectionAddress.path,
      secondaryConnectionAddress: secondaryConnectionAddress.address,
      secondaryConnectionProtocol:
          secondaryConnectionAddress.protocol?.toShortString(),
      secondaryConnectionDomain: secondaryConnectionAddress.domain,
      secondaryConnectionPath: secondaryConnectionAddress.path,
      deviceToken: event.deviceToken,
      tautulliId: event.tautulliId,
      plexName: event.plexName,
      plexIdentifier: event.plexIdentifier,
      primaryActive: true,
      onesignalRegistered: event.onesignalRegistered,
      plexPass: event.plexPass,
      customHeaders: event.customHeaders,
    );

    await settings.addServer(server);

    // Fetch just added server in order to get DB ID
    server = await settings.getServerByTautulliId(server.tautulliId);

    List<NewServerModel> updatedList = [...currentState.serverList];

    updatedList.add(server);
    if (updatedList.length > 1) {
      updatedList.sort((a, b) => a.sortIndex.compareTo(b.sortIndex));
    }

    emit(
      currentState.copyWith(serverList: updatedList),
    );

    //TODO
    // _checkServersForChanges();
  }

  void _onNewSettingsDeleteCustomHeader(
    NewSettingsDeleteCustomHeader event,
    Emitter<NewSettingsState> emit,
  ) async {
    final currentState = state as NewSettingsSuccess;

    final int index = currentState.serverList.indexWhere(
      (server) => server.tautulliId == event.tautulliId,
    );

    List<NewServerModel> updatedList = [...currentState.serverList];

    List<NewCustomHeaderModel> customHeaders = [
      ...updatedList[index].customHeaders
    ];

    //TODO: Logging

    customHeaders.removeWhere((header) => header.key == event.key);

    await settings.updateCustomHeaders(
      tautulliId: event.tautulliId,
      customHeaders: customHeaders,
    );

    updatedList[index] = currentState.serverList[index].copyWith(
      customHeaders: customHeaders,
    );
    emit(
      currentState.copyWith(serverList: updatedList),
    );
  }

  void _onNewSettingsDeleteServer(
    NewSettingsDeleteServer event,
    Emitter<NewSettingsState> emit,
  ) async {
    final currentState = state as NewSettingsSuccess;
    //TODO: Logging

    await settings.deleteServer(event.id);

    List<NewServerModel> updatedList = [...currentState.serverList];

    final int index = updatedList.indexWhere(
      (server) => server.id == event.id,
    );
    updatedList.removeAt(index);

    emit(
      currentState.copyWith(serverList: updatedList),
    );
  }

  void _onNewSettingsLoad(
    NewSettingsLoad event,
    Emitter<NewSettingsState> emit,
  ) async {
    emit(
      NewSettingsInProgress(),
    );

    // Fetch settings
    final bool doubleTapToExit = await settings.getDoubleTapToExit();
    final bool graphTipsShown = await settings.getGraphTipsShown();
    final String? lastSelectedServer = await settings.getLastSelectedServer();
    final bool maskSensitiveInfo = await settings.getMaskSensitiveInfo();
    final bool oneSignalBannerDismissed =
        await settings.getOneSignalBannerDismissed();
    final int refreshRate = await settings.getRefreshRate();
    final List<NewServerModel> serverList = await settings.getAllServers();
    final int serverTimeout = await settings.getServerTimeout();
    final String statsType = await settings.getStatsType();
    final String usersSort = await settings.getUsersSort();
    final String yAxis = await settings.getYAxis();

    // Sort server list using sort index
    if (serverList.length > 1) {
      serverList.sort((a, b) => a.sortIndex.compareTo(b.sortIndex));
    }

    emit(
      NewSettingsSuccess(
        doubleTapToExit: doubleTapToExit,
        graphTipsShown: graphTipsShown,
        lastSelectedServer: lastSelectedServer,
        maskSensitiveInfo: maskSensitiveInfo,
        oneSignalBannerDismissed: oneSignalBannerDismissed,
        refreshRate: refreshRate,
        serverList: serverList,
        serverTimeout: serverTimeout,
        statsType: statsType,
        usersSort: usersSort,
        yAxis: yAxis,
      ),
    );
    //TODO
    // _checkServersForChanges();
  }

  void _onNewSettingsUpdateConnectionAddress(
    NewSettingsUpdateConnectionAddress event,
    Emitter<NewSettingsState> emit,
  ) async {
    final currentState = state as NewSettingsSuccess;
    //TODO: Log connection update (for primary or secondary)

    final connectionAddress = ConnectionAddressModel.fromConnectionAddress(
      primary: event.primaryConnection,
      connectionAddress: event.connectionAddress,
    );

    await settings.updateConnectionInfo(
      id: event.server.id!,
      connectionAddress: connectionAddress,
    );

    final int index = currentState.serverList.indexWhere(
      (oldServer) => oldServer.id == event.server.id,
    );

    List<NewServerModel> updatedList = [...currentState.serverList];

    if (event.primaryConnection) {
      updatedList[index] = currentState.serverList[index].copyWith(
        primaryConnectionAddress: connectionAddress.address,
        primaryConnectionProtocol: connectionAddress.protocol?.toShortString(),
        primaryConnectionDomain: connectionAddress.domain,
        primaryConnectionPath: connectionAddress.path,
      );
    } else {
      updatedList[index] = currentState.serverList[index].copyWith(
        secondaryConnectionAddress: connectionAddress.address,
        secondaryConnectionProtocol:
            connectionAddress.protocol?.toShortString(),
        secondaryConnectionDomain: connectionAddress.domain,
        secondaryConnectionPath: connectionAddress.path,
      );
    }

    emit(
      currentState.copyWith(serverList: updatedList),
    );
  }

  void _onNewSettingsUpdateCustomHeaders(
    NewSettingsUpdateCustomHeaders event,
    Emitter<NewSettingsState> emit,
  ) async {
    final currentState = state as NewSettingsSuccess;

    final int index = currentState.serverList.indexWhere(
      (server) => server.tautulliId == event.tautulliId,
    );

    List<NewServerModel> updatedList = [...currentState.serverList];

    List<NewCustomHeaderModel> customHeaders = [
      ...updatedList[index].customHeaders
    ];

    if (event.basicAuth) {
      final currentIndex = customHeaders.indexWhere(
        (header) => header.key == 'Authorization',
      );

      final String base64Value = base64Encode(
        utf8.encode('${event.key}:${event.value}'),
      );

      if (currentIndex == -1) {
        customHeaders.add(
          NewCustomHeaderModel(
            key: 'Authorization',
            value: 'Basic $base64Value',
          ),
        );
      } else {
        customHeaders[currentIndex] = NewCustomHeaderModel(
          key: 'Authorization',
          value: 'Basic $base64Value',
        );
      }
    } else {
      if (event.previousKey != null) {
        final oldIndex = customHeaders.indexWhere(
          (header) => header.key == event.previousKey,
        );

        customHeaders[oldIndex] = NewCustomHeaderModel(
          key: event.key,
          value: event.value,
        );
      } else {
        final currentIndex = customHeaders.indexWhere(
          (header) => header.key == event.key,
        );

        if (currentIndex == -1) {
          customHeaders.add(
            NewCustomHeaderModel(
              key: event.key,
              value: event.value,
            ),
          );
        } else {
          customHeaders[currentIndex] = NewCustomHeaderModel(
            key: event.key,
            value: event.value,
          );
        }
      }
    }

    await settings.updateCustomHeaders(
      tautulliId: event.tautulliId,
      customHeaders: customHeaders,
    );

    updatedList[index] = currentState.serverList[index].copyWith(
      customHeaders: customHeaders,
    );

    emit(
      currentState.copyWith(serverList: updatedList),
    );
  }

  void _onNewSettingsUpdateDoubleTapToExit(
    NewSettingsUpdateDoubleTapToExit event,
    Emitter<NewSettingsState> emit,
  ) async {
    final currentState = state as NewSettingsSuccess;
    await settings.setDoubleTapToExit(event.doubleTapToExit);
    emit(
      currentState.copyWith(doubleTapToExit: event.doubleTapToExit),
    );
  }

  void _onNewSettingsUpdateMaskSensitiveInfo(
    NewSettingsUpdateMaskSensitiveInfo event,
    Emitter<NewSettingsState> emit,
  ) async {
    final currentState = state as NewSettingsSuccess;
    await settings.setMaskSensitiveInfo(event.maskSensitiveInfo);
    emit(
      currentState.copyWith(maskSensitiveInfo: event.maskSensitiveInfo),
    );
  }

  void _onNewSettingsUpdateOnesignalBannerDismiss(
    NewSettingsUpdateOnesignalBannerDismiss event,
    Emitter<NewSettingsState> emit,
  ) async {
    final currentState = state as NewSettingsSuccess;

    if (event.dismiss) {
      //TODO: Log dismiss
    }

    await settings.setOneSignalBannerDismissed(event.dismiss);
    emit(
      currentState.copyWith(oneSignalBannerDismissed: event.dismiss),
    );
  }

  void _onNewSettingsUpdatePrimaryActive(
    NewSettingsUpdatePrimaryActive event,
    Emitter<NewSettingsState> emit,
  ) async {
    final currentState = state as NewSettingsSuccess;

    await settings.updatePrimaryActive(
      tautulliId: event.server.tautulliId,
      primaryActive: event.primaryActive,
    );

    final int index = currentState.serverList.indexWhere(
      (oldServer) => oldServer.tautulliId == event.server.tautulliId,
    );

    List<NewServerModel> updatedList = [...currentState.serverList];

    updatedList[index] = currentState.serverList[index].copyWith(
      primaryActive: event.primaryActive,
    );

    emit(
      currentState.copyWith(serverList: updatedList),
    );
  }

  void _onNewSettingsUpdateServer(
    NewSettingsUpdateServer event,
    Emitter<NewSettingsState> emit,
  ) async {
    final currentState = state as NewSettingsSuccess;

    //TODO: Log server update

    final primaryConnectionAddress =
        ConnectionAddressModel.fromConnectionAddress(
      primary: true,
      connectionAddress: event.primaryConnectionAddress,
    );

    final secondaryConnectionAddress =
        ConnectionAddressModel.fromConnectionAddress(
      primary: false,
      connectionAddress: event.secondaryConnectionAddress,
    );

    List<NewServerModel> updatedList = [...currentState.serverList];

    final int index = currentState.serverList.indexWhere(
      (server) => server.id == event.id,
    );

    updatedList[index] = currentState.serverList[index].copyWith(
      id: event.id,
      sortIndex: event.sortIndex,
      primaryConnectionAddress: primaryConnectionAddress.address,
      primaryConnectionProtocol:
          primaryConnectionAddress.protocol?.toShortString(),
      primaryConnectionDomain: primaryConnectionAddress.domain,
      primaryConnectionPath: primaryConnectionAddress.path,
      secondaryConnectionAddress: secondaryConnectionAddress.address,
      secondaryConnectionProtocol:
          secondaryConnectionAddress.protocol?.toShortString(),
      secondaryConnectionDomain: secondaryConnectionAddress.domain,
      secondaryConnectionPath: secondaryConnectionAddress.path,
      deviceToken: event.deviceToken,
      tautulliId: event.tautulliId,
      plexName: event.plexName,
      plexIdentifier: event.plexIdentifier,
      primaryActive: true,
      onesignalRegistered: event.onesignalRegistered,
      plexPass: event.plexPass,
      dateFormat: event.dateFormat,
      timeFormat: event.timeFormat,
      customHeaders: event.customHeaders,
    );

    await settings.updateServer(updatedList[index]);

    emit(
      currentState.copyWith(serverList: updatedList),
    );
  }

  void _onNewSettingsUpdateRefreshRate(
    NewSettingsUpdateRefreshRate event,
    Emitter<NewSettingsState> emit,
  ) async {
    final currentState = state as NewSettingsSuccess;

    //TODO: Log change
    await settings.setRefreshRate(event.refreshRate);
    emit(
      currentState.copyWith(refreshRate: event.refreshRate),
    );
  }

  void _onNewSettingsUpdateServerTimeout(
    NewSettingsUpdateServerTimeout event,
    Emitter<NewSettingsState> emit,
  ) async {
    final currentState = state as NewSettingsSuccess;

    //TODO: Log change
    await settings.setServerTimeout(event.timeout);
    emit(
      currentState.copyWith(serverTimeout: event.timeout),
    );
  }

  void _checkServersForChanges() async {
    final serverList = await settings.getAllServers();

    for (NewServerModel server in serverList) {
      await _getServerInformation(server).then(
        (settingsMap) {
          if (settingsMap['needsUpdate']) {
            add(
              NewSettingsUpdateServer(
                id: server.id!,
                sortIndex: server.sortIndex,
                primaryConnectionAddress: server.primaryConnectionAddress,
                secondaryConnectionAddress:
                    server.secondaryConnectionAddress ?? '',
                deviceToken: server.deviceToken,
                tautulliId: server.tautulliId,
                plexName: settingsMap['pmsName'],
                plexIdentifier: settingsMap['pmsIdentifier'],
                plexPass: settingsMap['plexPass'],
                dateFormat: settingsMap['dateFormat'],
                timeFormat: settingsMap['timeFormat'],
                onesignalRegistered: settingsMap['onesignalRegistered'],
                customHeaders: server.customHeaders,
              ),
            );
          }
        },
      );
    }
  }

  Future<Map<String, dynamic>> _getServerInformation(
    NewServerModel server,
  ) async {
    Map<String, dynamic> settingsMap = {
      'needsUpdate': false,
      'plexPass': null,
      'pmsName': null,
      'pmsIdentifier': null,
      'dateFormat': null,
      'timeFormat': null,
      'onesignalRegistered': server.onesignalRegistered,
    };

    // Check for changes to plexPass or pmsName
    final failureOrPlexServerInfo = await settings.getPlexServerInfo(
      server.tautulliId,
    );
    print('GET SERVER INFO');
    failureOrPlexServerInfo.fold(
      (failure) {
        //TODO: Log error
      },
      (apiResponseData) {
        final NewPlexServerInfoModel plexServerInfo = apiResponseData.data;

        settingsMap['pmsName'] = plexServerInfo.pmsName;
        settingsMap['pmsIdentifier'] = plexServerInfo.pmsIdentifier;
        switch (plexServerInfo.pmsPlexpass) {
          case (0):
            settingsMap['plexPass'] = false;
            break;
          case (1):
            settingsMap['plexPass'] = true;
            break;
        }

        if (server.plexName != plexServerInfo.pmsName ||
            server.plexPass != settingsMap['plexPass'] ||
            server.plexIdentifier != plexServerInfo.pmsIdentifier) {
          settingsMap['needsUpdate'] = true;
        }
      },
    );

    // Check for changes to Tautulli Server settings
    final failureOrTautulliSettings = await settings.getTautulliSettings(
      server.tautulliId,
    );
    failureOrTautulliSettings.fold(
      (failure) {
        //TODO: Log error
      },
      (apiResponseData) {
        final NewTautulliSettingsGeneralModel tautulliSettings =
            apiResponseData.data;

        settingsMap['dateFormat'] = tautulliSettings.dateFormat;
        settingsMap['timeFormat'] = tautulliSettings.timeFormat;

        if (server.dateFormat != settingsMap['dateFormat'] ||
            server.timeFormat != settingsMap['timeFormat']) {
          settingsMap['needsUpdate'] = true;
        }
      },
    );

    //TODO: Add check for OneSignal

    return settingsMap;
  }
}
